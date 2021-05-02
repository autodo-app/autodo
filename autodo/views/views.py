import sys

from django.shortcuts import render, redirect
from django.http import HttpResponseRedirect
from django import views
from django.views import generic
from django.contrib.auth import mixins, authenticate, login

from autodo.models import User
from autodo.forms import RegisterForm, SettingsForm
from autodo.filters import TodoFilter


def landing_page(request):
    if request.user.is_authenticated:
        return HttpResponseRedirect("cars/")
    return render(request, template_name="index.html")


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


class ProfileScreen(mixins.LoginRequiredMixin, generic.DetailView):
    model = User
    context_object_name = "user_object"


class UserDelete(mixins.LoginRequiredMixin, generic.DeleteView):
    model = User
    success_url = "/"


class Settings(mixins.LoginRequiredMixin, views.View):
    def get(self, request):
        form = SettingsForm(
            initial={"email_notifications": request.user.email_notifications}
        )
        return render(request, "autodo/settings.html", {"form": form})

    def post(self, request):
        form = SettingsForm(request.POST)
        if form.is_valid():
            request.user.email_notifications = form.cleaned_data["email_notifications"]
            request.user.save()
            return HttpResponseRedirect("/settings")
        return render(request, "autodo/settings.html", {"form": form})
