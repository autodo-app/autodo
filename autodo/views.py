import sys
import json

from django.shortcuts import render, get_object_or_404, redirect
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse, reverse_lazy
from django import views
from django.views import generic
from django.contrib.auth import mixins, authenticate, login
from django.utils import timezone
from django.contrib import messages
from django.core.serializers import serialize
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from dateutil import relativedelta

import requests
from extra_views import (
    CreateWithInlinesView,
    UpdateWithInlinesView,
    NamedFormsetsMixin,
    InlineFormSetFactory,
)
from shapeshifter.views import MultiModelFormView

from autodo.models import Car, OdomSnapshot, Refueling, Todo
from autodo.forms import (
    AddCarForm,
    AddOdomSnapshotForm,
    OdomMileageOnlyFormset,
    RefuelingCreateFormset,
    RegisterForm,
    AddTodoForm,
    RefuelingForm,
    CompletionOdomSnapshotForm,
)
from autodo.utils import (
    find_odom,
    create_defaults,
    add_mileage_to_due,
    car_color_palette,
    add_delta_time,
)


def landing_page(request):
    if request.user.is_authenticated:
        return HttpResponseRedirect("cars/")
    return render(request, template_name="index.html")


def add_odom(car, snaps):
    car.mileage = find_odom(car, snaps)
    return car


# Order matters here, mixin needs to be first
class CarListView(mixins.LoginRequiredMixin, generic.ListView):
    model = Car

    def get_queryset(self):
        snaps = OdomSnapshot.objects.filter(owner=self.request.user)
        cars = Car.objects.filter(owner=self.request.user)
        for car in cars:
            add_odom(car, snaps)
        return cars

    def get_context_data(self, **kwargs):
        context = super(generic.ListView, self).get_context_data(**kwargs)
        return context


class CarDetailView(mixins.LoginRequiredMixin, generic.DetailView):
    model = Car

    def get_object(self):
        snaps = OdomSnapshot.objects.filter(owner=self.request.user)
        car = get_object_or_404(Car, pk=self.kwargs["pk"])
        add_odom(car, snaps)
        return car


class CarCreate(CreateWithInlinesView, NamedFormsetsMixin):
    model = Car
    inlines = [OdomMileageOnlyFormset]
    inline_names = ["OdomMileageOnlyFormset"]
    form_class = AddCarForm
    success_url = reverse_lazy("cars")

    def get_initial(self):
        car_count = Car.objects.filter(owner=self.request.user).count()
        color_idx = car_count % len(car_color_palette)
        return {"year": "2020", "color": car_color_palette[color_idx]}

    def forms_valid(self, form, inlines):
        form.instance.owner = self.request.user
        # Access the one form on the first inline
        inlines[0].forms[0].instance.owner = self.request.user
        inlines[0].forms[0].instance.date = timezone.now()

        # save the form and use the newly created car to create the default todos
        response = super().forms_valid(form, inlines)
        create_defaults(
            self.request.user, self.object, OdomSnapshot.objects.filter(car=self.object)
        )
        return response


class CarUpdate(mixins.LoginRequiredMixin, generic.UpdateView):
    model = Car
    form_class = AddCarForm
    success_url = reverse_lazy("cars")


class CarDelete(mixins.LoginRequiredMixin, generic.DeleteView):
    model = Car
    success_url = reverse_lazy("cars")


class RefuelingListView(mixins.LoginRequiredMixin, generic.ListView):
    model = Refueling

    def get_queryset(self):
        return Refueling.objects.filter(owner=self.request.user).order_by(
            "-odomSnapshot__date"
        )


class RefuelingDetailView(mixins.LoginRequiredMixin, generic.DetailView):
    model = Refueling


