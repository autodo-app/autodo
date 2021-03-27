from django.urls import path, include
from django.contrib.auth import views as auth_views

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
    TodoListView,
    TodoDetailView,
    TodoCreate,
    TodoUpdate,
    TodoDelete,
    landing_page,
    register,
)

urlpatterns = [
    path("", landing_page),
    # override the login view to redirect if the user is logged in
    path(
        "accounts/login/",
        auth_views.LoginView.as_view(redirect_authenticated_user=True),
        name="login",
    ),
    path("accounts/", include("django.contrib.auth.urls")),
    path("accounts/register/", register, name="register"),
    path("accounts/profile/", landing_page, name="profile"),
    path("settings/", landing_page, name="settings"),
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
    path("home/", TodoListView.as_view(), name="todos"),
    path("todos/create/", TodoCreate.as_view(), name="todos/create"),
    path("todos/<int:pk>/", TodoDetailView.as_view(), name="todos/detail"),
    path("todos/<int:pk>/update/", TodoUpdate.as_view(), name="todos/update"),
    path("todos/<int:pk>/delete/", TodoDelete.as_view(), name="todos/delete"),
    path("stats/", landing_page, name="stats"),
    path("home/", landing_page, name="home"),
]
