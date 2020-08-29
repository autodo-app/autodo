"""ElasticSearch Documents"""
from django_elasticsearch_dsl import Document, fields, Index
from django_elasticsearch_dsl_drf.compat import KeywordField, StringField
from django_elasticsearch_dsl_drf.analyzers import edge_ngram_completion
from .models import Car, OdomSnapshot, Refueling, Todo
from .analyzers import html_strip

__all__ = ("CarDocument",)

INDEX = Index("cars")
INDEX.settings(
    number_of_shards=1,
    number_of_replicas=1,
)


@INDEX.doc_type
class CarDocument(Document):
    """Car ElasticSearch Document."""

    id = fields.IntegerField(attr="id")

    # Main Search fields
    name = StringField(
        analyzer=html_strip,
        fields={
            "raw": KeywordField(),
            "suggest": fields.CompletionField(),
            "edge_ngram_completion": StringField(analyzer=edge_ngram_completion),
            "mlt": StringField(analyzer="english"),
        },
    )

    class Django(object):
        model = Car

    class Meta(object):
        parallel_indexing = True
