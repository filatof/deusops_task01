#! /bin/sh


# User credentials
user=admin
email=admin@example.com
password=pass

file=db/db.sqlite3
#if [ -z "$file" ]; then
#  echo "from django.contrib.auth.models import User; User.objects.create_superuser('$user', '$email', '$password')" | python3 manage.py shell
#fi

echo "from django.contrib.auth.models import User; User.objects.create_superuser('$user', '$email', '$password')" | python3 manage.py shell
python3 manage.py migrate
