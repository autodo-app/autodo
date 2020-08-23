# Generated by Django 2.2.15 on 2020-08-23 23:16

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('autodo', '0003_auto_20200529_0110'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='car',
            name='imageName',
        ),
        migrations.AddField(
            model_name='car',
            name='image',
            field=models.ImageField(null=True, upload_to='cars'),
        ),
        migrations.AlterField(
            model_name='car',
            name='make',
            field=models.CharField(blank=True, max_length=32, null=True),
        ),
        migrations.AlterField(
            model_name='car',
            name='model',
            field=models.CharField(blank=True, max_length=32, null=True),
        ),
        migrations.AlterField(
            model_name='car',
            name='name',
            field=models.CharField(max_length=32),
        ),
        migrations.AlterField(
            model_name='todo',
            name='completionOdomSnapshot',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='autodo.OdomSnapshot'),
        ),
        migrations.AlterField(
            model_name='todo',
            name='name',
            field=models.CharField(max_length=32),
        ),
    ]
