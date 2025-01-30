FROM alpine:latest

RUN apk update
RUN apk add --no-cache curl bash

ENV SLSKD_CONFIG_FILE=/slskd/config.yml
ENV PORT_FORWARDED=
ENV HTTP_S=http
ENV GLUETUN_HOST=localhost
ENV GLUETUN_PORT=8000
ENV RECHECK_TIME=60

COPY ./start.sh ./start.sh
RUN chmod 770 ./start.sh

CMD ["./start.sh"]