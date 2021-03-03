from django.urls import path, include

from autodo.views import index, ListView, DetailView, CarCreate, rename, db, catchall 

urlpatterns = [
  # path("", index, name="index"),
  path("", catchall),
  path("accounts/", include("django.contrib.auth.urls")),
  path("cars/", ListView.as_view(), name="cars/"),
  path("cars/create/", CarCreate.as_view(), name="cars/create"),
  path("cars/<int:pk>/", DetailView.as_view(), name="cars/detail"),
  path("cars/<int:car_id>/rename", rename, name="cars/rename"),
  path("db/", db, name="db"),
]
