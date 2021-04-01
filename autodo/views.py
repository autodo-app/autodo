import sys
import json

from django.shortcuts import render, get_object_or_404, redirect
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse, reverse_lazy
from django.views import generic
from django.contrib.auth import mixins, authenticate, login
from django.utils import timezone
from django.contrib import messages
from django.core.serializers import serialize

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
)
from autodo.utils import (
    find_odom,
    create_defaults,
    add_mileage_to_due,
    car_color_palette,
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
    template_name = "autodo/odomsnapshot_edit.html"
    initial = {"date": timezone.now()}
    success_url = reverse_lazy("refuelings")

    def get_forms(self):
        # override the form class instantiation to specify the car queryset
        form = AddOdomSnapshotForm()
        form.fields["car"].queryset = Car.objects.filter(owner=self.request.user)
        return {
            "addodomsnapshotform": form,
            "refuelingform": RefuelingForm(),
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
    template_name = "autodo/odomsnapshot_edit.html"
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
        sys.stdout.flush()

        instances = {
            "addodomsnapshotform": snap,
            "refuelingform": r,
        }
        return instances


class OdomSnapshotDelete(mixins.LoginRequiredMixin, generic.DeleteView):
    model = OdomSnapshot
    success_url = reverse_lazy("refuelings")


class TodoListView(mixins.LoginRequiredMixin, generic.ListView):
    model = Todo

    def get_context_data(self, **kwargs):
        data = super().get_context_data(**kwargs)
        # sort the todo list items here so we still return a proper queryset below
        todo_list = list(data["object_list"])
        data["object_list"] = sorted(todo_list, key=lambda t: t.delta_due_mileage)
        return data

    def get_queryset(self):
        snaps = OdomSnapshot.objects.filter(owner=self.request.user)
        todos = Todo.objects.filter(owner=self.request.user)
        for t in todos:
            add_mileage_to_due(t, t.car, snaps)
        return todos


class TodoDetailView(mixins.LoginRequiredMixin, generic.DetailView):
    model = Todo


class TodoCreate(mixins.LoginRequiredMixin, generic.CreateView):
    model = Todo
    form_class = AddTodoForm
    success_url = reverse_lazy("todos")

    def get_form(self):
        form = AddTodoForm()
        form.fields["car"].queryset = Car.objects.filter(owner=self.request.user)
        return form

    def get_context_data(self, **kwargs):
        data = super().get_context_data(**kwargs)
        snaps = OdomSnapshot.objects.filter(owner=self.request.user)
        cars = Car.objects.filter(owner=self.request.user)
        data["cars"] = serialize("json", cars)
        data["snaps"] = serialize("json", snaps)
        return data

    def get_form_kwargs(self):
        kwargs = super(TodoCreate, self).get_form_kwargs()
        if kwargs["instance"] is None:
            kwargs["instance"] = Todo()
        kwargs["instance"].owner = self.request.user
        return kwargs


class TodoUpdate(mixins.LoginRequiredMixin, generic.UpdateView):
    model = Todo
    form_class = AddTodoForm
    success_url = reverse_lazy("todos")

    def get_form(self):
        form = AddTodoForm(**self.get_form_kwargs())
        form.fields["car"].queryset = Car.objects.filter(owner=self.request.user)
        return form


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
            )
            login(request, new_user)
            return redirect("cars")

    else:
        f = RegisterForm()

    return render(request, "registration/register.html", {"form": f})
