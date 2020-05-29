from rest_framework import serializers
from .models import Car, OdomSnapshot, Refueling, Todo, User
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class CustomJWTSerializer(TokenObtainPairSerializer):
    """
    Taken from: https://stackoverflow.com/questions/34332074/django-rest-jwt-login-using-username-or-email
    """
    def validate(self, attrs):
        credentials = {
            'username': '',
            'password': attrs.get("password")
        }

        # Get the username field if used instead of email
        user_obj = User.objects.filter(email=attrs.get("username")).first() or User.objects.filter(username=attrs.get("username")).first()
        if user_obj:
            credentials['username'] = user_obj.username

        return super().validate(credentials)

class CarSerializer(serializers.HyperlinkedModelSerializer):
    owner = serializers.ReadOnlyField(source='owner.username')

    # def save(**kwargs):
        # kwargs['owner'] = self.context['request'].user
        # super().save(**kwargs)

    class Meta:
        model = Car
        fields = ['url', 'id', 'owner', 'name', 'make', 'model', 'plate', 'year', 'vin', 'imageName', 'color']

class OdomSnapshotSerializer(serializers.HyperlinkedModelSerializer):
    owner = serializers.ReadOnlyField(source='owner.username')
    car = serializers.PrimaryKeyRelatedField(queryset=Car.objects.all())

    class Meta:
        model = OdomSnapshot
        fields = ['url', 'id', 'owner', 'car', 'date', 'mileage']

class RefuelingSerializer(serializers.HyperlinkedModelSerializer):
    owner = serializers.ReadOnlyField(source='owner.username')
    odomSnapshot = serializers.HyperlinkedIdentityField(view_name='odomsnapshots-detail')

    class Meta:
        model = Refueling
        fields = ['url', 'id', 'owner', 'odomSnapshot', 'cost', 'amount']

class TodoSerializer(serializers.HyperlinkedModelSerializer):
    owner = serializers.ReadOnlyField(source='owner.username')
    car = serializers.PrimaryKeyRelatedField(queryset=Car.objects.all())
    completionOdomSnapshot = serializers.HyperlinkedIdentityField(view_name='odomsnapshots-detail')

    class Meta:
        model = Todo
        fields = ['url', 'id', 'owner', 'car', 'name', 'dueMileage', 'completionOdomSnapshot', 'estimatedDueDate', 'dueDate', 'mileageRepeatInterval', 'daysRepeatInterval', 'monthsRepeatInterval', 'yearsRepeatInterval']
