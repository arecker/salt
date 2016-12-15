@test "nginx: package should be installed and callable" {
    which nginx
}

@test "nginx: config should be valid" {
    nginx -c /etc/nginx/nginx.conf -t
}

@test "nginx: service should be running" {
    ps waux | grep nginx
}

@test "nginx: default web page should be reachable" {
    curl -I localhost
}

@test "nginx: default web page should have expected title tag" {
    curl localhost | grep "<title>It's Working</title>"
}
@test "nginx: bobrosssearch.local should be reachable" {
    curl -I http://bobrosssearch.local
}

@test "nginx: bobrosssearch.local should have expected title tag" {
    curl http://bobrosssearch.local | grep "<title>Bob Ross Search</title>"
}

@test "nginx: alexrecker.local/random.png should pass through to random.png proxy" {
    curl -L http://alexrecker.local/random.png | grep "No pictures to pick from"
}

@test "nginx: alexrecker.local/anakin/ should redirect" {
    curl -I http://alexrecker.local/anakin/ | grep "HTTP/1.1 301 Moved Permanently"
}

@test "nginx: alexrecker.local/anakin/ should redirect to anakin.html" {
    curl -I http://alexrecker.local/anakin/ | grep "alexrecker.local/anakin.html"
}

@test "nginx: reckerdogs.local should show wordpress installation page" {
    curl -L http://reckerdogs.local | grep "<title>WordPress &rsaquo; Installation</title>"
}
