#!/usr/bin/env bash
# Fictional files only. No sudo, AWS calls, deletion, or caller-supplied paths.
set -euo pipefail
umask 077
mode=${1:-guided}
case "$mode" in guided|--non-interactive) ;; *) echo 'Usage: bash file-backup.sh [--non-interactive]' >&2; exit 2;; esac
pause() { if [ "$mode" = guided ]; then read -r -p "$1 Press Enter to continue (Ctrl-C stops): " reply; fi; }
hash() { if command -v sha256sum >/dev/null; then sha256sum "$1"; else shasum -a 256 "$1"; fi; }
run=$(mktemp -d "${TMPDIR:-/tmp}/sysadmin-backup.XXXXXXXX")
mkdir "$run/source" "$run/backup" "$run/restored" "$run/lost"
printf 'Fictional service: inventory-demo\nOwner: Lab Team\n' > "$run/source/service.txt"
printf 'ticket,status\nDEMO-001,resolved\n' > "$run/source/tickets.csv"
printf 'Run directory: %s\n' "$run"
# Baseline manifest uses relative names, so it also works in restored/.
(cd "$run/source"; hash service.txt; hash tickets.csv) > "$run/baseline.sha256"
cat "$run/baseline.sha256"
pause 'Predict: why record hashes BEFORE losing a file?'
tar -czf "$run/backup/files.tar.gz" -C "$run/source" .
(cd "$run/backup"; hash files.tar.gz) > "$run/archive.sha256"
tar -tzf "$run/backup/files.tar.gz"
printf 'Archive SHA256: '; cat "$run/archive.sha256"
# Check archive bytes again before any simulated loss.
(cd "$run/backup"; hash files.tar.gz) > "$run/archive-current.sha256"
cmp "$run/archive.sha256" "$run/archive-current.sha256"
pause 'Backup created and readable. Predict: does listing alone prove recovery?'
# Move only a known fictional file; preserve it in lost/ for inspection.
mv "$run/source/service.txt" "$run/lost/service.txt"
test ! -e "$run/source/service.txt"
echo 'Simulated loss confirmed: source/service.txt is absent.'
pause 'Predict: why restore into an empty folder rather than overwrite the source?'
# Only extract the archive just created by this script; never use untrusted archives.
tar -xzf "$run/backup/files.tar.gz" -C "$run/restored"
(cd "$run/restored"; hash service.txt; hash tickets.csv) > "$run/restored.sha256"
cmp "$run/baseline.sha256" "$run/restored.sha256"
test "$(find "$run/restored" -type f | wc -l | tr -d ' ')" = 2
cat "$run/restored/service.txt"
echo 'PASS: two restored files match the pre-loss SHA256 manifest.'
echo 'Scope: file contents only; no OS, ACL, application, or AD recovery tested.'
printf 'Evidence retained at %s (temporary; copy sanitized results before closing).\n' "$run"
