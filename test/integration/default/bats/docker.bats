@test "docker: docker client should be installed" {
    which docker
}

@test "docker: mysql container should be running" {
    RUNNING=$(docker inspect --format="{{ .State.Running }}" mysql 2> /dev/null)
    [ $RUNNING == "true" ]
}

@test "docker: reckerdogs container should be running" {
    RUNNING=$(docker inspect --format="{{ .State.Running }}" reckerdogs 2> /dev/null)
    [ $RUNNING == "true" ]
}
