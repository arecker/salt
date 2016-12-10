@test "postgres: client should be intalled" {
    which psql
}

@test "postgres: moolah db should exist" {
    su -c "psql -lqt | cut -d \| -f 1 | grep -qw moolah" postgres
}

@test "postgres: moolah user should exist" {
    su -c "psql -t -c '\du' | cut -d \| -f 1 | grep -qw moolah" postgres
}
