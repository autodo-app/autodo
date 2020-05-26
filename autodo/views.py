from rest_framework import generics, viewsets, permissions
from .models import *
from .serializers import *
from .permissions import *

class CarsListViewSet(viewsets.ModelViewSet):
    """Provides a GET handler."""
    queryset = Car.objects.all()
    serializer_class = CarSerializer

class OdomSnapshotsListViewSet(viewsets.ModelViewSet):
    """Provides a GET handler."""
    queryset = OdomSnapshot.objects.all()
    serializer_class = OdomSnapshotSerializer
    permission_classes = [permissions.IsAuthenticated, IsOwner]

    # def perform_create(self, serializer):
        # serializer.save(owner=self.request.user)

    def get_queryset(self):
        return self.queryset.filter(owner=self.request.user)

class RefuelingsListViewSet(viewsets.ModelViewSet):
    """Provides a GET handler."""
    queryset = Refueling.objects.all()
    serializer_class = RefuelingSerializer

class TodosListViewSet(viewsets.ModelViewSet):
    """Provides a GET handler."""
    queryset = Todo.objects.all()
    serializer_class = TodoSerializer
