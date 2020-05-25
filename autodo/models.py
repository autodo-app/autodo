"""Defines the types of objects created and used by the user."""
from django.db import models

class Car(models.Model):
    """
    Represents the data for a Car type.
    """
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
    date = models.DateTimeField()
    mileage = models.FloatField()

    def __str__(self):
        return 'Odometer Snapshot for car: {} on: {} at: {}'\
            .format(self.car, self.date, self.mileage)

class Refueling(models.Model):
    """Data associated with a car's refueling event."""
    odomSnapshot = models.ForeignKey(OdomSnapshot, on_delete=models.CASCADE)
    cost = models.IntegerField() # For USD, scale this up by x100 to get an int
    amount = models.FloatField()

    def __str__(self):
        return 'Refueling for cost: {} and amount: {}'.format(self.cost, self.amount)

class Todo(models.Model):
    """A task or action to perform on a car."""
    car = models.ForeignKey(Car, on_delete=models.CASCADE)
    completionOdomSnapshot = models.ForeignKey(OdomSnapshot, on_delete=models.CASCADE)
    name = models.CharField(max_length=255, null=False)
    dueMileage = models.FloatField()
    dueDate = models.DateTimeField()
    estimatedDueDate = models.BooleanField(default=False, null=False)
    mileageRepeatInterval = models.FloatField()
    daysRepeatInterval = models.IntegerField()
    monthsRepeatInterval = models.IntegerField()
    yearsRepeatInterval = models.IntegerField()

