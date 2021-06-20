import json

from dateutil import relativedelta
from django import views
from django.core.serializers import serialize
from django.contrib.auth import mixins
from django.views import generic
from django.shortcuts import get_object_or_404, render
from django.http import HttpResponseRedirect, JsonResponse
from django.urls import reverse_lazy
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from shapeshifter.views import MultiModelFormView

from autodo.models import Car, OdomSnapshot, Todo, TodoPart
from autodo.forms import CompletionOdomSnapshotForm, AddTodoForm, AddPartForm
from autodo.filters import TodoFilter


def sort_fn(t):
    try:
        return t.delta_due_mileage
    except:
        return t.id


class TodoListView(mixins.LoginRequiredMixin, views.View):
    def get(self, request, *args, **kwargs):
        f = TodoFilter(
            request.GET,
            queryset=Todo.objects.filter(owner=request.user),
            request=request,
        )
        object_list = sorted(list(f.qs), key=sort_fn)
        return render(
            request, "autodo/todo_list.html", {"filter": f, "object_list": object_list}
        )


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
        AddPartForm,
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
        
        if self.request.POST:
            data['addpartform'] = AddPartForm(self.request.POST)
        else:
            data['addpartform'] = AddPartForm()
        return data

    def get_forms(self):
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
        part_form = self.get_context_data()["addpartform"]

        t = todo_form.save(commit=False)
        t.owner = self.request.user

        if snap_form:
            s = snap_form.save(commit=False)
            s.owner = self.request.user
            s.save()
            t.completionOdomSnapshot = s

        if part_form:
            p = part_form.save(commit=False)
            p.todo = t
            p.save()

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
