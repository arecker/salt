@test "redis: client should be installed" {
    which redis-cli
}

@test "redis: server should respond to ping" {
    redis-cli ping
}
