from django.urls import path, include, re_path
from django.contrib.auth import views as auth_views

from autodo.views.cars import (
    CarListView,
    CarDetailView,
    CarCreate,
    CarUpdate,
    CarDelete,
)
from autodo.views.refuelings import (
    RefuelingListView,
    RefuelingDetailView,
    RefuelingCreate,
    RefuelingUpdate,
    OdomSnapshotDelete,
)
from autodo.views.views import (
    Stats,
    landing_page,
    register,
    ProfileScreen,
    UserDelete,
    Settings,
)
from autodo.views.todos import (
    TodoListView,
    TodoDetailView,
    TodoCreate,
    TodoUpdate,
    TodoDelete,
    todoComplete,
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
    path("accounts/profile/<int:pk>/", ProfileScreen.as_view(), name="profile"),
    path(
        "accounts/profile/<int:pk>/delete",
        UserDelete.as_view(),
        name="user_confirm_delete",
    ),
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
    path("home/", TodoListView.as_view(), name="home"),
    path("todos/create/", TodoCreate.as_view(), name="todos/create"),
    path("todos/<int:pk>/", TodoDetailView.as_view(), name="todos/detail"),
    path("todos/<int:pk>/update/", TodoUpdate.as_view(), name="todos/update"),
    path("todos/<int:pk>/delete/", TodoDelete.as_view(), name="todos/delete"),
    path("api/todos/<int:pk>/", todoComplete, name="api_update_todo"),
    path("stats/", Stats.as_view(), name="stats"),
    path("settings/", Settings.as_view(), name="settings"),
]
