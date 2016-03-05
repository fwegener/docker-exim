FROM debian:jessie
MAINTAINER Frank Wegener <wegener-it@cc-email.eu>

RUN DEBIAN_FRONTEND=noninteractive ;\
    apt-get update 


RUN { \
	usermod -u 560 mail; \
	groupmod -g 560 mail; \
}

RUN DEBIAN_FRONTEND=noninteractive ;\
    apt-get install --assume-yes \
        exim4 \
	maildrop \
        sudo

RUN apt-get clean

RUN { \
        ln --symbolic --force /exim4/exim4.conf /etc/exim4/exim4.conf; \
}

EXPOSE 25

ENTRYPOINT ["/usr/sbin/exim4", "-bdf", "-v", "-q15m"]
