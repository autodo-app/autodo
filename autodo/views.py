from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse
from django.views import generic
from django.contrib.auth import mixins
import requests 

from autodo.models import Greeting, Car
from autodo.forms import AddCarForm

catchall = generic.TemplateView.as_view(template_name='index.html')

# Create your views here.
def index(request):
    cars_list = Car.objects.order_by("-id")
    return render(request, "cars/index.html", {"cars_list": cars_list})
    # return render(request, "index.html")

# Order matters here, mixin needs to be first
class ListView(mixins.LoginRequiredMixin, generic.ListView):
    model = Car
    template_name = "cars/index.html"

    def get_queryset(self):
        return Car.objects.filter(owner=self.request.user)

class DetailView(mixins.LoginRequiredMixin, generic.DetailView):
    model = Car 
    template_name = "cars/detail.html"

class CarCreate(generic.CreateView):
    model = Car 
    form_class = AddCarForm
    # fields = ['name', 'make', 'model', 'year', 'plate', 'vin', 'color']
    initial = {'year': '2020'}
    template_name = "cars/car_form.html"

# class AuthorCreate(CreateView):
#     model = Author
#     fields = ['first_name', 'last_name', 'date_of_birth', 'date_of_death']
#     initial = {'date_of_death': '11/06/2020'}

# class AuthorUpdate(UpdateView):
#     model = Author
#     fields = '__all__' # Not recommended (potential security issue if more fields added)

# class AuthorDelete(DeleteView):
#     model = Author
#     success_url = reverse_lazy('authors')

def rename(request, car_id):
    car = get_object_or_404(Car, pk=car_id)
    if (request.POST['name'] == ""):
        # Redisplay the question voting form.
        return render(request, 'cars/detail.html', {
            'car': car,
            'error_message': "Your car needs a name.",
        })
    else:
        car.name = request.POST['name']
        car.make = request.POST['make']
        car.model = request.POST['model']
        if request.POST['year'] != "":
            car.year = int(request.POST['year']) 
        car.plate = request.POST['plate']
        car.vin = request.POST['vin']
        car.color = request.POST['color']
        car.save()
        # Always return an HttpResponseRedirect after successfully dealing
        # with POST data. This prevents data from being posted twice if a
        # user hits the Back button.
        return HttpResponseRedirect(reverse('cars/detail', args=(car.id,)))

def db(request):

    greeting = Greeting()
    greeting.save()

    greetings = Greeting.objects.all()

    return render(request, "db.html", {"greetings": greetings})
