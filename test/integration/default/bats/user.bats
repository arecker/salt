@test "user: bash should be installed" {
    which bash
}

@test "user: sudo should be installed" {
    which sudo
}

@test "user: zsh should be installed" {
    which zsh
}

@test "user: home directories should be created" {
    test -d /home/alex && test -d /home/marissa
}
