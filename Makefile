all:
	sudo docker build -t salt-base .
run:
	sudo docker run -p 8022:22 -i -t salt-base /bin/bash
