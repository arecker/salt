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
    [ "$USER" = "www-data" ]
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

@test "wordpress: uploads dir should have correct permissions" {
    USER=$(stat -c "%U" /var/www/joeblog/wp-content/uploads)
    [ "$USER" = "www-data" ]
    GROUP=$(stat -c "%G" /var/www/joeblog/wp-content/uploads)
    [ "$GROUP" = "www-data" ]
}


@test "wordpress: site should be redirecting to install page" {
    [[ $(curl --silent -L joesblog.com | grep "<title>WordPress &rsaquo; Installation</title>") ]]
}

@test "wordpress: ssh keys should exist" {
    run test -f /home/joe/.ssh/wordpress
    [ $status -eq 0 ]
    run test -f /home/joe/.ssh/wordpress.pub
    [ $status -eq 0 ]
}

@test "wordpress: ssh keys should have correct permissions" {
    USER=$(stat -c "%U" /home/joe/.ssh/wordpress)
    [ "$USER" = "joe" ]
    GROUP=$(stat -c "%G" /home/joe/.ssh/wordpress)
    [ "$GROUP" = "www-data" ]
    USER=$(stat -c "%U" /home/joe/.ssh/wordpress.pub)
    [ "$USER" = "joe" ]
    GROUP=$(stat -c "%G" /home/joe/.ssh/wordpress.pub)
    [ "$GROUP" = "www-data" ]
}

@test "wordpress: config should have ssh key path" {
    [[ $(cat /var/www/joeblog/wp-config.php | grep '/home/joe/.ssh/wordpress.pub') ]]
}