class RefuelingCreate(mixins.LoginRequiredMixin, MultiModelFormView):
    form_classes = (AddOdomSnapshotForm, RefuelingForm)
    template_name = "autodo/odomsnapshot_form.html"
    initial = {"addodomsnapshotform": {"date": timezone.now()}}
    success_url = reverse_lazy("refuelings")

    def get_forms(self):
        # override the form class instantiation to specify the car queryset
        form = AddOdomSnapshotForm(**self.get_form_kwargs(AddOdomSnapshotForm))
        form.fields["car"].queryset = Car.objects.filter(owner=self.request.user)
        return {
            "addodomsnapshotform": form,
            "refuelingform": RefuelingForm(**self.get_form_kwargs(RefuelingForm)),
        }

    def get_context_data(self, **kwargs):
        data = super().get_context_data(**kwargs)
        snaps = OdomSnapshot.objects.filter(owner=self.request.user)
        cars = Car.objects.filter(owner=self.request.user)
        data["cars"] = serialize("json", cars)
        data["snaps"] = serialize("json", snaps)
        if self.request.POST:
            data["refueling"] = RefuelingCreateFormset(self.request.POST)
        else:
            data["refueling"] = RefuelingCreateFormset()
        return data

    def forms_valid(self):
        forms = self.get_forms()
        snapshot_form = forms["addodomsnapshotform"]
        refueling_form = forms["refuelingform"]

        s = snapshot_form.save(commit=False)
        s.owner = self.request.user
        s.save()

        r = refueling_form.save(commit=False)
        r.owner = self.request.user
        r.odomSnapshot = s
        r.save()

        return HttpResponseRedirect(self.success_url)


class RefuelingUpdate(mixins.LoginRequiredMixin, MultiModelFormView):
    form_classes = (AddOdomSnapshotForm, RefuelingForm)
    template_name = "autodo/odomsnapshot_form.html"
    success_url = reverse_lazy("refuelings")

    def get_forms(self):
        # override the form class instantiation to specify the car queryset
        form = AddOdomSnapshotForm(**self.get_form_kwargs(AddOdomSnapshotForm))
        form.fields["car"].queryset = Car.objects.filter(owner=self.request.user)
        return {
            "addodomsnapshotform": form,
            "refuelingform": RefuelingForm(**self.get_form_kwargs(RefuelingForm)),
        }

    def get_instances(self):
        r = Refueling.objects.get(pk=self.kwargs["pk"])
        snap = OdomSnapshot.objects.get(pk=r.odomSnapshot.id)

        instances = {
            "addodomsnapshotform": snap,
            "refuelingform": r,
        }
        return instances


class OdomSnapshotDelete(mixins.LoginRequiredMixin, generic.DeleteView):
    model = OdomSnapshot
    success_url = reverse_lazy("refuelings")


def sort_fn(t):
    try:
        return t.delta_due_mileage
    except:
        return t.id


class TodoListView(mixins.LoginRequiredMixin, generic.ListView):
    model = Todo

    def get_context_data(self, **kwargs):
        data = super().get_context_data(**kwargs)
        # sort the todo list items here so we still return a proper queryset below
        todo_list = list(data["object_list"])
        data["object_list"] = sorted(todo_list, key=sort_fn)
        snaps = OdomSnapshot.objects.filter(owner=self.request.user)
        for t in data["object_list"]:
            t.car.mileage = find_odom(t.car, snaps)
        return data

    def get_queryset(self):
        snaps = OdomSnapshot.objects.filter(owner=self.request.user)
        todos = Todo.objects.filter(owner=self.request.user)
        for t in todos:
            add_mileage_to_due(t, t.car, snaps)
            add_delta_time(t)
        return todos


