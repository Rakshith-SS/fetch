from django.views.generic import TemplateView


class AboutView(TemplateView):
    template_name = "hello/about.html"


class ReadView(TemplateView):
    template_name = "hello/read_me.html"
