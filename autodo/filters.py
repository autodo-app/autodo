import sys

import django_filters
from django import forms

from autodo.utils import find_odom, add_delta_time, add_mileage_to_due
from autodo.models import Todo, OdomSnapshot

default_form_classes = [
    "bg-gray-50",
    "my-2",
    "py-1",
    "pl-2",
    "pr-6",
    "border",
    "border-gray-400",
    "rounded",
    "focus:outline-none",
    "focus:border-blue-500",
    "placeholder-gray-500",
]
default_form_class = " ".join(default_form_classes)


class TodoFilter(django_filters.FilterSet):
    complete = django_filters.BooleanFilter(
        field_name="complete",
        label="Filter",
        initial=False,
        widget=forms.Select(
            choices=[
                ("", "All"),
                (True, "Completed"),
                (False, "Upcoming"),
            ],
            attrs={"onchange": "this.form.submit()", "class": default_form_class},
        ),
    )

    class Meta:
        model = Todo
        fields = ["complete"]

    @property
    def qs(self):
        parent = super().qs
        owner = getattr(self.request, "user", None)
        # print(vars(self))
        # sys.stdout.flush()
        snaps = OdomSnapshot.objects.filter(owner=owner)
        for t in parent:
            t.car.mileage = find_odom(t.car, snaps)
            add_mileage_to_due(t, t.car, snaps)
            add_delta_time(t)

        return parent
