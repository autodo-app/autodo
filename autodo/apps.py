from django.apps import AppConfig


class AutodoConfig(AppConfig):
    name = "autodo"

    def ready(self):
        import autodo.signals
