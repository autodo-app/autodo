"""CRUD endpoints for the models."""
from django.contrib.auth import get_user_model
from rest_framework import generics, viewsets, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_registration.decorators import api_view_serializer_class_getter
from rest_registration.settings import registration_settings
from django_elasticsearch_dsl_drf.constants import (
    LOOKUP_FILTER_RANGE,
    LOOKUP_QUERY_GT,
    LOOKUP_QUERY_GTE,
    LOOKUP_QUERY_IN,
    LOOKUP_QUERY_LT,
    LOOKUP_QUERY_LTE,
    SUGGESTER_COMPLETION,
)
from django_elasticsearch_dsl_drf.filter_backends import (
    DefaultOrderingFilterBackend,
    FilteringFilterBackend,
    SearchFilterBackend,
    OrderingFilterBackend,
    IdsFilterBackend
)
from django_elasticsearch_dsl_drf.viewsets import DocumentViewSet

from .models import Car, OdomSnapshot, Refueling, Todo
from .documents import CarDocument
from .serializers import CarSerializer, OdomSnapshotSerializer, RefuelingSerializer, TodoSerializer, CarDocumentSerializer
from .permissions import IsOwner

PERMS = [permissions.IsAuthenticated, IsOwner]

class CarsListViewSet(viewsets.ModelViewSet):
    """Exposes CRUD endpoints for the user's Car objects."""

    queryset = Car.objects.all()
    serializer_class = CarSerializer
    permission_classes = PERMS

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

    def get_queryset(self):
        """Only returns objects that are owned by the user making the request."""
        return self.queryset.filter(owner=self.request.user).order_by('dueDate', 'dueMileage')

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
        lambda: registration_settings.PROFILE_SERIALIZER_CLASS)
@api_view(['GET', 'POST', 'PUT', 'PATCH', 'DELETE'])
@permission_classes([permissions.IsAuthenticated])
def profile(request):
    """Get or set user profile."""
    serializer_class = registration_settings.PROFILE_SERIALIZER_CLASS
    if request.method in ['POST', 'PUT', 'PATCH']:
        partial = request.method == 'PATCH'
        serializer = serializer_class(
            instance=request.user,
            data=request.data,
            partial=partial,
            context={'request': request},
        )
        serializer.is_valid(raise_exception=True)
        serializer.save()
    elif request.method == 'DELETE':
        get_user_model().objects.get(id=request.user.id).delete()
        serializer = serializer_class(
            instance=request.user,
            context={'request': request},
        )
    else:  # request.method == 'GET':
        serializer = serializer_class(
            instance=request.user,
            context={'request': request},
        )

    return Response(serializer.data)

class CarDocumentViewSet(DocumentViewSet):
    document = CarDocument
    serializer_class = CarDocumentSerializer
    lookup_field = 'id'

    filter_backends = [
        FilteringFilterBackend,
        IdsFilterBackend,
        OrderingFilterBackend,
        DefaultOrderingFilterBackend,
        SearchFilterBackend,
    ]

    search_fields = ('id', 'name', 'make', 'model',)

    filter_fields = {
        'id': {
            'field': 'id',
            'lookups': [
                LOOKUP_FILTER_RANGE,
                LOOKUP_QUERY_IN,
                LOOKUP_QUERY_GT,
                LOOKUP_QUERY_GTE,
                LOOKUP_QUERY_LT,
                LOOKUP_QUERY_LTE
            ]
        },
        'name': 'name.raw'
    }

    ordering_fields = {
        'id': 'id'
    }
    ordering = ('id',)
