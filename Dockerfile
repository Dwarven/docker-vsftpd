FROM alpine:3.21.2

MAINTAINER Dwarven <prison.yang@gmail.com>
LABEL Description="vsftpd Docker image based on alpine 3.21.2. Supports passive mode and virtual users." \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST PORT NUMBER]:21 -v [HOST FTP HOME]:/home/vsftpd dwarven/vsftpd" \
	Version="1.0"

RUN apk add --no-cache bash vsftpd

RUN mkdir -p /home/vsftpd
RUN mkdir -p /var/log/vsftpd
RUN chown -R ftp:ftp /home/vsftpd

COPY vsftpd-base.conf /etc/vsftpd
COPY run-vsftpd.sh /usr/sbin
RUN chmod +x /usr/sbin/run-vsftpd.sh

EXPOSE 20-21 21100-21110

CMD ["/usr/sbin/run-vsftpd.sh"]
