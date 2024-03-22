from django.shortcuts import render
from django.http import HttpResponse
from django.views.generic import TemplateView # Import TemplateView


class IndexView(TemplateView):
    template_name = "index.html"

