# Generated by Django 3.1.7 on 2021-03-01 00:58

from django.conf import settings
import django.contrib.auth.models
import django.contrib.auth.validators
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('auth', '0012_alter_user_first_name_max_length'),
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(blank=True, null=True, verbose_name='last login')),
                ('is_superuser', models.BooleanField(default=False, help_text='Designates that this user has all permissions without explicitly assigning them.', verbose_name='superuser status')),
                ('username', models.CharField(error_messages={'unique': 'A user with that username already exists.'}, help_text='Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.', max_length=150, unique=True, validators=[django.contrib.auth.validators.UnicodeUsernameValidator()], verbose_name='username')),
                ('first_name', models.CharField(blank=True, max_length=150, verbose_name='first name')),
                ('last_name', models.CharField(blank=True, max_length=150, verbose_name='last name')),
                ('email', models.EmailField(blank=True, max_length=254, verbose_name='email address')),
                ('is_staff', models.BooleanField(default=False, help_text='Designates whether the user can log into this admin site.', verbose_name='staff status')),
                ('is_active', models.BooleanField(default=True, help_text='Designates whether this user should be treated as active. Unselect this instead of deleting accounts.', verbose_name='active')),
                ('date_joined', models.DateTimeField(default=django.utils.timezone.now, verbose_name='date joined')),
                ('groups', models.ManyToManyField(blank=True, help_text='The groups this user belongs to. A user will get all permissions granted to each of their groups.', related_name='user_set', related_query_name='user', to='auth.Group', verbose_name='groups')),
                ('user_permissions', models.ManyToManyField(blank=True, help_text='Specific permissions for this user.', related_name='user_set', related_query_name='user', to='auth.Permission', verbose_name='user permissions')),
            ],
            options={
                'db_table': 'auth_user',
            },
            managers=[
                ('objects', django.contrib.auth.models.UserManager()),
            ],
        ),
        migrations.CreateModel(
            name='Car',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=32)),
                ('make', models.CharField(blank=True, max_length=32, null=True)),
                ('model', models.CharField(blank=True, max_length=32, null=True)),
                ('year', models.IntegerField(blank=True, null=True)),
                ('plate', models.CharField(blank=True, max_length=10, null=True)),
                ('vin', models.CharField(blank=True, max_length=10, null=True)),
                ('image', models.ImageField(null=True, upload_to='cars')),
                ('color', models.IntegerField(default=128)),
                ('owner', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='car', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Greeting',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('when', models.DateTimeField(auto_now_add=True, verbose_name='date created')),
            ],
        ),
        migrations.CreateModel(
            name='OdomSnapshot',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date', models.DateTimeField()),
                ('mileage', models.FloatField()),
                ('car', models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, related_name='snaps', to='autodo.car')),
                ('owner', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='odomSnapshot', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'ordering': ['-mileage'],
            },
        ),
        migrations.CreateModel(
            name='Todo',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=32)),
                ('dueMileage', models.FloatField(blank=True, default=None, null=True)),
                ('dueDate', models.DateTimeField(blank=True, default=None, null=True)),
                ('estimatedDueDate', models.BooleanField(blank=True, default=False, null=True)),
                ('mileageRepeatInterval', models.FloatField(blank=True, default=None, null=True)),
                ('daysRepeatInterval', models.IntegerField(blank=True, default=None, null=True)),
                ('monthsRepeatInterval', models.IntegerField(blank=True, default=None, null=True)),
                ('yearsRepeatInterval', models.IntegerField(blank=True, default=None, null=True)),
                ('car', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='autodo.car')),
                ('completionOdomSnapshot', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='autodo.odomsnapshot')),
                ('owner', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='todo', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'ordering': ['dueDate', 'dueMileage'],
            },
        ),
        migrations.CreateModel(
            name='Refueling',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('cost', models.IntegerField()),
                ('amount', models.FloatField()),
                ('odomSnapshot', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='autodo.odomsnapshot')),
                ('owner', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='refueling', to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
