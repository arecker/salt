import os

try:
    from fabric.operations import (
        local as _local,
        run as _run,
        sudo as _sudo
    )
    from fabric.api import task
    from fabric.state import env
except ImportError:
    print('pip install fabric, stupid')
    exit(1)


env.local = False
env.use_ssh_config = True


def sudo(*args, **kwargs):
    if env.local:
        return _local(*args, **kwargs)
    return _sudo(*args, **kwargs)


def run(*args, **kwargs):
    if env.local:
        return _local(*args, **kwargs)
    return _run(*args, **kwargs)


@task
def local():
    if os.geteuid() != 0:
        print('Local execution must be run as root')
        exit(1)

    env.local = True


@task
def repo():
    sudo('apt-get install -y apt-transport-https')
    sudo(
        'wget -O - https://repo.saltstack.com'
        '/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub | '
        'apt-key add -'
    )
    sudo('echo {} > /etc/apt/sources.list.d/saltstack.list'.format(
        'deb https://repo.saltstack.com'
        '/apt/debian/8/amd64/latest jessie main'
    ))
    sudo('apt-get update')


@task
def minion(master='salt'):
    config = '\n'.join([
        'master: ' + master
    ])
    sudo('apt-get install -y salt-minion')
    sudo('echo "{}" > /etc/salt/minion'.format(config))
    sudo('systemctl restart salt-minion')
