#!/usr/bin/env bats

@test "hosts: extrahost exists" {
    cat /etc/hosts | grep 'extrahost'
}
