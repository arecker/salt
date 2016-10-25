#!/usr/bin/env bats

@test "mysql installed" {
    run which mysql
    [ "$status" -eq 0 ]
}

@test "mysql users exist" {
    EXISTS="$(mysql -uroot  -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = 'jim')")"
    [ $EXISTS -eq 1 ]
    EXISTS="$(mysql -uroot  -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = 'joe')")"
    [ $EXISTS -eq 1 ]
}

@test "mysql dbs exist" {
    EXISTS="$(mysql -uroot  -sse "SELECT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'jimdb')")"
    [ $EXISTS -eq 1 ]
    EXISTS="$(mysql -uroot  -sse "SELECT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'jimdb2')")"
    [ $EXISTS -eq 1 ]
    EXISTS="$(mysql -uroot  -sse "SELECT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'joeblog')")"
    [ $EXISTS -eq 1 ]
}
