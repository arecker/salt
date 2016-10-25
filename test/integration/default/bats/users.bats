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
