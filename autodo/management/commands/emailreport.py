import logging

from django.core.management.base import BaseCommand
from django.core.mail import send_mail
from django.template.loader import render_to_string
from django.utils.html import strip_tags

from autodo.utils import find_todos_needing_emails
from autodo.models import Todo


class Command(BaseCommand):
    help = "Sends out emails for all todos that are due soon"

    def add_arguments(self, parser):
        parser.add_argument(
            "--force", action="store_true", help="Ignore day of the week requirement"
        )

    def handle(self, *args, **options):
        queued_emails = find_todos_needing_emails(options["force"], Todo.objects.all())

        for owner, emails in queued_emails.items():
            # todo: change subject for singular case
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

            logging.info(f"Sending email to {owner}")
            send_mail(
                subject,
                plain_message,
                from_email,
                [owner],
                html_message=html_message,
                fail_silently=False,
            )
            logging.info("Email successfully sent")
            # owner is currently None
            self.stdout.write(
                self.style.SUCCESS(f"Sent an email to {owner} about {emails}")
            )

        self.stdout.write(self.style.SUCCESS("Done sending emails"))
        return
