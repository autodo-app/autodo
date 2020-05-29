from django.contrib.auth import get_user_model
from rest_framework import generics, viewsets, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_registration.decorators import api_view_serializer_class_getter
from rest_registration.settings import registration_settings

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

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)

class OdomSnapshotsListViewSet(viewsets.ModelViewSet):
    queryset = OdomSnapshot.objects.all()
    serializer_class = OdomSnapshotSerializer
    permission_classes = PERMS

    def get_queryset(self):
        return self.queryset.filter(owner=self.request.user)

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)

class RefuelingsListViewSet(viewsets.ModelViewSet):
    queryset = Refueling.objects.all()
    serializer_class = RefuelingSerializer
    permission_classes = PERMS

    def get_queryset(self):
        return self.queryset.filter(owner=self.request.user)

    def perform_create(self, serializer):
        serializer.save(owner=self.request.user)

class TodosListViewSet(viewsets.ModelViewSet):
    queryset = Todo.objects.all()
    serializer_class = TodoSerializer
    permission_classes = PERMS

    def get_queryset(self):
        return self.queryset.filter(owner=self.request.user)

    def perform_create(self, serializer):
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
    """
    Get or set user profile.
    """
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
        return Response('User Deleted')
    else:  # request.method == 'GET':
        serializer = serializer_class(
            instance=request.user,
            context={'request': request},
        )

        return Response(serializer.data)
