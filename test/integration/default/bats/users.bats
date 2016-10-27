#!/usr/bin/env bats

@test "users: home directories should be created" {
    run test -d /home/jim && run test -d /home/joe
    [ $status -eq 0 ]
}

@test "users: bash shell should be installed" {
    run which bash
    [ "$status" -eq 0 ]
}

@test "users: zsh shell should be installed" {
    run which zsh
    [ "$status" -eq 0 ]
}

@test "users: sudo should be installed" {
    run which sudo
    [ "$status" -eq 0 ]
}

@test "users: groups have been assigned correctly" {
    result=$(groups jim | tr ' ' '\n' | grep 'sudo' | wc -l)
    [ "$result" -eq 1 ]
    result=$(groups jim | tr ' ' '\n' | grep 'www-data' | wc -l)
    [ "$result" -eq 1 ]
    result=$(groups joe | tr ' ' '\n' | grep 'sudo' | wc -l)
    [ "$result" -eq 0 ]
    result=$(groups joe | tr ' ' '\n' | grep 'www-data' | wc -l)
    [ "$result" -eq 0 ]
}
