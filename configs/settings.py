from .common import *

SECRET_KEY = '{{ INFO.get('secret_key') }}'
DEBUG = False
ALLOWED_HOSTS = ['{{ INFO.get('server_name') }}']

INSTALLED_APPS += ('mailer', )

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': '{{ INFO.get('db_name') }}',
        'USER': '{{ INFO.get('db_user') }}',
        'PASSWORD': '{{ INFO.get('db_pass') }}',
        'HOST': '127.0.0.1',
        'PORT': '5432',
    }
}

STATIC_ROOT = '{{ INFO.get('static_root') }}'
MEDIA_ROOT = '{{ INFO.get('media_root') }}'

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
            'filename': '{{ INFO.get('log') }}',
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
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': '127.0.0.1:11211',
    }
}

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

EMAIL_BACKEND = "mailer.backend.DbBackend"
EMAIL_HOST = '{{ INFO.get('email_host') }}'
EMAIL_HOST_USER = '{{ INFO.get('email_user') }}'
EMAIL_HOST_PASSWORD = '{{ INFO.get('email_pass') }}'
EMAIL_PORT = '{{ INFO.get('email_port') }}'
EMAIL_USE_TLS = True
