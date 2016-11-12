#!/usr/bin/env bats

@test "nginx: default web page exists" {
    test -f /var/www/html/index.html
}

@test "nginx: requesting localhost should render default web page" {
    [[ $(curl --silent localhost | grep "<title>It's Working</title>") ]]
}

@test "nginx: requesting bobrosssearch.local should render Bob" {
    [[ $(curl --silent bobrosssearch.local | grep "<title>Bob Ross Search</title>") ]]
}

@test "nginx: requesting bobrosssearch.local should pass through to service" {
    curl --silent -I bobrosssearch.local/random.png | grep '200 OK'
}
