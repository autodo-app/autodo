import hashlib
from urllib.parse import urlencode

from django import template
from django.conf import settings

register = template.Library()


@register.filter
def gravatar(user):
    try:
        email = user.email.lower().encode("utf-8")
    except AttributeError:
        return ""
    default = "retro"
    size = 40
    url = "https://www.gravatar.com/avatar/{md5}?{params}".format(
        md5=hashlib.md5(email).hexdigest(),
        params=urlencode({"d": default, "s": str(size)}),
    )
    return url


@register.filter
def check_if_update(values):
    return list(values)[0].initial["car"]
