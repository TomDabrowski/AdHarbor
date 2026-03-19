# Backup And Restore

This setup keeps Pi-hole state in `volumes/etc-pihole`. That directory is enough for the normal backup path in this repository.

## Create A Backup

Run:

```bash
./scripts/backup.sh
```

The script creates a timestamped `.tar.gz` file in `backups/`.

## Restore From Backup

1. Stop Pi-hole:

   ```bash
   docker compose down
   ```

2. Move the current state out of the way if you want to keep it:

   ```bash
   mv volumes/etc-pihole volumes/etc-pihole.before-restore
   mkdir -p volumes/etc-pihole
   ```

3. Extract the backup:

   ```bash
   tar -xzf backups/<backup-file>.tar.gz -C /
   ```

4. Start Pi-hole again:

   ```bash
   docker compose up -d
   ```

5. Verify:
   - Admin UI login works
   - Your blocklists and allowlists are present
   - DNS queries appear in the dashboard

## Notes

- Run backups after you finish tuning blocklists and allowlists
- Keep at least one backup outside the Docker host
- If you change the host path layout later, update `scripts/backup.sh`

