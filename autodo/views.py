from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse
from django.views import generic
import requests 

from autodo.models import Greeting, Car

catchall = generic.TemplateView.as_view(template_name='index.html')

# Create your views here.
def index(request):
    cars_list = Car.objects.order_by("-id")
    return render(request, "cars/index.html", {"cars_list": cars_list})
    # return render(request, "index.html")

class ListView(generic.ListView):
    model = Car
    template_name = "cars/index.html"
    # queryset = Car.objects.filter(owner=self.request.user)

class DetailView(generic.DetailView):
    model = Car 
    template_name = "cars/detail.html"

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
