#!/bin/sh 

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for postgres..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done

    echo "PostgreSQL started"
fi

python manage.py flush --no-input
python manage.py migrate --noinput
python manage.py shell -c "from autodo.models import User; User.objects.create_superuser('root', 'root@example.com', 'root1234')"

exec "$@"
