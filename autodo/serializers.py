from datetime import date

from rest_framework import serializers
from .models import Car, OdomSnapshot, Refueling, Todo, User
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

DUE_SOON_CUTOFF_DAYS = 14
DUE_SOON_DEFAULT_DISTANCE_RATE = 10

def sortedOdomSnaps(carId):
    return OdomSnapshot.objects.filter(car=carId).order_by('-date', '-mileage')

def single_distance_rate(i, j):
    dayDiff = (j.date - i.date).days
    # if both snapshots are in the same day then multiply the rate by two
    dayDiff = dayDiff if (dayDiff > 1) else 0.5
    return (j.mileage - i.mileage) / dayDiff

def calc_distance_rate(carId):
    odomSnaps = OdomSnapshot.objects.filter(car=carId).order_by('mileage')
    if (len(odomSnaps) < 2):
        return None
    # https://stackoverflow.com/questions/5314241/difference-between-consecutive-elements-in-list
    diffs = [single_distance_rate(s, t) for s, t in zip(odomSnaps, odomSnaps[1:])]

    window_size = 3
    i = 0
    averages=[]
    while i < len(diffs) - window_size + 1:
        window = diffs[i:i+window_size]
        window_average = sum(window) / window_size
        averages.append(window_average)
        i += 1
    print(averages[-1])
    return averages[-1]

class CustomJWTSerializer(TokenObtainPairSerializer):
    """
    Allows for setting the username _or_ the email field when requesting a token.

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
    """Translates the Car data into a view."""
    owner = serializers.ReadOnlyField(source='owner.username')
    odom = serializers.SerializerMethodField('find_odom')
    distanceRate = serializers.SerializerMethodField('find_distance_rate')

    def find_odom(self, obj):
        odomSnaps = sortedOdomSnaps(obj.id)
        return odomSnaps[0].mileage

    def find_distance_rate(self, obj):
        return calc_distance_rate(obj.id)

    class Meta:
        model = Car
        fields = ['url', 'id', 'owner', 'name', 'make', 'model', 'plate', 'year', 'vin', 'imageName', 'color', 'odom', 'distanceRate']

class OdomSnapshotSerializer(serializers.HyperlinkedModelSerializer):
    """Translates the Odom Snapshot data into a view."""
    owner = serializers.ReadOnlyField(source='owner.username')
    car = serializers.PrimaryKeyRelatedField(queryset=Car.objects.all())

    class Meta:
        model = OdomSnapshot
        fields = ['url', 'id', 'owner', 'car', 'date', 'mileage']

class RefuelingSerializer(serializers.HyperlinkedModelSerializer):
    """Translates the Refueling data into a view."""
    owner = serializers.ReadOnlyField(source='owner.username')
    odomSnapshot = serializers.PrimaryKeyRelatedField(queryset=OdomSnapshot.objects.all())

    class Meta:
        model = Refueling
        fields = ['url', 'id', 'owner', 'odomSnapshot', 'cost', 'amount']

class TodoSerializer(serializers.HyperlinkedModelSerializer):
    """Translates the Todo data into a view."""
    owner = serializers.ReadOnlyField(source='owner.username')
    car = serializers.PrimaryKeyRelatedField(queryset=Car.objects.all())
    completionOdomSnapshot = serializers.PrimaryKeyRelatedField(queryset=OdomSnapshot.objects.all(), allow_null=True)
    dueState = serializers.SerializerMethodField('calc_due_state')

    def calc_due_state(self, obj):
        if (obj.completionOdomSnapshot is not None):
            return 'completed'
        odomSnaps = sortedOdomSnaps(obj.car.id)
        odom = odomSnaps[0].mileage
        odomDiff = None
        dayDiff = None
        if (obj.dueMileage is not None):
            odomDiff = obj.dueMileage - odom
            if (odomDiff < 0):
                return 'late'
        elif (obj.dueDate is not None):
            dueDate = date(obj.dueDate)
            curDate = date.today()
            dateDiff = (dueDate - curDate).days
            if (dateDiff < 0):
                return 'late'
        # distanceRate = Car.objects.get(id=obj.car.id).distanceRate
        distanceRate = calc_distance_rate(obj.car.id)
        distanceRate = distanceRate if (distanceRate is not None) else DUE_SOON_DEFAULT_DISTANCE_RATE
        daysUntilDueDate = round((obj.dueMileage - odom) * distanceRate)
        if (daysUntilDueDate < DUE_SOON_CUTOFF_DAYS or dayDiff < DUE_SOON_CUTOFF_DAYS):
            return 'dueSoon'
        return 'upcoming'

    class Meta:
        model = Todo
        fields = ['url', 'id', 'owner', 'car', 'name', 'dueMileage', 'completionOdomSnapshot', 'estimatedDueDate', 'dueDate', 'mileageRepeatInterval', 'daysRepeatInterval', 'monthsRepeatInterval', 'yearsRepeatInterval', 'dueState']
