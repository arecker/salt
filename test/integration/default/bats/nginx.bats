#!/usr/bin/env bats

@test "nginx: default web page exists" {
    test -f /var/www/html/index.html
}

@test "nginx: requesting localhost should render default web page" {
    [[ $(curl --silent localhost | grep "<title>It's Working</title>") ]]
}
