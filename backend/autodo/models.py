"""Defines the types of objects created and used by the user."""
from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    class Meta:
        db_table = 'auth_user'

class Car(models.Model):
    """Represents the data for a Car type."""
    owner = models.ForeignKey(
        User,
        related_name='car',
        on_delete=models.CASCADE)

    name = models.CharField(
        max_length=32,
        null=False)
    make = models.CharField(
        max_length=32,
        blank=True,
        null=True)
    model = models.CharField(
        max_length=32,
        blank=True,
        null=True)
    year = models.IntegerField(
        blank=True,
        null=True)
    plate = models.CharField(
        max_length=10,
        blank=True,
        null=True)
    vin = models.CharField(
        max_length=10,
        blank=True,
        null=True)
    image = models.ImageField(upload_to='cars', null=True)
    color = models.IntegerField(
        default=128) # TODO: autodo green to int maybe?

    def __str__(self):
        return 'Car named: {}'.format(self.name)

class OdomSnapshot(models.Model):
    """The relevant data for an update to a car's odometer reading."""
    car = models.ForeignKey(
        Car,
        on_delete=models.CASCADE)
    owner = models.ForeignKey(
        User,
        related_name='odomSnapshot',
        on_delete=models.CASCADE)

    date = models.DateTimeField()
    mileage = models.FloatField()

    def __str__(self):
        return 'Odometer Snapshot for car: {} on: {} at: {}'\
            .format(self.car, self.date, self.mileage)

class Refueling(models.Model):
    """Data associated with a car's refueling event."""
    owner = models.ForeignKey(
        User,
        related_name='refueling',
        on_delete=models.CASCADE)
    odomSnapshot = models.ForeignKey(
        OdomSnapshot,
        on_delete=models.CASCADE)

    cost = models.IntegerField() # For USD, scale this up by x100 to get an int
    amount = models.FloatField()

    def __str__(self):
        return 'Refueling for cost: {} and amount: {}'.format(self.cost, self.amount)

class Todo(models.Model):
    """A task or action to perform on a car."""
    owner = models.ForeignKey(
        User,
        related_name='todo',
        on_delete=models.CASCADE)
    car = models.ForeignKey(
        Car,
        on_delete=models.CASCADE)
    completionOdomSnapshot = models.ForeignKey(
        OdomSnapshot,
        on_delete=models.SET_NULL,
        blank=True,
        null=True)

    name = models.CharField(
        max_length=32,
        null=False)
    dueMileage = models.FloatField(
        default=None,
        blank=True,
        null=True)
    dueDate = models.DateTimeField(
        default=None,
        blank=True,
        null=True)
    # TODO: calculate this on POST
    estimatedDueDate = models.BooleanField(
        default=False,
        blank=True,
        null=True)
    mileageRepeatInterval = models.FloatField(
        default=None,
        blank=True,
        null=True)
    daysRepeatInterval = models.IntegerField(
        default=None,
        blank=True,
        null=True)
    monthsRepeatInterval = models.IntegerField(
        default=None,
        blank=True,
        null=True)
    yearsRepeatInterval = models.IntegerField(
        default=None,
        blank=True,
        null=True)

