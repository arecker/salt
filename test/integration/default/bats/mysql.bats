@test "mysql: client should be installed" {
    which mysql
}

@test "mysql: server should be listening on 3306" {
    netstat -aln | grep ":3306"
}


@test "mysql: test users should exist" {
    EXISTS="$(mysql -uroot  -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = 'reckerdogs')")"
    [ $EXISTS -eq 1 ]
}

@test "mysql: test dbs should exist" {
    EXISTS="$(mysql -uroot  -sse "SELECT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'reckerdogs')")"
    [ $EXISTS -eq 1 ]
}
