# AdHarbor

AdHarbor is a self-hosted network-wide ad blocking setup based on Pi-hole and Docker, designed to work well behind a FRITZ!Box.

## What This Repository Contains

- A `docker-compose.yml` for running Pi-hole on a Docker host
- A `.env.example` template for local configuration
- A FRITZ!Box setup guide for using Pi-hole as the network DNS server
- A hardened password-file workflow so the Pi-hole admin secret is not stored in `.env`
- A backup script for the persistent Pi-hole state

## Prerequisites

- A Docker host that runs continuously in your home network
- A static IP address or DHCP reservation for that host
- A FRITZ!Box that will hand out the Pi-hole address to clients

## Quick Start

1. Copy the environment template:

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and set:
   - `LOCAL_IPV4` to the LAN IP of your Docker host so you can use it in the FRITZ!Box DNS setting
   - `TZ` if needed
   - `PIHOLE_UPSTREAM_DNS` if you prefer other upstream resolvers

3. Create the admin password secret file:

   ```bash
   mkdir -p .secrets
   printf '%s\n' 'replace-with-a-long-random-password' > .secrets/pihole_webpassword.txt
   chmod 600 .secrets/pihole_webpassword.txt
   ```

4. Start Pi-hole:

   ```bash
   docker compose up -d
   ```

5. Open the Pi-hole admin UI:

   ```text
   http://<docker-host-ip>:8080/admin/
   ```

6. Follow the FRITZ!Box guide in `docs/fritzbox.md` so clients use Pi-hole for DNS.

## Recommended FRITZ!Box Preparation

- Reserve a fixed LAN IP for the Docker host in the FRITZ!Box
- Make sure no other service on that host already uses port `53`
- Keep the host powered on, otherwise DNS resolution in the network will fail
- Do not expose ports `53` or `8080` to the public internet
- Do not configure FRITZ!Box port sharing for the Pi-hole host

## Common Operations

Start:

```bash
docker compose up -d
```

Stop:

```bash
docker compose down
```

View logs:

```bash
docker compose logs -f
```

Update Pi-hole:

```bash
docker compose pull
docker compose up -d
```

Validate the Compose setup:

```bash
docker compose --env-file .env.example config
```

Run a local test on a machine where port `53` is already occupied:

```bash
PIHOLE_DNS_PORT=5353 docker-compose --env-file .env.example up -d
```

This is only for local validation. On the real always-on Docker host, keep DNS on port `53`.

Backup persistent data:

```bash
./scripts/backup.sh
```

## Project Notes

- The `volumes/` directory is ignored so local Pi-hole state does not get committed
- `.env` is ignored because it contains host-specific network settings
- `.secrets/` is ignored so the Pi-hole admin password stays out of Git
- The image tag is pinned to a specific Pi-hole release instead of `latest`
- If you want local DNS overrides later, manage them through the Pi-hole UI unless you have a strong reason to mount extra config

## Security Notes

- The current image pin is `pihole/pihole:2026.02.0`
- The Pi-hole admin password is read from `.secrets/pihole_webpassword.txt` using `WEBPASSWORD_FILE`
- `NET_ADMIN` is intentionally not enabled because this setup does not run DHCP from Pi-hole
- Keep the admin UI reachable only from your LAN and never via internet port forwarding
- Put the Docker host on a DHCP reservation or static IP so the FRITZ!Box DNS setting stays valid

See `docs/security.md` for the hardened operating guidance and `docs/backup-restore.md` for recovery steps.

## Next Good Step

Once the container is running, we can add custom allowlists and blocklists, plus optional health checks and update routines, if you want this repository to become your full home DNS playbook.
