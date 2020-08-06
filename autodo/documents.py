"""ElasticSearch Documents"""
from django_elasticsearch_dsl import Document, fields, Index
from django_elasticsearch_dsl.registries import registry
from .models import Car, OdomSnapshot, Refueling, Todo

car_index = Index('cars')
car_index.settings(number_of_shards=1, number_of_replicas=0)

@registry.register_document
class CarDocument(Document):
    class Index:
        # Name of ElasticSearch Index
        name = 'cars'
        settings = {'number_of_shards': 1,
                    'number_of_replicas': 0}

    class Django:
        model = Car
        # fields we want to be indexed
        fields = [
            'id',
            'name',
            'make',
            'model'
        ]

