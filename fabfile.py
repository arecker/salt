import os

from fabric.operations import (
    local as _local,
    run as _run,
    sudo as _sudo
)
from fabric.api import task
from fabric.state import env


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
def minion():
    run('echo "I am $(whoami) on $(hostname)"')
