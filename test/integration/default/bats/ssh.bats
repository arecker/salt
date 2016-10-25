#!/usr/bin/env bats

@test "ssh: motd exists" {
    run test -f /etc/motd
    [ $status -eq 0 ]
}

@test "ssh: config exists" {
    run test -f /etc/ssh/sshd_config
    [ $status -eq 0 ]
}
