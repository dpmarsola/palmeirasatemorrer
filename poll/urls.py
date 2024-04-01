from . import views
from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path("poll", views.poll, name="poll"),
    path("sendbet", views.sendbet, name="sendbet"),
    path("pollthanks", views.pollthanks, name="pollthanks"),

]
