from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver

from django_elasticsearch_dsl.registries import registry

@receiver(post_save)
def update_document(sender, **kwargs):
    """Update document on added/changed records."""
    app_label = sender._meta.app_label
    model_name = sender._meta.model_name
    instance = kwargs['instance']

    if app_label == 'car':
        # Update the odomSnapshot if needed
        if model_name == 'odomSnapshot':
            instances = instance.cars.all()
            for _instance in instances:
                registry.update(_instance)

@receiver(post_delete)
def delete_document(sender, **kwargs):
    """Update document on deleted records."""
    app_label = sender._meta.app_label
    model_name = sender._meta.model_name
    instance = kwargs['instance']

    if app_label == 'car':
        # Update the odomSnapshot if needed
        if model_name == 'odomSnapshot':
            instances = instance.cars.all()
            for _instance in instances:
                registry.update(_instance)

