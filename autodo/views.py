import sys

from django.shortcuts import render, get_object_or_404, redirect
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse, reverse_lazy
from django.views import generic
from django.contrib.auth import mixins, authenticate, login
from django.utils import timezone
from django.contrib import messages

import requests
from extra_views import CreateWithInlinesView, NamedFormsetsMixin

from autodo.models import Car, OdomSnapshot
from autodo.forms import AddCarForm, ChildFormset, RegisterForm

catchall = generic.TemplateView.as_view(template_name="index.html")


def add_odom(car, snaps):
    car_snaps = snaps.filter(car=car.id).order_by("-date", "-mileage")
    if len(car_snaps) == 0:
        print("We really shouldn't have cars without mileage")
        return car
    car.mileage = car_snaps[0].mileage
    return car


# Order matters here, mixin needs to be first
class ListView(mixins.LoginRequiredMixin, generic.ListView):
    model = Car

    def get_queryset(self):
        snaps = OdomSnapshot.objects.filter(owner=self.request.user)
        cars = Car.objects.filter(owner=self.request.user)
        for car in cars:
            add_odom(car, snaps)
        return cars

    def get_context_data(self, **kwargs):
        context = super(ListView, self).get_context_data(**kwargs)
        return context


class DetailView(mixins.LoginRequiredMixin, generic.DetailView):
    model = Car

    def get_object(self):
        snaps = OdomSnapshot.objects.filter(owner=self.request.user)
        car = get_object_or_404(Car, pk=self.kwargs["pk"])
        add_odom(car, snaps)
        return car


class CarCreate(CreateWithInlinesView, NamedFormsetsMixin):
    model = Car
    inlines = [ChildFormset]
    inline_names = ["ChildFormset"]
    form_class = AddCarForm
    initial = {"year": "2020"}
    success_url = reverse_lazy("cars")

    def forms_valid(self, form, inlines):
        form.instance.owner = self.request.user
        # Access the ome form on the first inline
        inlines[0].forms[0].instance.owner = self.request.user
        inlines[0].forms[0].instance.date = timezone.now()

        return super().forms_valid(form, inlines)


class CarUpdate(mixins.LoginRequiredMixin, generic.UpdateView):
    model = Car
    form_class = AddCarForm


class CarDelete(mixins.LoginRequiredMixin, generic.DeleteView):
    model = Car
    success_url = reverse_lazy("cars")


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
