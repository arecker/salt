#!/usr/bin/env bats

@test "redis: client installed" {
    which redis-cli
}

@test "redis: server ping" {
    redis-cli ping
}
