#!/usr/bin/env bats

@test "ls is found in PATH" {
  run which ls
  [ "$status" -eq 0 ]
}
