from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import *

router = DefaultRouter()
router.register(r'cars', CarsListViewSet)
router.register(r'odomsnapshots', OdomSnapshotsListViewSet)
router.register(r'refuelings', RefuelingsListViewSet)
router.register(r'todos', TodosListViewSet)

urlpatterns = [
    path('', include(router.urls))
]
