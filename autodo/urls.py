from django.urls import path

from autodo.views import index, detail, rename, db, catchall 

urlpatterns = [
  # path("", index, name="index"),
  path("", catchall),
  path("cars/<int:car_id>/", detail, name="cars/detail"),
  path("cars/<int:car_id>/rename", rename, name="cars/rename"),
  path("db/", db, name="db"),
]
