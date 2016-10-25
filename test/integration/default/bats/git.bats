#!/usr/bin/env bats

@test "git: client installed" {
    which git
}

@test "git: test project cloned" {
    test -d /src/bob
}

@test "git: test project has correct owner" {
    [ $(stat -c '%U' /src/bob) = "joe" ]
}
