import os

SECRET_KEY = '{{ SECRET_KEY }}'
DEBUG = False
ALLOWED_HOSTS = ['{{ HOST }}']
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': '{{ DB_NAME }}',
        'USER': '{{ DB_USER }}',
        'PASSWORD': '{{ DB_PASS }}',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}

STATIC_ROOT = '{{ STATIC_ROOT }}'
MEDIA_ROOT = '{{ MEDIA_ROOT }}'

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format' : "[%(asctime)s] %(levelname)s [%(name)s:%(lineno)s] %(message)s",
            'datefmt' : "%d/%b/%Y %H:%M:%S"
        },
        'simple': {
            'format': '%(levelname)s %(message)s'
        },
    },
    'handlers': {
        'file': {
            'level': 'INFO',
            'class': 'logging.FileHandler',
            'filename': '{{ LOG_FILE }}',
            'formatter': 'verbose'
        },
    },
    'loggers': {
        'django': {
            'handlers':['file'],
            'propagate': True,
            'level':'INFO',
        },
        '': {
            'handlers': ['file'],
            'level': 'INFO',
        },
    }
}

CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://127.0.0.1:6379/{{ REDIS_CACHE_NO }}",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        }
    }
}

BROKER_URL = 'redis://127.0.0.1:6379/{{ REDIS_BROKER_NO }}'
CELERY_ACCEPT_CONTENT = ['json']
CELERY_TASK_SERIALIZER = 'json'
CELERY_RESULT_SERIALIZER = 'json'
CELERY_TIMEZONE = 'America/Chicago'

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
        'OPTIONS': {
            'min_length': 9,
        }
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

EMAIL_BACKEND = 'djcelery_email.backends.CeleryEmailBackend'
EMAIL_HOST = '{{ EMAIL_HOST }}'
EMAIL_HOST_USER = '{{ EMAIL_USER }}'
EMAIL_HOST_PASSWORD = '{{ EMAIL_PASS }}'
EMAIL_PORT = '{{ EMAIL_PORT }}'
EMAIL_USE_TLS = True
