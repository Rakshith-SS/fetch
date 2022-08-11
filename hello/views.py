from django.views.generic import TemplateView


class HomeView(TemplateView):
    template_name = "hello/index.html"


class AboutView(TemplateView):
    template_name = "hello/about.html"


class ReadView(TemplateView):
    template_name = "hello/read_me.html"
