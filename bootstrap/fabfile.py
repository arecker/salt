from fabric.api import sudo, env, task


env['use_ssh_config'] = True

MASTER_CONFIG = '''
state_output: mixed
'''

MINION_CONFIG = '''
master: {master}
id: {id}
'''


def write_file(target='', content=''):
    sudo('cat > {} << EOL\n{}\nEOL'.format(target, content))


def add_repo():
    write_file(
        target='/etc/apt/sources.list.d/salt.list',
        content='deb http://repo.saltstack.com/apt/debian/8/amd64/latest jessie main'
    )
    sudo('wget -O - https://repo.saltstack.com/apt/debian/8/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -')
    sudo('apt-get update')


@task
def handshake():
    sudo('echo "Hello, from $(hostname)"')


@task
def master():
    add_repo()
    sudo('apt-get install -y salt-master')
    write_file(target='/etc/salt/master', content=MASTER_CONFIG)
    sudo('systemctl restart salt-master')
    sudo('apt-get install git')
    sudo('mkdir -p /srv/')
    sudo('git clone https://github.com/arecker/salt.git /srv/salt')


@task
def minion(id=None, master='salt.alexrecker.com'):
    add_repo()
    sudo('apt-get install -y salt-minion')

    id = id or sudo('hostname')

    write_file(
        target='/etc/salt/minion',
        content=MINION_CONFIG.format(
            master=master,
            id=id
        )
    )

    sudo('systemctl restart salt-minion')
    sudo('mkdir -p /srv/pillar')
