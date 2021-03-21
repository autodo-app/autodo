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
from extra_views import CreateWithInlinesView, UpdateWithInlinesView, NamedFormsetsMixin

from autodo.models import Car, OdomSnapshot, Refueling, Todo
from autodo.forms import (
    AddCarForm,
    AddOdomSnapshotForm,
    OdomMileageOnlyFormset,
    RefuelingFormset,
    RefuelingCreateFormset,
    RefuelingEditFormset,
    RegisterForm,
    AddTodoForm,
)

catchall = generic.TemplateView.as_view(template_name="index.html")


def landing_page(request):
    if request.user.is_authenticated:
        return HttpResponseRedirect("cars/")
    return render(request, template_name="index.html")


def add_odom(car, snaps):
    car_snaps = snaps.filter(car=car.id).order_by("-mileage")
    if len(car_snaps) == 0:
        print("We really shouldn't have cars without mileage")
        return car
    car.mileage = car_snaps[0].mileage
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
    initial = {"year": "2020"}
    success_url = reverse_lazy("cars")

    def forms_valid(self, form, inlines):
        form.instance.owner = self.request.user
        # Access the one form on the first inline
        inlines[0].forms[0].instance.owner = self.request.user
        inlines[0].forms[0].instance.date = timezone.now()

        return super().forms_valid(form, inlines)


class CarUpdate(mixins.LoginRequiredMixin, generic.UpdateView):
    model = Car
    form_class = AddCarForm


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

    # def get_object(self):
    #     snaps = OdomSnapshot.objects.filter(owner=self.request.user)
    #     car = get_object_or_404(Car, pk=self.kwargs["pk"])
    #     add_odom(car, snaps)
    #     return car


class RefuelingCreate(mixins.LoginRequiredMixin, generic.CreateView):
    model = OdomSnapshot
    form_class = AddOdomSnapshotForm

    def get_context_data(self, **kwargs):
        data = super().get_context_data(**kwargs)
        if self.request.POST:
            data["refueling"] = RefuelingCreateFormset(self.request.POST)
        else:
            data["refueling"] = RefuelingCreateFormset()
        return data

    def form_valid(self, form):
        context = self.get_context_data(form=form)
        refueling = context["refueling"]
        form.instance.owner = self.request.user
        self.object = form.save()

        if refueling.is_valid():
            refueling.instance = self.object
            # refueling.instance.owner = self.request.user
            r = refueling.save(commit=False)[0]
            r.owner = self.request.user
            r.save()

        return super().form_valid(form)

    def get_success_url(self):
        return reverse("refuelings")


class RefuelingUpdate(mixins.LoginRequiredMixin, generic.UpdateView):
    model = OdomSnapshot
    form_class = AddOdomSnapshotForm

    def get_context_data(self, **kwargs):
        data = super().get_context_data(**kwargs)
        if self.request.POST:
            data["refueling"] = RefuelingEditFormset(
                self.request.POST, instance=self.object
            )
        else:
            data["refueling"] = RefuelingEditFormset(instance=self.object)
        return data

    def form_valid(self, form):
        context = self.get_context_data()
        refueling = context["refueling"]
        self.object = form.save()
        if refueling.is_valid():
            refueling.instance = self.object
            refueling.save()
        return super().form_valid(form)

    def get_success_url(self):
        return reverse("refuelings")


class OdomSnapshotDelete(mixins.LoginRequiredMixin, generic.DeleteView):
    model = OdomSnapshot
    success_url = reverse_lazy("refuelings")


class TodoListView(mixins.LoginRequiredMixin, generic.ListView):
    model = Todo

    def get_queryset(self):
        return Todo.objects.filter(owner=self.request.user)


class TodoDetailView(mixins.LoginRequiredMixin, generic.DetailView):
    model = Todo

    # def get_object(self):
    #     snaps = OdomSnapshot.objects.filter(owner=self.request.user)
    #     car = get_object_or_404(Car, pk=self.kwargs["pk"])
    #     add_odom(car, snaps)
    #     return car


class TodoCreate(mixins.LoginRequiredMixin, generic.CreateView):
    model = Todo
    form_class = AddTodoForm
    success_url = reverse_lazy("todos")

    def get_context_data(self, **kwargs):
        data = super().get_context_data(**kwargs)
        snaps = OdomSnapshot.objects.filter(owner=self.request.user)
        cars = Car.objects.filter(owner=self.request.user)
        data["cars"] = serialize("json", cars)
        data["snaps"] = serialize("json", snaps)
        # todo: add the data manually onto the json here
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
