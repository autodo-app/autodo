import sys

from django import forms
from django.forms.models import inlineformset_factory
from django.contrib.auth.forms import UserCreationForm
from extra_views import InlineFormSetFactory
from djmoney.forms.fields import MoneyField, MoneyWidget
from djmoney.settings import CURRENCY_CHOICES

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
    "w-full",
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

    class Meta:
        model = OdomSnapshot
        exclude = ["owner"]
        widgets = {
            "car": forms.Select(attrs={"class": default_form_class, "required": True}),
            "date": forms.DateInput(
                attrs={"class": default_form_class, "type": "date"}
            ),
            "mileage": forms.NumberInput(
                attrs={"class": default_form_class, "inputmode": "decimal"}
            ),
        }


class CompletionOdomSnapshotForm(forms.ModelForm):
    """Use this to modify a Todo's completion info"""

    class Meta:
        model = OdomSnapshot
        exclude = ["owner", "car"]
        labels = {"mileage": "Completion Mileage", "date": "Completion Date"}
        widgets = {
            "date": forms.DateInput(
                attrs={"class": default_form_class, "type": "date"}
            ),
            "mileage": forms.NumberInput(
                attrs={"class": default_form_class, "inputmode": "decimal"}
            ),
        }


class OdomMileageOnlyFormset(InlineFormSetFactory):
    model = OdomSnapshot
    fields = ["mileage"]
    factory_kwargs = {
        "extra": 1,
        "can_delete": False,
        "widgets": {
            "mileage": forms.NumberInput(
                attrs={
                    "class": default_form_class,
                    "required": True,
                    "inputmode": "decimal",
                }
            ),
        },
    }


class RefuelingForm(forms.ModelForm):
    """Use this to create a refueling because the foreign key needs to point in this direction."""

    cost = MoneyField(
        widget=MoneyWidget(
            amount_widget=forms.TextInput(
                attrs={
                    "class": " ".join(
                        [
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
                            "w-7/12",
                        ]
                    ),
                    "inputmode": "decimal",
                }
            ),
            currency_widget=forms.Select(
                choices=CURRENCY_CHOICES,
                attrs={
                    "class": " ".join(
                        [
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
                            "w-5/12",
                        ]
                    ),
                },
            ),
        )
    )

    class Meta:
        model = Refueling
        fields = ["cost", "amount"]
        widgets = {
            "amount": forms.NumberInput(
                attrs={"class": default_form_class, "inputmode": "decimal"}
            ),
        }


RefuelingCreateFormset = inlineformset_factory(
    OdomSnapshot,
    Refueling,
    fields=("cost", "amount"),
    widgets={
        "cost": forms.NumberInput(
            attrs={
                "class": default_form_class,
                "required": True,
                "inputmode": "decimal",
            }
        ),
        "amount": forms.NumberInput(
            attrs={
                "class": default_form_class,
                "required": True,
                "inputmode": "decimal",
            }
        ),
    },
    extra=1,
    can_delete=False,
)


class AddTodoForm(forms.ModelForm):
    repeat_num = forms.IntegerField(
        initial=0,
        widget=forms.NumberInput(
            attrs={"class": default_form_class, "inputmode": "decimal"}
        ),
    )
    repeat_choice = forms.ChoiceField(
        choices=[
            ("DAY", "Days"),
            ("WEEK", "Weeks"),
            ("MNTH", "Months"),
            ("YEAR", "Years"),
            ("MILE", "Miles"),
        ],
        initial="MILE",
        widget=forms.Select(attrs={"class": default_form_class}),
    )
    # set the default to repeat forever

    def save(self, commit=True):
        t = super().save(commit=False)
        if self.cleaned_data["repeat_num"] != 0:
            if self.cleaned_data["repeat_choice"] == "MILE":
                t.mileageRepeatInterval = self.cleaned_data["repeat_num"]
            elif self.cleaned_data["repeat_choice"] == "DAY":
                t.daysRepeatInterval = self.cleaned_data["repeat_num"]
            elif self.cleaned_data["repeat_choice"] == "WEEK":
                t.daysRepeatInterval = self.cleaned_data["repeat_num"] * 7
            elif self.cleaned_data["repeat_choice"] == "MNTH":
                t.monthsRepeatInterval = self.cleaned_data["repeat_num"]
            else:
                t.yearsRepeatInterval = self.cleaned_data["repeat_num"]
        t.save(commit=True)

    class Meta:
        model = Todo
        fields = [
            "car",
            "name",
            "dueMileage",
            "dueDate",
            "notes",
            "complete",
        ]
        widgets = {
            "car": forms.Select(attrs={"class": default_form_class, "required": True}),
            "name": forms.TextInput(attrs={"class": default_form_class}),
            "complete": forms.CheckboxInput(
                attrs={
                    "class": " ".join(
                        [
                            "bg-gray-50",
                            "my-auto",
                            "mx-0",
                            "ml-auto",
                            "p-3",
                            "right-0",
                            "border",
                            "border-gray-400",
                            "rounded",
                            "focus:ring-transparent",
                            "focus:border-blue-500",
                        ]
                    )
                }
            ),
            "dueMileage": forms.NumberInput(attrs={"class": default_form_class}),
            "dueDate": forms.DateInput(
                attrs={"class": default_form_class, "type": "date"}
            ),
            "notes": forms.Textarea(attrs={"class": default_form_class + " h-24"}),
        }


class RegisterForm(UserCreationForm):
    class Meta:
        model = User
        fields = ("username", "password1", "password2")
