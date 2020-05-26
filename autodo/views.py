from rest_framework import generics, viewsets, permissions
from .models import *
from .serializers import *
from .permissions import *

PERMS = [permissions.IsAuthenticated, IsOwner]

class CarsListViewSet(viewsets.ModelViewSet):
    queryset = Car.objects.all()
    serializer_class = CarSerializer
    permission_classes = PERMS

    def get_queryset(self):
        return self.queryset.filter(owner=self.request.user)

class OdomSnapshotsListViewSet(viewsets.ModelViewSet):
    queryset = OdomSnapshot.objects.all()
    serializer_class = OdomSnapshotSerializer
    permission_classes = PERMS

    def get_queryset(self):
        return self.queryset.filter(owner=self.request.user)

class RefuelingsListViewSet(viewsets.ModelViewSet):
    queryset = Refueling.objects.all()
    serializer_class = RefuelingSerializer
    permission_classes = PERMS

    def get_queryset(self):
        return self.queryset.filter(owner=self.request.user)

class TodosListViewSet(viewsets.ModelViewSet):
    queryset = Todo.objects.all()
    serializer_class = TodoSerializer
    permission_classes = PERMS

    def get_queryset(self):
        return self.queryset.filter(owner=self.request.user)
