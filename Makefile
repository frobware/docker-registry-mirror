data/domain.crt data/domain.key: Makefile restart-docker-mirror
	openssl req -newkey rsa:2048 -nodes -keyout data/domain.key -x509 -days 3650 -out data/domain.crt -subj "/C=US/ST=Oregon/L=Portland/O=Company Name/OU=Org/CN=www.example.com"

clean:
	$(RM) -f data/domain.crt data/domain.key

run:
	./restart-docker-mirror
