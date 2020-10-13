"""CRUD endpoints for the models."""
from collections import defaultdict, Counter
from statistics import mean
from functools import reduce
from itertools import groupby

from django.contrib.auth import get_user_model
from rest_framework import generics, viewsets, permissions, mixins, views
from rest_framework.decorators import (
    api_view,
    permission_classes,
    authentication_classes,
)
from rest_framework.response import Response
from rest_registration.decorators import api_view_serializer_class_getter
from rest_registration.settings import registration_settings

from .models import Car, OdomSnapshot, Refueling, Todo
from .serializers import (
    CarSerializer,
    OdomSnapshotSerializer,
    RefuelingSerializer,
    TodoSerializer,
    FuelEfficiencySerializer,
    single_distance_rate,
)
from .permissions import IsOwner
import rest_framework.authentication as auth
from rest_framework_simplejwt.authentication import JWTAuthentication

PERMS = [permissions.IsAuthenticated, IsOwner]
AUTHS = [JWTAuthentication, auth.SessionAuthentication, auth.BasicAuthentication]


class CarsListViewSet(viewsets.ModelViewSet):
    """Exposes CRUD endpoints for the user's Car objects."""

    queryset = Car.objects.all()
    serializer_class = CarSerializer
    permission_classes = PERMS
    authentication_classes = AUTHS

    def get_queryset(self):
        """Only returns objects that are owned by the user making the request."""
        return self.queryset.filter(owner=self.request.user)

    def perform_create(self, serializer):
        """Save the data from the serializer."""
        serializer.save(owner=self.request.user)


class OdomSnapshotsListViewSet(viewsets.ModelViewSet):
    """Exposes CRUD endpoints for the user's Odom Snapshot objects."""

    queryset = OdomSnapshot.objects.all()
    serializer_class = OdomSnapshotSerializer
    permission_classes = PERMS
    authentication_classes = AUTHS

    def get_queryset(self):
        """Only returns objects that are owned by the user making the request."""
        return self.queryset.filter(owner=self.request.user)

    def perform_create(self, serializer):
        """Save the data from the serializer."""
        serializer.save(owner=self.request.user)


class RefuelingsListViewSet(viewsets.ModelViewSet):
    """Exposes CRUD endpoints for the user's Refueling objects."""

    queryset = Refueling.objects.all()
    serializer_class = RefuelingSerializer
    permission_classes = PERMS
    authentication_classes = AUTHS

    def get_queryset(self):
        """Only returns objects that are owned by the user making the request."""
        return self.queryset.filter(owner=self.request.user)

    def perform_create(self, serializer):
        """Save the data from the serializer."""
        serializer.save(owner=self.request.user)


class TodosListViewSet(viewsets.ModelViewSet):
    """Exposes CRUD endpoints for the user's Todo objects."""

    queryset = Todo.objects.all()
    serializer_class = TodoSerializer
    permission_classes = PERMS
    authentication_classes = AUTHS

    def get_queryset(self):
        """Only returns objects that are owned by the user making the request."""
        return self.queryset.filter(owner=self.request.user).order_by(
            "dueDate", "dueMileage"
        )

    def perform_create(self, serializer):
        """Save the data from the serializer."""
        serializer.save(owner=self.request.user)

    # TODO: allows for creating many in a batch
    # def create(self, request, *args, **kwargs):
    # serializer = self.get_serializer(data=request.data, many=isinstance(request.data,list))
    # serializer.is_valid(raise_exception=True)
    # self.perform_create(serializer)
    # headers = self.get_success_headers(serializer.data)
    # return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)


@api_view_serializer_class_getter(
    lambda: registration_settings.PROFILE_SERIALIZER_CLASS
)
@api_view(["GET", "POST", "PUT", "PATCH", "DELETE"])
@authentication_classes(AUTHS)
@permission_classes([permissions.IsAuthenticated])
def profile(request):
    """Get or set user profile."""
    serializer_class = registration_settings.PROFILE_SERIALIZER_CLASS
    if request.method in ["POST", "PUT", "PATCH"]:
        partial = request.method == "PATCH"
        serializer = serializer_class(
            instance=request.user,
            data=request.data,
            partial=partial,
            context={"request": request},
        )
        serializer.is_valid(raise_exception=True)
        serializer.save()
    elif request.method == "DELETE":
        get_user_model().objects.get(id=request.user.id).delete()
        serializer = serializer_class(
            instance=request.user,
            context={"request": request},
        )
    else:  # request.method == 'GET':
        serializer = serializer_class(
            instance=request.user,
            context={"request": request},
        )

    return Response(serializer.data)


