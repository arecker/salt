#!/usr/bin/env bats

@test "en_US.utf8 is LANG" {
    [ "$LANG" == "en_US.UTF-8" ]
}

@test "unicode works" {
    result=$(echo -e '\xe2\x82\xac')
    [ "$result" == "€" ]
}