@csrf_exempt
@require_http_methods(["PATCH"])
def todoComplete(request, pk):
    # Get the params from the payload.
    data = json.loads(request.body.decode("utf-8"))

    todo = Todo.objects.get(pk=pk)

    # Update the model
    if "completed" in data:
        todo.complete = data["completed"]
        if todo.complete and todo.completionOdomSnapshot is None:
            # create the snapshot for this todo
            snap = OdomSnapshot()
            snap.owner = request.user
            snap.car = todo.car
            snap.date = timezone.now()
            snap.mileage = (
                OdomSnapshot.objects.filter(car=todo.car)
                .order_by("-mileage")[0]
                .mileage
            )
            snap.save()

            todo.completionOdomSnapshot = snap

            if todo.mileageRepeatInterval:
                newTodo = Todo(
                    car=todo.car,
                    owner=todo.owner,
                    name=todo.name,
                    dueMileage=(snap.mileage + todo.mileageRepeatInterval),
                    notes=todo.notes,
                    mileageRepeatInterval=todo.mileageRepeatInterval,
                )
                newTodo.save()
            elif todo.daysRepeatInterval:
                newTodo = Todo(
                    car=todo.car,
                    owner=todo.owner,
                    name=todo.name,
                    dueDate=timezone.now()
                    + timezone.timedelta(days=todo.daysRepeatInterval),
                    notes=todo.notes,
                    mileageRepeatInterval=todo.mileageRepeatInterval,
                )
                newTodo.save()
            elif todo.monthsRepeatInterval:
                newTodo = Todo(
                    car=todo.car,
                    owner=todo.owner,
                    name=todo.name,
                    dueDate=timezone.now()
                    + relativedelta.relativedelta(months=+todo.monthsRepeatInterval),
                    notes=todo.notes,
                    mileageRepeatInterval=todo.mileageRepeatInterval,
                )
                newTodo.save()
            elif todo.yearsRepeatInterval:
                newTodo = Todo(
                    car=todo.car,
                    owner=todo.owner,
                    name=todo.name,
                    dueDate=timezone.now()
                    + timezone.timedelta(years=todo.yearsRepeatInterval),
                    notes=todo.notes,
                    mileageRepeatInterval=todo.mileageRepeatInterval,
                )
                newTodo.save()
        elif not todo.complete and todo.completionOdomSnapshot is not None:
            # delete the snapshot
            todo.completionOdomSnapshot.delete()
            todo.completionOdomSnapshot = None
    elif "mileage" in data:
        if todo.completionOdomSnapshot is None:
            print("this should not happen")
        try:
            todo.completionOdomSnapshot.mileage = float(data["mileage"])
        except e:
            pass
        todo.completionOdomSnapshot.save()

    todo.save()

    return JsonResponse({})


class TodoDetailView(mixins.LoginRequiredMixin, generic.DetailView):
    model = Todo


class TodoCreate(mixins.LoginRequiredMixin, MultiModelFormView):
    form_classes = (
        AddTodoForm,
        CompletionOdomSnapshotForm,
    )
    template_name = "autodo/todo_form.html"
    success_url = reverse_lazy("home")
    initial = {
        "addtodoform": {
            "repeat_num": 0,
            "repeat_choice": "MILE",
        },
        "completionodomsnapshotform": {
            "date": timezone.now(),
        },
    }

    def get_context_data(self, **kwargs):
        data = super().get_context_data(**kwargs)
        snaps = OdomSnapshot.objects.filter(owner=self.request.user)
        cars = Car.objects.filter(owner=self.request.user)
        data["cars"] = serialize("json", cars)
        data["snaps"] = serialize("json", snaps)
        return data

    def get_forms(self):
        # TODO: dynamically show/hide snapshot based on checkbox

        snapForm = CompletionOdomSnapshotForm(
            **self.get_form_kwargs(CompletionOdomSnapshotForm)
        )
        todoForm = AddTodoForm(**self.get_form_kwargs(AddTodoForm))
        todoForm.fields["car"].queryset = Car.objects.filter(owner=self.request.user)
        return {
            "addtodoform": todoForm,
            "completionodomsnapshotform": snapForm,
        }

    def validate_forms(self):
        forms = self.get_forms()
        todo_valid = forms["addtodoform"].is_valid()
        snap_valid = True
        if forms["completionodomsnapshotform"]:
            snap_valid = forms["completionodomsnapshotform"].is_valid()
        return todo_valid and snap_valid

    def forms_valid(self):
        forms = self.get_forms()
        todo_form = forms["addtodoform"]
        snap_form = forms["completionodomsnapshotform"]

        t = todo_form.save(commit=False)
        t.owner = self.request.user
        sys.stdout.flush()

        if snap_form:
            s = snap_form.save(commit=False)
            s.owner = self.request.user
            s.save()
            t.completionOdomSnapshot = s

        t.save()

        return HttpResponseRedirect(self.success_url)


