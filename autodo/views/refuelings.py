from django.contrib.auth import mixins
from django.views import generic
from django.shortcuts import get_object_or_404
from django.http import HttpResponseRedirect
from django.urls import reverse_lazy
from django.core.serializers import serialize
from django.utils import timezone
from shapeshifter.views import MultiModelFormView

from autodo.models import Car, OdomSnapshot, Refueling
from autodo.forms import AddOdomSnapshotForm, RefuelingForm, RefuelingCreateFormset


class RefuelingListView(mixins.LoginRequiredMixin, generic.ListView):
    model = Refueling

    def get_queryset(self):
        return Refueling.objects.filter(owner=self.request.user).order_by(
            "-odomSnapshot__date"
        )


class RefuelingDetailView(mixins.LoginRequiredMixin, generic.DetailView):
    model = Refueling


class RefuelingCreate(mixins.LoginRequiredMixin, MultiModelFormView):
    form_classes = (AddOdomSnapshotForm, RefuelingForm)
    template_name = "autodo/odomsnapshot_form.html"
    initial = {"addodomsnapshotform": {"date": timezone.now()}}
    success_url = reverse_lazy("refuelings")

    def get_forms(self):
        # override the form class instantiation to specify the car queryset
        form = AddOdomSnapshotForm(**self.get_form_kwargs(AddOdomSnapshotForm))
        form.fields["car"].queryset = Car.objects.filter(owner=self.request.user)
        return {
            "addodomsnapshotform": form,
            "refuelingform": RefuelingForm(**self.get_form_kwargs(RefuelingForm)),
        }

    def get_context_data(self, **kwargs):
        data = super().get_context_data(**kwargs)
        snaps = OdomSnapshot.objects.filter(owner=self.request.user)
        cars = Car.objects.filter(owner=self.request.user)
        data["cars"] = serialize("json", cars)
        data["snaps"] = serialize("json", snaps)
        if self.request.POST:
            data["refueling"] = RefuelingCreateFormset(self.request.POST)
        else:
            data["refueling"] = RefuelingCreateFormset()
        return data

    def forms_valid(self):
        forms = self.get_forms()
        snapshot_form = forms["addodomsnapshotform"]
        refueling_form = forms["refuelingform"]

        s = snapshot_form.save(commit=False)
        s.owner = self.request.user
        s.save()

        r = refueling_form.save(commit=False)
        r.owner = self.request.user
        r.odomSnapshot = s
        r.save()

        return HttpResponseRedirect(self.success_url)


class RefuelingUpdate(mixins.LoginRequiredMixin, MultiModelFormView):
    form_classes = (AddOdomSnapshotForm, RefuelingForm)
    template_name = "autodo/odomsnapshot_form.html"
    success_url = reverse_lazy("refuelings")

    def get_forms(self):
        # override the form class instantiation to specify the car queryset
        form = AddOdomSnapshotForm(**self.get_form_kwargs(AddOdomSnapshotForm))
        form.fields["car"].queryset = Car.objects.filter(owner=self.request.user)
        return {
            "addodomsnapshotform": form,
            "refuelingform": RefuelingForm(**self.get_form_kwargs(RefuelingForm)),
        }

    def get_instances(self):
        r = Refueling.objects.get(pk=self.kwargs["pk"])
        snap = OdomSnapshot.objects.get(pk=r.odomSnapshot.id)

        instances = {
            "addodomsnapshotform": snap,
            "refuelingform": r,
        }
        return instances


class OdomSnapshotDelete(mixins.LoginRequiredMixin, generic.DeleteView):
    model = OdomSnapshot
    success_url = reverse_lazy("refuelings")
