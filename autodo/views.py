from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse, reverse_lazy
from django.views import generic
from django.contrib.auth import mixins
import requests 

from autodo.models import Greeting, Car
from autodo.forms import AddCarForm

catchall = generic.TemplateView.as_view(template_name='index.html')

# Order matters here, mixin needs to be first
class ListView(mixins.LoginRequiredMixin, generic.ListView):
    model = Car
    template_name = "cars/index.html"

    def get_queryset(self):
        return Car.objects.filter(owner=self.request.user)

class DetailView(mixins.LoginRequiredMixin, generic.DetailView):
    model = Car 

class CarCreate(mixins.LoginRequiredMixin, generic.CreateView):
    model = Car 
    form_class = AddCarForm
    initial = {'year': '2020'}
    success_url = reverse_lazy('cars')

    def form_valid(self, form):
        form.instance.owner = self.request.user 
        return super(CarCreate, self).form_valid(form)

class CarUpdate(mixins.LoginRequiredMixin, generic.UpdateView):
    model = Car
    form_class = AddCarForm

class CarDelete(mixins.LoginRequiredMixin, generic.DeleteView):
    model = Car
    success_url = reverse_lazy('cars')
