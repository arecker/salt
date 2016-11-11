#!/usr/bin/env bats

@test "postgres: client installed" {
    which psql
}
