@test "virtualenv: client installed" {
    which virtualenv
}

@test "virtualenv: random.png virtual python exists" {
    test -f /home/alex/.virtualenvs/random.png/bin/python
}

@test "virtualenv: random.png virtual pip exists" {
    test -f /home/alex/.virtualenvs/random.png/bin/pip
}

@test "virtualenv: flask is installed to random.png" {
    /home/alex/.virtualenvs/random.png/bin/pip freeze | grep -i 'flask'
}
