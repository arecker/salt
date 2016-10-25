#!/usr/bin/env bats

@test "locale: should set en_US.utf8 as LANG" {
    [ "$LANG" == "en_US.UTF-8" ]
}

@test "locale: should be able to output unicode" {
    result=$(echo -e '\xe2\x82\xac')
    [ "$result" == "€" ]
}
