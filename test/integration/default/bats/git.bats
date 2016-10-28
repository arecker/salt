#!/usr/bin/env bats

@test "git: client installed" {
    which git
}

@test "git: bob project cloned" {
    test -d /var/www/bob
}

@test "git: test project has correct owner" {
    [ $(stat -c '%U' /src/bob) = "joe" ]
}
