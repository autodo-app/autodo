from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import *

router = DefaultRouter()
router.register(r"cars", CarsListViewSet)
router.register(r"odomsnapshots", OdomSnapshotsListViewSet)
router.register(r"refuelings", RefuelingsListViewSet)
router.register(r"todos", TodosListViewSet)

urlpatterns = [
    path("", include(router.urls)),
    path("fuelefficiencystats/", FuelEfficiencyView.as_view()),
    path("fuelusagebycar/", FuelUsageByCarView.as_view()),
    path("fuelusagebymonth/", FuelUsageByMonthView.as_view()),
    path("drivingrate/", DrivingRateView.as_view()),
]

searchRouter = DefaultRouter()
searchRouter.register(r"cars", CarDocumentViewSet, basename="cardocument")
