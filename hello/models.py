from django.db import models


class Notes(models.Model):
    name = models.CharField(max_length=50)
    paragraph = models.CharField(max_length=2000)
