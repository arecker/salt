from fabric.api import run, env, task

env.use_ssh_config = True

MINION_CONFIG = '\n'.join([
    'master: salt.alexrecker.com'
])


@task
def handshake():
    run('echo "I am $(whoami) running on $(hostname)"')


@task(default=True)
def bootstrap():
    """Bootstrap a host with salt-minion

    - Only works for Debian 8 right now
    - Must be run as root over ssh
    """
    run(' && '.join([
        'apt-get update',
        'apt-get install -y apt-transport-https',
        'wget -O - https://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -',
        'echo "deb http://repo.saltstack.com/apt/debian/8/amd64/latest jessie main" > /etc/apt/sources.list.d/saltstack.list',
        'apt-get update',
        'apt-get install -y salt-minion',
        'echo "{}" > /etc/salt/minion'.format(MINION_CONFIG),
        'systemctl restart salt-minion',
    ]))
