#!/usr/bin/env bats

@test "wordpress source exists" {
    run test -f /opt/wordpress.tar.gz
    [ $status -eq 0 ]
}

@test "wordpress root exists" {
    run test -d /var/www/joeblog
    [ $status -eq 0 ]
    run test -f /var/www/joeblog/index.php
    [ $status -eq 0 ]
}

@test "wordpress root has correct permissions" {
    USER=$(stat -c "%U" /var/www/joeblog/index.php)
    [ "$USER" = "joe" ]
    GROUP=$(stat -c "%G" /var/www/joeblog/index.php)
    [ "$GROUP" = "www-data" ]
}

@test "wordpress config exists" {
    run test -f /var/www/joeblog/wp-config.php
    [ $status -eq 0 ]
}