class TodoUpdate(mixins.LoginRequiredMixin, MultiModelFormView):
    form_classes = (
        AddTodoForm,
        CompletionOdomSnapshotForm,
    )
    template_name = "autodo/todo_form.html"
    success_url = reverse_lazy("home")

    def get_initial(self):
        instances = self.get_instances()
        t = instances["addtodoform"]

        repeat_num = None
        repeat_choice = None
        if t.mileageRepeatInterval:
            repeat_num = t.mileageRepeatInterval
            repeat_choice = "MILE"
        elif t.yearsRepeatInterval:
            repeat_num = t.yearsRepeatInterval
            repeat_choice = "YEAR"
        elif t.monthsRepeatInterval:
            repeat_num = t.monthsRepeatInterval
            repeat_choice = "MNTH"
        elif t.daysRepeatInterval and not t.daysRepeatInterval % 7:
            repeat_num = t.daysRepeatInterval / 7
            repeat_choice = "WEEK"
        elif t.daysRepeatInterval:
            repeat_num = t.daysRepeatInterval
            repeat_choice = "DAY"

        return {
            "addtodoform": {
                "repeat_num": repeat_num,
                "repeat_choice": repeat_choice,
            },
        }

    def get_forms(self):
        snapForm = None
        if self.get_instances()["addtodoform"].complete:
            snapForm = CompletionOdomSnapshotForm(
                **self.get_form_kwargs(CompletionOdomSnapshotForm)
            )
        todoForm = AddTodoForm(**self.get_form_kwargs(AddTodoForm))
        todoForm.fields["car"].queryset = Car.objects.filter(owner=self.request.user)
        return {
            "addtodoform": todoForm,
            "completionodomsnapshotform": snapForm,
        }

    def get_instances(self):
        t = Todo.objects.get(pk=self.kwargs["pk"])
        snap = None
        if t.completionOdomSnapshot:
            snap = OdomSnapshot.objects.get(pk=t.completionOdomSnapshot.id)

        return {
            "addtodoform": t,
            "completionodomsnapshotform": snap,
        }

    def validate_forms(self):
        forms = self.get_forms()
        todo_valid = forms["addtodoform"].is_valid()
        snap_valid = True
        if forms["completionodomsnapshotform"]:
            snap_valid = forms["completionodomsnapshotform"].is_valid()
        return todo_valid and snap_valid

    def forms_valid(self):
        forms = self.get_forms()
        todo_form = forms["addtodoform"]
        snap_form = forms["completionodomsnapshotform"]

        t = todo_form.save(commit=False)
        sys.stdout.flush()

        if snap_form:
            s = snap_form.save(commit=False)
            s.save()
            t.completionOdomSnapshot = s

        t.save()

        return HttpResponseRedirect(self.success_url)


class TodoDelete(mixins.LoginRequiredMixin, generic.DeleteView):
    model = Todo
    success_url = reverse_lazy("todos")


def register(request):
    if request.method == "POST":
        f = RegisterForm(request.POST)
        if f.is_valid():
            f.save()
            new_user = authenticate(
                username=f.cleaned_data["username"],
                password=f.cleaned_data["password1"],
                email=f.cleaned_data["username"],
            )
            login(request, new_user)
            return redirect("cars")

    else:
        f = RegisterForm()

    return render(request, "registration/register.html", {"form": f})


class Stats(mixins.LoginRequiredMixin, views.View):
    def get(self, request):
        return render(request, "autodo/stats.html")
