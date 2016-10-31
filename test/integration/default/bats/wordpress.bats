#!/usr/bin/env bats

@test "wordpress: source code should have been downloaded" {
    run test -f /opt/wordpress.tar.gz
    [ $status -eq 0 ]
}

@test "wordpress: site root should exist" {
    run test -d /var/www/joeblog
    [ $status -eq 0 ]
    run test -f /var/www/joeblog/index.php
    [ $status -eq 0 ]
}

@test "wordpress: site root should have correct permissions" {
    USER=$(stat -c "%U" /var/www/joeblog/index.php)
    [ "$USER" = "joe" ]
    GROUP=$(stat -c "%G" /var/www/joeblog/index.php)
    [ "$GROUP" = "www-data" ]
}

@test "wordpress: config should exist" {
    run test -f /var/www/joeblog/wp-config.php
    [ $status -eq 0 ]
}

@test "wordpress: uploads dir should exist" {
    run test -d /var/www/joeblog/wp-content/uploads
    [ $status -eq 0 ]
}

@test "wordpress: site should be redirecting to install page" {
    [[ $(curl --silent -L joesblog.com | grep "<title>WordPress &rsaquo; Installation</title>") ]]
}
