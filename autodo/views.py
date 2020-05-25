from rest_framework import generics, viewsets
from .models import *
from .serializers import *

class CarsListViewSet(viewsets.ReadOnlyModelViewSet):
    """Provides a GET handler."""
    queryset = Car.objects.all()
    serializer_class = CarSerializer

class OdomSnapshotsListViewSet(viewsets.ReadOnlyModelViewSet):
    """Provides a GET handler."""
    queryset = OdomSnapshot.objects.all()
    serializer_class = OdomSnapshotSerializer

class RefuelingsListViewSet(viewsets.ReadOnlyModelViewSet):
    """Provides a GET handler."""
    queryset = Refueling.objects.all()
    serializer_class = RefuelingSerializer

class TodosListViewSet(viewsets.ReadOnlyModelViewSet):
    """Provides a GET handler."""
    queryset = Todo.objects.all()
    serializer_class = TodoSerializer
