# dwarven/vsftpd

[![](https://img.shields.io/docker/pulls/dwarven/vsftpd.svg)](https://hub.docker.com/r/dwarven/vsftpd)

This Docker container implements a vsftpd server, with the following features:

 * Alpine 3.21.2 base image.
 * vsftpd 3.0.5
 * Virtual users
 * Passive mode
 * Logging to a file or `STDOUT`.

### Installation from [Docker registry hub](https://registry.hub.docker.com/r/dwarven/vsftpd/).

You can download the image with the following command:

```bash
docker pull dwarven/vsftpd
```

Environment variables
----

This image uses environment variables to allow the configuration of some parameters at run time:

* Variable name: `FTP_USER`
* Default value: user
* Accepted values: Any string. Avoid whitespaces and special chars.
* Description: Username for the default FTP account. If you don't specify it through the `FTP_USER` environment variable at run time, `user` will be used by default.

----

* Variable name: `FTP_PASS`
* Default value: pass
* Accepted values: Any string.
* Description: If you don't specify a password for the default FTP account through `FTP_PASS`.

----

* Variable name: `PASV_ADDRESS`
* Default value: Docker host IP / Hostname.
* Accepted values: Any IPv4 address or Hostname (see PASV_ADDR_RESOLVE).
* Description: If you don't specify an IP address to be used in passive mode, the routed IP address of the Docker host will be used. Bear in mind that this could be a local address.

----

* Variable name: `PASV_ADDRESS_INTERFACE`
* Default value: eth0.
* Accepted values: Specific network interface for `PASV_ADDRESS`.
* Description: Allow you to extract the IP address of a network interface to set the `PASV_ADDRESS` dynamically. Usefull when you want to connect to the FTP server from Host machine or from another container.

----

* Variable name: `PASV_ADDR_RESOLVE`
* Default value: NO
* Accepted values: <NO|YES>
* Description: Set to YES if you want to use a hostname (as opposed to IP address) in the PASV_ADDRESS option.

----

* Variable name: `PASV_ENABLE`
* Default value: YES
* Accepted values: <NO|YES>
* Description: Set to NO if you want to disallow the PASV method of obtaining a data connection.

----

* Variable name: `PASV_MIN_PORT`
* Default value: 21100
* Accepted values: Any valid port number.
* Description: This will be used as the lower bound of the passive mode port range. Remember to publish your ports with `docker -p` parameter.

----

* Variable name: `PASV_MAX_PORT`
* Default value: 21110
* Accepted values: Any valid port number.
* Description: This will be used as the upper bound of the passive mode port range. It will take longer to start a container with a high number of published ports.

----

* Variable name: `LOG_STDOUT`
* Default value: Empty string.
* Accepted values: Any string to enable, empty string or not defined to disable.
* Description: Output vsftpd log through STDOUT, so that it can be accessed through the [container logs](https://docs.docker.com/engine/reference/commandline/container_logs).

----

Use cases
----

### Create a temporary container for testing purposes:

```bash
  docker run --rm dwarven/vsftpd
```

### Create a container in active mode using the default user account, with a binded data directory:

```bash
docker run -d -p 21:21 -v /path/to/data:/home/vsftpd --name vsftpd dwarven/vsftpd
# see logs for credentials:
docker logs vsftpd
```

### Create a **production container** with a custom user account, binding a data directory and enabling both active and passive mode:

```bash
docker run -d -v /path/to/data:/home/vsftpd \
-p 20:20 -p 21:21 -p 21100-21110:21100-21110 \
-e FTP_USER=user -e FTP_PASS=pass \
-e PASV_ADDRESS=127.0.0.1 -e PASV_MIN_PORT=21100 -e PASV_MAX_PORT=21110 \
--name vsftpd --restart=always dwarven/vsftpd
```
