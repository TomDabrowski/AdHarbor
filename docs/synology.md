# Synology Deployment

This guide is for running AdHarbor on a Synology NAS with Container Manager.

## Tested Shape

- Synology NAS with DSM 7.2+
- Container Manager installed
- SSH enabled
- A fixed LAN IP reserved in the FRITZ!Box

## Why Synology Works Well

- The NAS is usually always on
- Pi-hole needs very little CPU and storage
- Docker Compose is already available through Synology's Docker integration

## Prepare The Folder Layout

Create a working directory on the NAS:

```bash
sudo mkdir -p /volume1/docker/AdHarbor/.secrets
sudo mkdir -p /volume1/docker/AdHarbor/volumes/etc-pihole
sudo chmod 700 /volume1/docker/AdHarbor/.secrets
```

## Create `.env`

Create `/volume1/docker/AdHarbor/.env` with values like:

```dotenv
TZ=Europe/Berlin
PIHOLE_IMAGE=pihole/pihole:2026.02.0
PIHOLE_HOSTNAME=adharbor
LOCAL_IPV4=<nas-lan-ip>
PIHOLE_WEB_PORT=8080
PIHOLE_DNS_PORT=53
PIHOLE_UPSTREAM_DNS=1.1.1.1;1.0.0.1
```

Replace `<nas-lan-ip>` with the LAN IP of the Synology.

## Create The Admin Password Secret

Create the secret file locally on the NAS:

```bash
sudo sh -c 'cat > /volume1/docker/AdHarbor/.secrets/pihole_webpassword.txt'
sudo chmod 600 /volume1/docker/AdHarbor/.secrets/pihole_webpassword.txt
```

Paste the password, press `Enter`, then `Ctrl+D`.

## Create `docker-compose.yml`

Use the repository's `docker-compose.yml` in `/volume1/docker/AdHarbor/`.

If you are setting this up manually on the NAS, it should contain:

```yaml
services:
  pihole:
    container_name: adharbor-pihole
    image: ${PIHOLE_IMAGE}
    hostname: ${PIHOLE_HOSTNAME}
    restart: unless-stopped
    ports:
      - "${PIHOLE_DNS_PORT}:53/tcp"
      - "${PIHOLE_DNS_PORT}:53/udp"
      - "${PIHOLE_WEB_PORT}:80/tcp"
    environment:
      TZ: ${TZ}
      FTLCONF_dns_listeningMode: all
      FTLCONF_dns_upstreams: ${PIHOLE_UPSTREAM_DNS}
      WEBPASSWORD_FILE: /run/secrets/pihole_webpassword
    volumes:
      - ./volumes/etc-pihole:/etc/pihole
    secrets:
      - pihole_webpassword

secrets:
  pihole_webpassword:
    file: ./.secrets/pihole_webpassword.txt
```

## Start Pi-hole

On Synology, Docker socket access may require `sudo` even for administrator users.

```bash
cd /volume1/docker/AdHarbor
sudo docker compose config
sudo docker compose up -d
sudo docker compose ps
```

When healthy, the admin UI is available at:

```text
http://<nas-lan-ip>:8080/admin/
```

## If The Login Password Does Not Work

Set it directly inside the running container:

```bash
sudo docker exec -it adharbor-pihole pihole setpassword
```

## FRITZ!Box DNS

Once Pi-hole is healthy, set the FRITZ!Box local DNS server to the Synology LAN IP and renew client leases.

See `docs/fritzbox.md`.

## Operational Commands

Status:

```bash
cd /volume1/docker/AdHarbor && sudo docker compose ps
```

Logs:

```bash
cd /volume1/docker/AdHarbor && sudo docker compose logs --tail=100
```

Restart:

```bash
cd /volume1/docker/AdHarbor && sudo docker compose restart
```

Stop:

```bash
cd /volume1/docker/AdHarbor && sudo docker compose down
```

## Notes

- Do not expose ports `53` or `8080` through FRITZ!Box port sharing
- Keep the password file only on the NAS, never in Git
- If `git` is not installed on the NAS, you can still deploy by copying the repository files manually
