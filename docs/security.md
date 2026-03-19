# Security Guidance

This repository is designed for a home-network Pi-hole deployment, not for internet exposure.

## Key Decisions

- The Pi-hole image is pinned to a specific release in `.env.example` instead of using `latest`
- The admin password is loaded from a local secret file via `WEBPASSWORD_FILE`
- The container does not request `NET_ADMIN` because AdHarbor is not using Pi-hole as a DHCP server
- Only the web UI port `8080` and DNS port `53` are intentionally published

## Required Operating Rules

- Never expose the Pi-hole host with FRITZ!Box port sharing
- Keep access to the admin UI inside your home LAN only
- Use a long random password for `.secrets/pihole_webpassword.txt`
- Keep the Docker host updated because Pi-hole depends on the host's network and container runtime security
- Review Pi-hole updates before bumping the pinned image tag

## Why The Password File Matters

Using a secret file avoids storing the admin password in:

- Git history
- shell history from inline environment exports
- screenshots or copied `.env` snippets

## Recommended Home-Network Practice

- Reserve the Docker host IP in the FRITZ!Box
- Test with one client before switching the whole network
- Keep a second DNS rollback path ready through the FRITZ!Box
- Write down allowlist changes that were needed for streaming, smart home, or banking apps

## Optional Future Hardening

- Limit UI access further with a host firewall on port `8080`
- Add scheduled encrypted backups of `volumes/etc-pihole`
- Add update review notes before changing the pinned image tag

