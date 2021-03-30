import sys

from django.db.models.signals import post_save
from django.core.mail import send_mail
from django.template.loader import render_to_string
from django.utils.html import strip_tags
from django.dispatch import receiver


from autodo.models import OdomSnapshot, Refueling, Todo
from autodo.utils import determine_email_type


# @receiver(post_save, sender=Refueling)
def send_email_notice_if_needed(sender, instance, **kwargs):
    print("here")
    sys.stdout.flush()
    snap = instance
    car = snap.car
    todos = Todo.objects.filter(car=car.id)
    emails = []
    for t in todos:
        t.delta_due_mileage = t.dueMileage - snap.mileage
        if email := determine_email_type(t):
            emails.append(email)

    if len(emails) == 0:
        return

    past_due = []
    due_soon = []
    for e in emails:
        if e[1] == "PAST_DUE":
            past_due.append(e[0])
        elif e[1] == "DUE_SOON":
            due_soon.append(e[0])

    subject = "auToDo: Todos are Due Soon"
    if len(past_due) > 0:
        subject = "auToDo: Todos are PAST DUE"

    context = {}
    if len(past_due) > 0:
        context["past_due"] = past_due
    if len(due_soon) > 0:
        context["due_soon"] = due_soon
    html_message = render_to_string("autodo/todo_reminder_email.html", context)
    plain_message = strip_tags(html_message)
    from_email = "noreply@autodo.app"

    send_mail(
        subject,
        plain_message,
        from_email,
        [snap.owner.email],
        html_message=html_message,
    )


# trigger an email about upcoming todos when an odomsnapshot is created or updated
post_save.connect(
    send_email_notice_if_needed,
    sender=OdomSnapshot,
    dispatch_uid="send_email_notice_if_needed",
)
