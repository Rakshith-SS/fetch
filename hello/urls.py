from django.urls import path
from .views import AboutView, ReadView

urlpatterns = [
    path('about/',  AboutView.as_view(), name="About"),
    path('read', ReadView.as_view(), name="ReadView")
]
