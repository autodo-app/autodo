from django.forms import ModelForm

from autodo.models import Car

class AddCarForm(ModelForm):
  def clean_year(self):
    return self.cleaned_data['year']

  class Meta:
    model = Car
    exclude = ['owner']
