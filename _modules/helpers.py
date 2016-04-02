import os


def get_virtualenv_path(user, project, info):
    return os.path.join('/home', user, '.virtualenvs', project)


def get_python_path(user, project, info):
    venv = get_virtualenv_path(user, project, info)
    return os.path.join(venv, 'bin/python')


def get_gunicorn_path(user, project, info):
    venv = get_virtualenv_path(user, project, info)
    return os.path.join(venv, 'bin/gunicorn')


def get_settings_path(project, info):
    default = os.path.join(info['src'], project, 'settings/prod.py')
    return info.get('prod_settings', default)


def get_settings_module(project, info):
    default = '{}.settings.prod'.format(project)
    return info.get('prod_settings_module', default)


def get_wsgi_module(project, info):
    default = '{}.wsgi'.format(project)
    return info.get('wsgi_module', default)


def get_service(project, info, chop=False):
    default = '{}.service'.format(project)

    if chop:
        default = default.replace('.service', '')

    return info.get('systemd', default)


def get_service_path(project, info):
    service = get_service(project, info)
    return os.path.join('/etc/systemd/system/', service)
