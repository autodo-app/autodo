import django_filters

from autodo.models import Todo


class TodoFilter(django_filters.FilterSet):
    complete = django_filters.BooleanFilter(field_name="complete")
    # due_date = django_filters.DateTimeFilter(field_name="dueDate", lookup_expr="lt")
    # due_mileage = django_filters.NumberField(field_name="dueMileage", lookup_expr="lt")

    class Meta:
        model = Todo
        fields = ["complete"]
