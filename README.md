# AdHarbor

AdHarbor is a self-hosted network-wide ad blocking setup based on Pi-hole and Docker, designed to work well behind a FRITZ!Box.

## What This Repository Contains

- A `docker-compose.yml` for running Pi-hole on a Docker host
- A `.env.example` template for local configuration
- A FRITZ!Box setup guide for using Pi-hole as the network DNS server

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
   - `LOCAL_IPV4` to the LAN IP of your Docker host
   - `PIHOLE_WEBPASSWORD` to a strong admin password
   - `TZ` if needed
   - `PIHOLE_UPSTREAM_DNS` if you prefer other upstream resolvers

3. Start Pi-hole:

   ```bash
   docker compose up -d
   ```

4. Open the Pi-hole admin UI:

   ```text
   http://<docker-host-ip>:8080/admin/
   ```

5. Follow the FRITZ!Box guide in `docs/fritzbox.md` so clients use Pi-hole for DNS.

## Recommended FRITZ!Box Preparation

- Reserve a fixed LAN IP for the Docker host in the FRITZ!Box
- Make sure no other service on that host already uses port `53`
- Keep the host powered on, otherwise DNS resolution in the network will fail

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

## Project Notes

- The `volumes/` directory is ignored so local Pi-hole state does not get committed
- `.env` is ignored because it contains host-specific settings and your admin password
- If you want local DNS overrides later, they can be managed through the Pi-hole UI or added as mounted config files

## Next Good Step

Once the container is running, we can add backup instructions, custom allowlists and blocklists, and a small health-check script if you want the repository to become your full home DNS playbook.
