import os


def get_python_path(user, project, info):
    return os.path.join('/home', user, '.virtualenvs', project, 'bin/python')


def get_settings_path(project, info):
    default = os.path.join(info['src'], project, 'settings/prod.py')
    return info.get('prod_settings', default)


def get_settings_module(project, info):
    default = '{}.settings.prod'.format(project)
    return info.get('prod_settings_module', default)
