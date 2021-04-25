from collections import defaultdict
import datetime
import logging
import sys

from django.utils import timezone

from .models import Todo, OdomSnapshot


def find_odom(car, snaps):
    car_snaps = snaps.filter(car=car.id).order_by("-mileage")
    if len(car_snaps) == 0:
        print("We really shouldn't have cars without mileage")
        return 0
    return car_snaps[0].mileage


def add_mileage_to_due(todo, car, snaps):
    cur_mileage = find_odom(car, snaps)
    if todo.dueMileage:
        todo.delta_due_mileage = todo.dueMileage - cur_mileage


def add_delta_time(todo):
    if todo.dueDate:
        delta = todo.dueDate - timezone.now()
        todo.delta_due_date = delta.days


def create_defaults(user, car, snaps):
    base_mileage = find_odom(car, snaps)

    def get_due_mileage(interval):
        if interval > base_mileage:
            # it's safe to assume that the user has not done this task
            return interval
        else:
            return base_mileage + interval

    defaults = [
        Todo(
            owner=user,
            car=car,
            name="Oil",
            dueMileage=get_due_mileage(3500),
            mileageRepeatInterval=3500,
        ),
        Todo(
            owner=user,
            car=car,
            name="Tire Rotation",
            dueMileage=get_due_mileage(7500),
            mileageRepeatInterval=7500,
        ),
        Todo(
            owner=user,
            car=car,
            name="Engine Filter",
            dueMileage=get_due_mileage(45000),
            mileageRepeatInterval=45000,
        ),
        Todo(
            owner=user,
            car=car,
            name="Wiper Blades",
            dueMileage=get_due_mileage(30000),
            mileageRepeatInterval=30000,
        ),
        Todo(
            owner=user,
            car=car,
            name="Alignment Check",
            dueMileage=get_due_mileage(40000),
            mileageRepeatInterval=40000,
        ),
        Todo(
            owner=user,
            car=car,
            name="Cabin Filter",
            dueMileage=get_due_mileage(45000),
            mileageRepeatInterval=45000,
        ),
        Todo(
            owner=user,
            car=car,
            name="Tires",
            dueMileage=get_due_mileage(50000),
            mileageRepeatInterval=50000,
        ),
        Todo(
            owner=user,
            car=car,
            name="Brakes",
            dueMileage=get_due_mileage(60000),
            mileageRepeatInterval=60000,
        ),
        Todo(
            owner=user,
            car=car,
            name="Spark Plugs",
            dueMileage=get_due_mileage(60000),
            mileageRepeatInterval=60000,
        ),
        Todo(
            owner=user,
            car=car,
            name="Front Struts",
            dueMileage=get_due_mileage(75000),
            mileageRepeatInterval=75000,
        ),
        Todo(
            owner=user,
            car=car,
            name="Rear Struts",
            dueMileage=get_due_mileage(75000),
            mileageRepeatInterval=75000,
        ),
        Todo(
            owner=user,
            car=car,
            name="Battery",
            dueMileage=get_due_mileage(75000),
            mileageRepeatInterval=75000,
        ),
        Todo(
            owner=user,
            car=car,
            name="Serpentine Belt",
            dueMileage=get_due_mileage(150000),
            mileageRepeatInterval=150000,
        ),
        Todo(
            owner=user,
            car=car,
            name="Transmission Fluid",
            dueMileage=get_due_mileage(100000),
            mileageRepeatInterval=100000,
        ),
        Todo(
            owner=user,
            car=car,
            name="Coolant Change",
            dueMileage=get_due_mileage(100000),
            mileageRepeatInterval=100000,
        ),
    ]

    for t in defaults:
        t.save()


car_color_palette = [
    "#e06c75",
    "#98c379",
    "#e5c07b",
    "#61afef",
    "#c678dd",
    "#56b6c2",
    "#abbcbf",
    "#282c34",
]


def determine_email_type(t):
    try:
        # not sure if this field will exist on the todo
        if t.delta_due_mileage <= 0:
            return (
                t,
                "PAST_DUE",
            )
        elif t.delta_due_mileage <= 500:
            return (
                t,
                "DUE_SOON",
            )
    except:
        pass  # todo: use due date for emails


def find_todos_needing_emails(force):
    if datetime.datetime.today().weekday() != 5 and not force:
        return {}  # only send our emails on Saturdays

    logging.info("Preparing automated emails")

    queued_emails = defaultdict(list)
    for t in Todo.objects.all():
        print(vars(t.owner))
        sys.stdout.flush()

        # todo: filter out completed todos
        cur_mileage = find_odom(t.car, OdomSnapshot.objects.filter(owner=t.owner))
        if t.dueMileage is not None:
            t.delta_due_mileage = t.dueMileage - cur_mileage
        if email := determine_email_type(t):
            queued_emails[t.owner.email].append(email)

    return queued_emails
