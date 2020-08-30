#!/bin/sh 

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done
    while ! nc -z $ELASTICSEARCH_HOST $ELASTICSEARCH_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL and Elasticsearch started"
fi

python manage.py flush --no-input
python manage.py migrate --noinput
python manage.py shell < test_data.py

exec "$@"
