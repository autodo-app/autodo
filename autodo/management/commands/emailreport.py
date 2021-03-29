from django.core.management.base import BaseCommand
from django.core.mail import send_mail

from autodo.utils import find_todos_needing_emails


class Command(BaseCommand):
    help = "Sends out emails for all todos that are due soon"

    def handle(self, *args, **options):
        queued_emails = find_todos_needing_emails()

        for owner, emails in queued_emails.items():
            # todo: change subject for singular case
            subject = "auToDo: Todos are Due Soon"
            if "PAST_DUE" in map(lambda e: e[3], emails):
                subject = "auToDo: Todos are PAST DUE"
            body = "The following Todos are due soon:\n"
            for email in emails:
                body += f"- {email[0]} due in {email[1]} miles for your car named: {email[2]}\n"

            self.stdout.write(subject)
            self.stdout.write(body)
            send_mail(
                subject,
                body,
                "noreply@autodo.app",
                [owner],
            )
            # self.stdout.write(str(owner) + " " + str(email))
        # send_mail(
        #     "Test Email",
        #     "Test Body",
        #     "noreply@autodo.app",
        #     ["baylessjonathan@gmail.com"],
        # )

        self.stdout.write(self.style.SUCCESS("Successfully sent email"))
        return
