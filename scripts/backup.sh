#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$ROOT_DIR/volumes/etc-pihole"
BACKUP_DIR="$ROOT_DIR/backups"
TIMESTAMP="$(date +"%Y%m%d-%H%M%S")"
ARCHIVE_PATH="$BACKUP_DIR/pihole-backup-$TIMESTAMP.tar.gz"

mkdir -p "$BACKUP_DIR"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Missing source directory: $SOURCE_DIR" >&2
  echo "Start Pi-hole once before creating a backup." >&2
  exit 1
fi

tar -czf "$ARCHIVE_PATH" -C "$ROOT_DIR" "volumes/etc-pihole"

echo "Backup created at: $ARCHIVE_PATH"
