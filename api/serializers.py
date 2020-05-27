from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class CustomJWTSerializer(TokenObtainPairSerializer):
    """
    Taken from: https://stackoverflow.com/questions/34332074/django-rest-jwt-login-using-username-or-email
    """
    def validate(self, attrs):
        credentials = {
            'username': '',
            'password': attrs.get("password")
        }

        # Get the username field if used instead of email
        user_obj = User.objects.filter(email=attrs.get("username")).first() or User.objects.filter(username=attrs.get("username")).first()
        if user_obj:
            credentials['username'] = user_obj.username

        return super().validate(credentials)
