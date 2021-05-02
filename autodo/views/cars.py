from django.contrib.auth import mixins
from django.views import generic
from django.shortcuts import get_object_or_404
from django.urls import reverse_lazy
from extra_views import NamedFormsetsMixin, CreateWithInlinesView

from autodo.models import Car, OdomSnapshot
from autodo.forms import AddCarForm, OdomMileageOnlyFormset
from autodo.utils import find_odom, car_color_palette, create_defaults


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
