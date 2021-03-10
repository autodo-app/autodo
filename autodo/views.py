import sys

from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse, reverse_lazy
from django.views import generic
from django.contrib.auth import mixins
from django.utils import timezone
import requests
from extra_views import CreateWithInlinesView, NamedFormsetsMixin

from autodo.models import Car, OdomSnapshot
from autodo.forms import AddCarForm, ChildFormset

catchall = generic.TemplateView.as_view(template_name="index.html")

# Order matters here, mixin needs to be first
class ListView(mixins.LoginRequiredMixin, generic.ListView):
    model = Car

    def get_queryset(self):
        return Car.objects.filter(owner=self.request.user)

    def get_context_data(self, **kwargs):
        context = super(ListView, self).get_context_data(**kwargs)
        return context


class DetailView(mixins.LoginRequiredMixin, generic.DetailView):
    model = Car


# class CarCreate(mixins.LoginRequiredMixin, generic.CreateView):
#     model = Car
#     form_class = AddCarForm
#     initial = {'year': '2020'}
#     success_url = reverse_lazy('cars')

#     def form_valid(self, form):
#         form.instance.owner = self.request.user
#         return super(CarCreate, self).form_valid(form)


class CarCreate(CreateWithInlinesView, NamedFormsetsMixin):
    model = Car
    inlines = [ChildFormset]
    inline_names = ["ChildFormset"]
    form_class = AddCarForm
    initial = {"year": "2020"}
    success_url = reverse_lazy("cars")

    def forms_valid(self, form, inlines):
        print(vars(inlines[0].forms[0]))
        sys.stdout.flush()
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
