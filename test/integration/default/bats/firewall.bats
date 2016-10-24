#!/usr/bin/env bats

@test "test ping localhost" {
    ping -c 1 localhost
    [ $? -eq 0 ]
}
