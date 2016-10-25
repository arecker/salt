#!/usr/bin/env bats

@test "nginx: requesting localhost should render default web page" {
    [[ $(curl --silent localhost | grep "<title>It's Working</title>") ]]
}
