FROM alpine:3.6
LABEL maintainer "v.la@live.cn"

ENV TRANSMISSION_DIR=/transmission

RUN apk --update upgrade \
    && apk --no-cache --no-progress add bash shadow curl su-exec transmission-daemon \
    && mv /var/lib/transmission $TRANSMISSION_DIR \
    && usermod -d $TRANSMISSION_DIR transmission \
    && [[ -d $TRANSMISSION_DIR/downloads ]] || mkdir -p $TRANSMISSION_DIR/downloads \
    && [[ -d $TRANSMISSION_DIR/incomplete ]] || mkdir -p $TRANSMISSION_DIR/incomplete \
    && [[ -d $TRANSMISSION_DIR/info/blocklists ]] || mkdir -p $TRANSMISSION_DIR/info/blocklists \
    && chown -Rh transmission. $TRANSMISSION_DIR \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/*
    

COPY entrypoint.sh /usr/local/bin/transmission.sh
COPY settings.json /etc/transmission/settings.json

RUN chmod 755 /usr/local/bin/transmission.sh

EXPOSE 9091 51413/tcp 51413/udp

VOLUME ["${TRANSMISSION_DIR}"]
WORKDIR ${TRANSMISSION_DIR}

ENTRYPOINT ["transmission.sh"]

