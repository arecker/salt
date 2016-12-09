@test "ssh: config exists" {
    test -f /etc/ssh/sshd_config
}

@test "ssh: daemon is running" {
      ps -ef | grep sshd
}

@test "ssh: daemon is listening on port 22" {
    netstat -aln | grep ":22"
}
