from django.urls import path, include

from autodo.views import (
    CarListView,
    CarDetailView,
    CarCreate,
    CarUpdate,
    CarDelete,
    RefuelingListView,
    RefuelingDetailView,
    RefuelingCreate,
    RefuelingUpdate,
    OdomSnapshotDelete,
    catchall,
    register,
)

urlpatterns = [
    path("", catchall),
    path("accounts/", include("django.contrib.auth.urls")),
    path("accounts/register/", register, name="register"),
    path("accounts/profile/", catchall, name="profile"),
    path("settings/", catchall, name="settings"),
    path("cars/", CarListView.as_view(), name="cars"),
    path("cars/create/", CarCreate.as_view(), name="cars/create"),
    path("cars/<int:pk>/", CarDetailView.as_view(), name="cars/detail"),
    path("cars/<int:pk>/update/", CarUpdate.as_view(), name="cars/update"),
    path("cars/<int:pk>/delete/", CarDelete.as_view(), name="cars/delete"),
    path("refuelings/", RefuelingListView.as_view(), name="refuelings"),
    path("refuelings/create/", RefuelingCreate.as_view(), name="refuelings/create"),
    path(
        "refuelings/<int:pk>/", RefuelingDetailView.as_view(), name="refuelings/detail"
    ),
    path(
        "refuelings/<int:pk>/update/",
        RefuelingUpdate.as_view(),
        name="refuelings/update",
    ),
    # Using the parent delete view here to get both parent and child
    path(
        "refuelings/<int:pk>/delete/",
        OdomSnapshotDelete.as_view(),
        name="refuelings/delete",
    ),
]
