from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect
from django.urls import reverse
import requests 

from .models import Greeting, Car

# Create your views here.
def index(request):
    cars_list = Car.objects.order_by("-id")
    return render(request, "cars/index.html", {"cars_list": cars_list})
    # return render(request, "index.html")

def detail(request, car_id):
    car = get_object_or_404(Car, pk=car_id)
    return render(request, "cars/detail.html", {"car": car})

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
