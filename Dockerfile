FROM alpine:3.18

COPY entrypoint.sh /entrypoint.sh
COPY known_hosts /root/.ssh/known_hosts

RUN apk --update add git openssh-client jq
RUN mkdir -p /source /dest /root/.ssh
RUN touch /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
RUN eval "$(ssh-agent -s)"
RUN ssh-keygen -F github.com

RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

