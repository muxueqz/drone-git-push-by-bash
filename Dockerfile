FROM alpine
RUN apk -Uuv add git
RUN apk add openssh-client
ADD script.sh /bin/
RUN chmod +x /bin/script.sh
ENTRYPOINT /bin/script.sh
