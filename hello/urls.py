from django.urls import path
from .views import AboutView, ReadView, HomeView

urlpatterns = [
    path('', HomeView.as_view(), name="HomeView"),
    path('about/',  AboutView.as_view(), name="About"),
    path('read/', ReadView.as_view(), name="ReadView")
]
