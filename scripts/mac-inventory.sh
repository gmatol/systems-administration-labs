#!/bin/bash
set -euo pipefail
if [ "$(uname -s)" != "Darwin" ]; then
  echo "Run this inventory on your Mac, not a Linux shell." >&2
  exit 1
fi
lab_root="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$lab_root/evidence/local"
{
  printf '# Mac lab inventory\n'
  date -u '+Captured (UTC): %Y-%m-%dT%H:%M:%SZ'
  printf 'Architecture: '
  uname -m
  system_profiler SPHardwareDataType |
    awk -F': ' '/Model Name:|Model Identifier:|Chip:|Processor Name:|Memory:/ {print $1 ": " $2}'
  sw_vers
  df -h "$lab_root" | awk 'NR==2 {print "Filesystem:", $1, "Size:", $2, "Available:", $4}'
} | tee "$lab_root/evidence/local/mac-inventory.txt"
