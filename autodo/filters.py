import django_filters
from django import forms

from autodo.models import Todo

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
    # due_date = django_filters.DateTimeFilter(field_name="dueDate", lookup_expr="lt")
    # due_mileage = django_filters.NumberField(field_name="dueMileage", lookup_expr="lt")

    class Meta:
        model = Todo
        fields = ["complete"]
