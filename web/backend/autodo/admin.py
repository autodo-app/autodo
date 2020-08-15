from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User, Car, OdomSnapshot, Refueling, Todo

admin.site.register(User, UserAdmin)
admin.site.register(Car)
admin.site.register(OdomSnapshot)
admin.site.register(Refueling)
admin.site.register(Todo)
