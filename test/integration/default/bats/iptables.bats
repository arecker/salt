@test "iptables: should be able to ping localhost" {
    ping -c 1 localhost
    [ $? -eq 0 ]
}

@test "iptables: should be able to ping google.com" {
    ping -c 1 google.com
    [ $? -eq 0 ]
}
