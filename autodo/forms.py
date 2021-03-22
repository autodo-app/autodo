from django import forms
from django.forms.models import inlineformset_factory
from django.contrib.auth.forms import UserCreationForm
from extra_views import InlineFormSetFactory
import sys

from autodo.models import Car, OdomSnapshot, User, Refueling, Todo

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
    "w-9/12",
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


class AddOdomSnapshotForm(forms.ModelForm):
    """Use this to create a refueling because the foreign key needs to point in this direction."""

    # def clean_year(self):
    #   return self.cleaned_data['year']

    class Meta:
        model = OdomSnapshot
        exclude = ["owner"]
        widgets = {
            "car": forms.Select(attrs={"class": default_form_class, "required": True}),
            "date": forms.DateInput(
                attrs={"class": default_form_class, "type": "date"}
            ),
            "mileage": forms.NumberInput(attrs={"class": default_form_class}),
        }


class OdomMileageOnlyFormset(InlineFormSetFactory):
    model = OdomSnapshot
    fields = ["mileage"]
    factory_kwargs = {
        "extra": 1,
        "can_delete": False,
        ""
        "widgets": {
            "mileage": forms.NumberInput(
                attrs={"class": default_form_class, "required": True}
            ),
        },
    }


class RefuelingFormset(InlineFormSetFactory):
    model = Refueling
    fields = ["cost", "amount"]
    factory_kwargs = {
        "extra": 1,
        "can_delete": False,
        "widgets": {
            "cost": forms.NumberInput(
                attrs={"class": default_form_class, "required": True}
            ),
            "amount": forms.NumberInput(
                attrs={"class": default_form_class, "required": True}
            ),
        },
    }


RefuelingCreateFormset = inlineformset_factory(
    OdomSnapshot,
    Refueling,
    fields=("cost", "amount"),
    widgets={
        "cost": forms.NumberInput(
            attrs={"class": default_form_class, "required": True}
        ),
        "amount": forms.NumberInput(
            attrs={"class": default_form_class, "required": True}
        ),
    },
    extra=1,
    can_delete=False,
)
RefuelingEditFormset = inlineformset_factory(
    OdomSnapshot, Refueling, fields=("cost", "amount"), extra=0, can_delete=False
)


class AddTodoForm(forms.ModelForm):
    # def clean_year(self):
    #   return self.cleaned_data['year']

    class Meta:
        model = Todo
        # exclude = ["owner"]
        fields = ["car", "name", "dueMileage", "dueDate"]
        widgets = {
            "car": forms.Select(attrs={"class": default_form_class, "required": True}),
            "name": forms.TextInput(attrs={"class": default_form_class}),
            "dueMileage": forms.NumberInput(attrs={"class": default_form_class}),
            "dueDate": forms.DateInput(
                attrs={"class": default_form_class, "type": "date"}
            ),
        }


class RegisterForm(UserCreationForm):
    class Meta:
        model = User
        fields = ("username", "password1", "password2")
