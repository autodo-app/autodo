from rest_framework import permissions

class IsOwner(permissions.BasePermission):
    """Custom perm to only allow owners of an object to edit it"""
    def has_object_permission(self, request, view, obj):
        return obj.owner == request.user
