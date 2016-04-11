from .common import *

SECRET_KEY = '{{ info.get('secret') }}'
DEBUG = False
ALLOWED_HOSTS = ['{{ info.get('host') }}']

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': '{{ info.get('db_name') }}',
        'USER': '{{ info.get('db_user') }}',
        'PASSWORD': '{{ info.get('db_pass') }}',
        'HOST': '127.0.0.1',
        'PORT': '5432',
    }
}

STATIC_ROOT = '{{ info.get('static_root') }}'
MEDIA_ROOT = '{{ info.get('media_root') }}'

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
            'filename': '{{ info.get('log') }}',
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
