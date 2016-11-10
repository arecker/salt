#!/usr/bin/env bats

@test "ssl: certbot-auto installed" {
    test -f /usr/local/sbin/certbot-auto
}

@test "ssl: certbot-auto cron installed" {
    crontab -l | grep 'certbot-auto renew'
}
