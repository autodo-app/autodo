from django.contrib.auth.models import User
from rest_framework import serializers
from .models import Car, OdomSnapshot, Refueling, Todo

class CarSerializer(serializers.HyperlinkedModelSerializer):
    owner = serializers.ReadOnlyField(source='owner.username')

    class Meta:
        model = Car
        fields = ['url', 'id', 'owner', 'name', 'make', 'model', 'plate', 'year', 'vin', 'image', 'color']

class OdomSnapshotSerializer(serializers.HyperlinkedModelSerializer):
    owner = serializers.ReadOnlyField(source='owner.username')
    car = serializers.HyperlinkedIdentityField(view_name='car-detail')

    class Meta:
        model = OdomSnapshot
        fields = ['url', 'id', 'owner', 'car', 'date', 'mileage']

class RefuelingSerializer(serializers.HyperlinkedModelSerializer):
    owner = serializers.ReadOnlyField(source='owner.username')
    odomSnapshot = serializers.HyperlinkedIdentityField(view_name='odomSnapshot-detail')

    class Meta:
        model = Refueling
        fields = ['url', 'id', 'owner', 'odomSnapshot', 'cost', 'amount']

class TodoSerializer(serializers.HyperlinkedModelSerializer):
    owner = serializers.ReadOnlyField(source='owner.username')
    car = serializers.HyperlinkedIdentityField(view_name='car-detail')
    completionOdomSnapshot = serializers.HyperlinkedIdentityField(view_name='odomSnapshot-detail')

    class Meta:
        model = Todo
        fields = ['url', 'id', 'owner', 'car', 'name', 'dueMileage', 'completionOdomSnapshot', 'estimatedDueDate', 'dueDate', 'mileageRepeatInterval', 'daysRepeatInterval', 'monthsRepeatInterval', 'yearsRepeatInterval']
