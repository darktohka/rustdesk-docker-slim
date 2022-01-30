# RustDesk Docker (slim)

A very slim Docker image, containing the absolute minimum amount of libraries required to run RustDesk v1.1.4.

This image is based on the Debian Unstable (Debian Sid) image.

## Usage: Run hbbs and hbbr on server

By default, hbbs listens on 21115 (tcp) and 21116 (tcp/udp), hbbr listens on 21117 (tcp). Be sure to open these ports in the firewall.

- TCP(21115, 21116, 21117)
- UDP(21116)

Please run with "-h" option to see help if you want to choose your own port.

Make sure your data directory is owned by user ID `3300`!

### Docker example

```
sudo docker image pull darktohka/rustdesk-docker-slim
sudo docker run --name hbbr -p 21117:21117 -v `pwd`:/srv -it --rm darktohka/rustdesk-docker-slim hbbr
sudo docker run --name hbbs -p 21115:21115 -p 21116:21116 -p 21116:21116/udp -v `pwd`:/srv -it --rm darktohka/rustdesk-docker-slim hbbs -r <relay-server-ip>
```
