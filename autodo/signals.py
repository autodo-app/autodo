import sys

from django.db.models.signals import post_save
from django.core.mail import send_mail
from django.template.loader import render_to_string
from django.utils.html import strip_tags
from django.dispatch import receiver
from django.core.cache import cache


from autodo.models import OdomSnapshot, Refueling, Todo
from autodo.utils import determine_email_type

EMAIL_RATE_LIMIT_KEY = "email_rate_limit"


def send_email_notice_if_needed(sender, instance, **kwargs):
    can_send = cache.get(EMAIL_RATE_LIMIT_KEY)
    if can_send:
        # don't send another email if the cache is still valid, meaning we
        # recently sent an email
        return
    snap = instance
    car = snap.car
    todos = Todo.objects.filter(car=car.id)
    emails = []
    for t in todos:
        try:
            t.delta_due_mileage = t.dueMileage - snap.mileage
        except:
            t.delta_due_mileage = None
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

    subject = "auToDo: A Todo is Due Soon"
    if len(past_due) > 1:
        subject = "auToDo: Todos are PAST DUE"
    elif len(past_due) > 0:
        subject = "auToDo: A Todo is PAST DUE"
    elif len(due_soon) > 1:
        subject = "auToDO: Todos are Due Soon"

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
    cache.set(EMAIL_RATE_LIMIT_KEY, True, 30 * 60)  # set timeout of 30min


# trigger an email about upcoming todos when an odomsnapshot is created or updated
post_save.connect(
    send_email_notice_if_needed,
    sender=OdomSnapshot,
    dispatch_uid="send_email_notice_if_needed",
)
