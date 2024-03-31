from . import views
from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path("poll", views.index, name="index"),
    path("sendbet", views.sendbet, name="sendbet"),

]
