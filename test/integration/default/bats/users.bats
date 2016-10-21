#!/usr/bin/env bats

@test "test users' home created" {
    run test -d /home/jim && run test -d /home/joe
    [ $status -eq 0 ]
}

@test "bash shell installed" {
    run which bash
    [ "$status" -eq 0 ]
}

@test "zsh shell installed" {
    run which zsh
    [ "$status" -eq 0 ]
}

@test "sudo installed" {
    run which sudo
    [ "$status" -eq 0 ]
}
