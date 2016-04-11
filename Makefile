all:
	sudo docker build -t salt-base .
run:
	sudo docker run --privileged -p 8022:22 -p 8080:80 -i -t salt-base /bin/bash
