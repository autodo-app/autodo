from elasticsearch_dsl import analyzer

__all__ = ('html_strip',)

_filters = ['lowercase', 'stop', 'snowball']

html_strip = analyzer(
    'html_strip',
    tokenizer='standard',
    filter=_filters,
    char_filter=['html_strip']
)
