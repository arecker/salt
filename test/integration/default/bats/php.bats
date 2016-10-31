#!/usr/bin/env bats

@test "php: cli installed" {
    which php
}

@test "php: localhost/info.php is rendering" {
    [[ $(curl --silent -L localhost/info.php | grep "phpinfo()</title>") ]]
}
