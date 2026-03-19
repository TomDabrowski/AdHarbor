# FRITZ!Box Setup

This guide connects your FRITZ!Box-based home network to Pi-hole running on your Docker host.

## Before You Change DNS

- Confirm the Docker host has a fixed IP address
- Confirm Pi-hole is reachable at `http://<docker-host-ip>:8080/admin/`
- Confirm port `53` on the Docker host is reachable in the LAN

## Option 1: Hand Out Pi-hole via DHCP

This is usually the cleanest setup because new clients automatically use Pi-hole.

1. Open the FRITZ!Box web interface.
2. Go to the network settings for IPv4 DNS or local network DHCP, depending on your FRITZ!OS version.
3. Set the local DNS server handed out by DHCP to the IP address of your Docker host.
4. Save the change.
5. Reconnect clients or renew DHCP leases so they receive the new DNS server.

## Option 2: Set DNS Per Client

Use this if you want to test Pi-hole with one device before switching the whole network.

1. Set the device DNS server manually to the Docker host IP.
2. Visit a few ad-heavy sites and check whether blocking works.
3. Open the Pi-hole dashboard and confirm queries appear in real time.

## FRITZ!Box IP Reservation

Before using Pi-hole as DNS for the whole network, reserve the Docker host IP in the FRITZ!Box so the address does not change.

Typical approach:

1. Open the FRITZ!Box device list.
2. Select the Docker host.
3. Enable the option that always assigns the same IPv4 address.

## Verification

After switching clients to Pi-hole:

- Open the Pi-hole dashboard and confirm live queries appear
- Test a site that normally serves ads
- Confirm normal browsing still works
- If a site breaks, allow the required domain in Pi-hole and test again

## Rollback

If something goes wrong:

1. Change the FRITZ!Box DNS setting back to the default resolver behavior
2. Reconnect the clients or renew DHCP leases
3. Check Pi-hole container logs with `docker compose logs -f`

## Good Follow-Ups

- Add custom allowlists for services that are too aggressive to block
- Export Pi-hole settings after the initial tuning
- Keep a short note of why important domains were allowed
