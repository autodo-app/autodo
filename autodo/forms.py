from django import forms
from django.forms.models import inlineformset_factory
from extra_views import InlineFormSetFactory
import sys

from autodo.models import Car, OdomSnapshot

default_form_classes = [
    "bg-gray-50",
    "my-2",
    "py-1",
    "px-4",
    "border",
    "border-gray-400",
    "rounded",
    "focus:outline-none",
    "focus:border-blue-500",
    "placeholder-gray-500",
]
default_form_class = " ".join(default_form_classes)


class AddCarForm(forms.ModelForm):
    # def clean_year(self):
    #   return self.cleaned_data['year']

    class Meta:
        model = Car
        exclude = ["owner"]
        widgets = {
            "name": forms.TextInput(attrs={"class": default_form_class}),
            "make": forms.TextInput(attrs={"class": default_form_class}),
            "model": forms.TextInput(attrs={"class": default_form_class}),
            "year": forms.NumberInput(attrs={"class": default_form_class}),
            "plate": forms.TextInput(attrs={"class": default_form_class}),
            "vin": forms.TextInput(attrs={"class": default_form_class}),
            "color": forms.TextInput(
                attrs={
                    "type": "color",
                    "class": "bg-gray-50 w-12 my-2 py-1 px-4 border border-gray-400 rounded focus:outline-none focus:border-blue-500 placeholder-gray-500",
                }
            ),
        }


class ChildFormset(InlineFormSetFactory):
    model = OdomSnapshot
    fields = ["mileage"]
    factory_kwargs = {
        "extra": 1,
        "can_delete": False,
        "widgets": {
            "mileage": forms.NumberInput(
                attrs={"class": default_form_class, "required": True}
            ),
        },
    }
