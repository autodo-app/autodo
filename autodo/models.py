from django.db import models
from django.contrib.auth.models import AbstractUser
from djmoney.models.fields import MoneyField

# Create your models here.
class Greeting(models.Model):
    when = models.DateTimeField("date created", auto_now_add=True)


class User(AbstractUser):
    class Meta:
        db_table = "auth_user"


class OdomSnapshot(models.Model):
    """The relevant data for an update to a car's odometer reading."""

    car = models.ForeignKey(
        "Car", null=True, related_name="snaps", on_delete=models.CASCADE
    )
    owner = models.ForeignKey(
        "User", related_name="odomSnapshot", on_delete=models.CASCADE
    )

    date = models.DateTimeField()
    mileage = models.FloatField()

    def __str__(self):
        return f"{self.owner}'s Odometer Snapshot for car: {self.car} on: {self.date} at: {self.mileage}"

    class Meta:
        ordering = ["-mileage"]


class Todo(models.Model):
    """A task or action to perform on a car."""

    owner = models.ForeignKey("User", related_name="todo", on_delete=models.CASCADE)
    car = models.ForeignKey("Car", on_delete=models.CASCADE)
    completionOdomSnapshot = models.ForeignKey(
        "OdomSnapshot", on_delete=models.SET_NULL, blank=True, null=True
    )

    name = models.CharField(max_length=32, null=False)
    complete = models.BooleanField(default=False)
    dueMileage = models.FloatField(default=None, blank=True, null=True)
    dueDate = models.DateTimeField(default=None, blank=True, null=True)
    notes = models.TextField(default=None, blank=True, null=True)
    # TODO: calculate this on POST
    estimatedDueDate = models.BooleanField(default=False, blank=True, null=True)
    mileageRepeatInterval = models.FloatField(default=None, blank=True, null=True)
    daysRepeatInterval = models.IntegerField(default=None, blank=True, null=True)
    monthsRepeatInterval = models.IntegerField(default=None, blank=True, null=True)
    yearsRepeatInterval = models.IntegerField(default=None, blank=True, null=True)

    def __str__(self):
        return f"Todo {self.id} named: {self.name} due at {self.dueMileage} miles"

    class Meta:
        ordering = ["dueDate", "dueMileage"]


class Car(models.Model):
    """Represents the data for a Car type."""

    owner = models.ForeignKey(User, related_name="car", on_delete=models.CASCADE)

    name = models.CharField(max_length=32, null=False)
    make = models.CharField(max_length=32, blank=True, null=True)
    model = models.CharField(max_length=32, blank=True, null=True)
    year = models.IntegerField(blank=True, null=True)
    plate = models.CharField(max_length=10, blank=True, null=True)
    vin = models.CharField(max_length=10, blank=True, null=True)
    # image = models.ImageField(upload_to="cars", null=True)
    color = models.CharField(max_length=7)  # TODO: autodo green to int maybe?

    @property
    def light_color(self):
        r = int(self.color[1:3], base=16)
        g = int(self.color[3:5], base=16)
        b = int(self.color[5:7], base=16)
        luma = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return luma > 150

    def __str__(self):
        return "Car named: {}".format(self.name)


class Refueling(models.Model):
    """Data associated with a car's refueling event."""

    owner = models.ForeignKey(User, related_name="refueling", on_delete=models.CASCADE)
    odomSnapshot = models.ForeignKey(OdomSnapshot, on_delete=models.CASCADE)

    cost = MoneyField(max_digits=6, decimal_places=2, default_currency="USD")
    amount = models.FloatField()

    def __str__(self):
        return f"Refueling {self.id} for cost: {self.cost} and amount: {self.amount} with snap: {self.odomSnapshot.id}"
