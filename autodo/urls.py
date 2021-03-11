from django.urls import path, include

from autodo.views import ListView, DetailView, CarCreate, CarUpdate, CarDelete, catchall

urlpatterns = [
    path("", catchall),
    path("accounts/", include("django.contrib.auth.urls")),
    path("accounts/profile/", catchall, name="profile"),
    path("settings", catchall, name="settings"),
    path("cars/", ListView.as_view(), name="cars"),
    path("cars/create/", CarCreate.as_view(), name="cars/create"),
    path("cars/<int:pk>/", DetailView.as_view(), name="cars/detail"),
    path("cars/<int:pk>/update/", CarUpdate.as_view(), name="cars/update"),
    path("cars/<int:pk>/delete/", CarDelete.as_view(), name="cars/delete"),
]
