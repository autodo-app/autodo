"""Defines the types of objects created and used by the user."""
from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    class Meta:
        db_table = 'auth_user'

class Car(models.Model):
    """
    Represents the data for a Car type.
    """
    owner = models.ForeignKey(User, related_name='car', on_delete=models.CASCADE)
    name = models.CharField(max_length=255, null=False)
    make = models.CharField(max_length=255)
    model = models.CharField(max_length=255)
    year = models.IntegerField()
    plate = models.CharField(max_length=10)
    vin = models.CharField(max_length=10)
    image = models.CharField(max_length=255) # TODO: Image Field?
    color = models.IntegerField()

    def __str__(self):
        return 'Car named: {}'.format(self.name)

class OdomSnapshot(models.Model):
    """The relevant data for an update to a car's odometer reading."""
    car = models.ForeignKey(Car, on_delete=models.CASCADE)
    owner = models.ForeignKey(User, related_name='odomSnapshot', on_delete=models.CASCADE)
    date = models.DateTimeField()
    mileage = models.FloatField()

    def __str__(self):
        return 'Odometer Snapshot for car: {} on: {} at: {}'\
            .format(self.car, self.date, self.mileage)

class Refueling(models.Model):
    """Data associated with a car's refueling event."""
    owner = models.ForeignKey(User, related_name='refueling', on_delete=models.CASCADE)
    odomSnapshot = models.ForeignKey(OdomSnapshot, on_delete=models.CASCADE)
    cost = models.IntegerField() # For USD, scale this up by x100 to get an int
    amount = models.FloatField()

    def __str__(self):
        return 'Refueling for cost: {} and amount: {}'.format(self.cost, self.amount)

class Todo(models.Model):
    """A task or action to perform on a car."""
    owner = models.ForeignKey(User, related_name='todo', on_delete=models.CASCADE)
    car = models.ForeignKey(Car, on_delete=models.CASCADE)
    completionOdomSnapshot = models.ForeignKey(OdomSnapshot, on_delete=models.CASCADE, blank=True, null=True)
    name = models.CharField(max_length=255, null=False)
    dueMileage = models.FloatField(default=None, blank=True, null=True)
    dueDate = models.DateTimeField(default=None, blank=True, null=True)
    estimatedDueDate = models.BooleanField(default=False, null=False)
    mileageRepeatInterval = models.FloatField(default=None, blank=True, null=True)
    daysRepeatInterval = models.IntegerField(default=None, blank=True, null=True)
    monthsRepeatInterval = models.IntegerField(default=None, blank=True, null=True)
    yearsRepeatInterval = models.IntegerField(default=None, blank=True, null=True)