ALPHA = 0.3
EMA_CUTOFF = 3  # EMA works best with some averages in the history


class FuelEfficiencyView(views.APIView):
    authentication_classes = AUTHS
    permission_classes = PERMS

    def single_efficiency(self, i: Refueling, j: Refueling) -> float:
        dist_diff = j.odomSnapshot.mileage - i.odomSnapshot.mileage
        return dist_diff / j.amount

    def ema(self, data: list) -> list:
        ema = []
        for i, v in enumerate(data):
            if i == 0:
                ema.append(v)
            elif i < EMA_CUTOFF:
                cur_aves = ema.copy()
                cur_aves.append(v)
                ema.append(mean(cur_aves))
            else:
                prev = ema[-1]
                ema.append(ALPHA * v + (1 - ALPHA) * prev)
        return ema

    def get(self, request, *args, **kwargs):
        data = defaultdict(dict)
        cars = Car.objects.filter(owner=request.user.id)
        for c in cars:
            refuelings = Refueling.objects.filter(odomSnapshot__car=c.id).order_by(
                "odomSnapshot__mileage"
            )
            mpgs = [
                self.single_efficiency(s, t) for s, t in zip(refuelings, refuelings[1:])
            ]
            emas = self.ema(mpgs)
            data[c.id] = [
                {"time": r.odomSnapshot.date, "raw": mpgs[i], "filtered": emas[i]}
                for i, r in enumerate(refuelings[1:])
            ]
        return Response(data)


class FuelUsageByCarView(views.APIView):
    authentication_classes = AUTHS
    permission_classes = PERMS

    def get(self, request, *args, **kwargs):
        cars = Car.objects.filter(owner=request.user.id)
        gas_used = {}
        for c in cars:
            refuelings = Refueling.objects.filter(odomSnapshot__car=c.id)
            if len(refuelings) == 0:
                gas_used[c.id] = 0
            else:
                gas_used[c.id] = reduce(
                    lambda i, j: i + j,
                    map(
                        lambda x: x.amount,
                        Refueling.objects.filter(odomSnapshot__car=c.id),
                    ),
                )
        return Response(gas_used)


class DrivingRateView(views.APIView):
    authentication_classes = AUTHS
    permission_classes = PERMS

    def get(self, request, *args, **kwargs):
        data = {}
        cars = Car.objects.filter(owner=request.user.id)
        for c in cars:
            odomSnaps = OdomSnapshot.objects.filter(car=c.id).order_by("mileage")
            rates = [
                single_distance_rate(s, t) for s, t in zip(odomSnaps, odomSnaps[1:])
            ]
            data[c.id] = [
                {"time": s.date, "rate": rates[i]} for i, s in enumerate(odomSnaps[1:])
            ]
        return Response(data)


class FuelUsageByMonthView(views.APIView):
    authentication_classes = AUTHS
    permission_classes = PERMS

    def get(self, request, *args, **kwargs):
        data = {}
        cars = Car.objects.filter(owner=request.user.id)
        for c in cars:
            data[
                c.id
            ] = (
                []
            )  # could use defaultdict but this ensures that we have an empty list when needed
            refuelings = Refueling.objects.filter(odomSnapshot__car=c.id).order_by(
                "odomSnapshot__date"
            )
            mapped = list(
                map(
                    lambda r: {
                        "date": f"{r.odomSnapshot.date.month}/{r.odomSnapshot.date.year}",
                        "amount": r.amount,
                    },
                    refuelings,
                )
            )
            groups = groupby(mapped, key=lambda e: e["date"])
            for k, v in groups:
                total = 0
                for e in v:
                    total += e["amount"]
                data[c.id].append({"date": k, "amount": total})

        return Response(data)
