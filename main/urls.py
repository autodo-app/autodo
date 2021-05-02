from django.urls import path, include
from django.views.static import serve
from django.contrib import admin

admin.autodiscover()

urlpatterns = [
    path("", include("autodo.urls")),
    path("static/", serve, {"document_root": settings.STATIC_ROOT}),
    path("admin/", admin.site.urls),
]
