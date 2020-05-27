"""api URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include, re_path
from rest_framework.authtoken import views
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from autodo.serializers import CustomJWTSerializer

urlpatterns = [
    path('', include('autodo.urls')),
    path('admin/', admin.site.urls),
    re_path('api/(?P<version>(v1|v2))/', include('autodo.urls')),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    path('auth/token/', TokenObtainPairView.as_view(serializer_class=CustomJWTSerializer), name='token_obtain_pair'),
    path('auth/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    # This populates:
    # - accounts/register to register a new user
    # - accounts/verify-registration to verify the registration with a signature
    #
    # More here: https://django-rest-registration.readthedocs.io/en/latest/detailed_configuration/register.html#api-views
    path('accounts/', include('rest_registration.api.urls')),
]
