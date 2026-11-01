# File backup and restore: guided practice

Status: learning procedure prepared. User execution is pending. See [VALIDATION.md](VALIDATION.md) for assistant-side checks, which are not evidence of recovery on Guot's Mac or Windows servers.

This adds a small file-recovery exercise alongside roadmap Session 8. Session 11 AWS recovery and later AD disaster recovery remain pending. Existing AD/Terraform results and the Monday/Wednesday/Friday AI engineering schedule are preserved. Use a Tuesday/Thursday admin session, one checkpoint at a time.

## What each backup protects

| Method | What it captures | Recovery scope and limits | Where to practice |
|---|---|---|---|
| Windows Server Backup (WSB) | Windows backup feature; selected files/volumes, system state or critical volumes depending on policy | File/folder recovery, volume recovery, or bare-metal recovery require the corresponding backup scope; VSS supports consistency | Later, isolated non-DC Windows Server with a suitable separate target |
| System-state backup | Windows system components; on a DC includes AD DS database and SYSVOL | Not a normal documents backup and not by itself a bare-metal image. AD restoration requires an AD-aware recovery plan | Later, isolated disposable AD environment only |
| Linux `tar` | Files bundled in an archive | File recovery; production permissions, ownership, ACLs, xattrs and application consistency need explicit handling | This lab: macOS Bash portability practice or existing Linux shell |
| Linux `rsync` | Copies/updates a directory tree; archive mode preserves common metadata where supported | File recovery; a mirror can propagate unwanted changes. `-a` alone does not preserve all ACLs/xattrs/hard links | Optional local lab below |
| AWS EBS snapshot | Point-in-time block-level copy of an EBS volume | Restore to a new volume, then recover files or design a boot recovery workflow; not an entire EC2 configuration or AD recovery plan | Concept only here; snapshots and restored volumes cost money |

An archive checksum detects changed archive bytes against a trusted baseline. A listing proves readability, not successful recovery. Restoring into a fresh location and comparing every known file with its pre-loss hash proves content recovery for this two-file dataset. It does not prove application consistency, ACL recovery, bootability or AD health. A checksum stored beside an archive is not protection against malicious alteration of both.

The same-disk backup below is deliberately a mechanics exercise: it cannot protect against disk failure. Production design also needs independent/offsite copies, access control, encryption, retention, monitoring and repeated restore tests. Define RPO (how much recent data can be lost) and RTO (how long recovery may take).

## 1. Open the correct project in VS Code on your Mac

1. File → Open Folder → your existing `systems-administration-labs` directory. Confirm the Explorer shows `windows`, `docs` and `practice`. Do not open the AI application repository.
2. Terminal → New Terminal. Run each command separately:

   ```bash
   pwd
   git status --short
   git branch --show-current
   git remote -v
   ```

   `pwd` checks the folder, status reveals existing work, branch identifies your checkout and remote confirms the repository. Stop if there are unfamiliar changes; do not reset, clean, or overwrite them.
3. If you have a clean checkout on `main`, use `git pull --ff-only`. To obtain this lab branch after it is published, run `git fetch origin` and `git switch --track origin/practice/backup-restore` (if that local branch already exists, use `git switch practice/backup-restore`). If the lab has since merged, stay on updated `main` instead.
4. In Explorer, expand `practice/backup-restore` and open `file-backup.sh`. Read the header and find `mktemp`, `tar`, `mv` and `cmp` before executing anything.
5. Run `bash --version` and `tar --version`. macOS is not Linux; its BSD tar differs from GNU tar. This exercise uses common options. Do not install a Linux VM or start AWS just for this first checkpoint.

## 2. Run the guided Bash exercise

From the repository root:

```bash
bash practice/backup-restore/file-backup.sh
```

Do not use `sudo`. The script stops at three learning checkpoints. Before pressing Enter, explain what you expect. Ctrl-C stops safely; each rerun uses a fresh temporary directory. Nothing is deleted automatically.

| Command in the script | What you should understand | Expected checkpoint |
|---|---|---|
| `set -euo pipefail` | Fail on command errors, unset variables and pipeline errors | A failed check stops the exercise |
| `umask 077` | New lab files are private to your user | No shared/public backup directory |
| `mktemp -d` | Creates a unique temporary workspace | Printed `Run directory:` |
| `printf ... > file` | Writes only fictional data in that workspace | `service.txt` and `tickets.csv` |
| `sha256sum` or macOS `shasum -a 256` | Captures file-content fingerprints | Two baseline manifest lines |
| `tar -czf ... -C ... .` | Create (`c`) gzip (`z`) archive file (`f`); change to source (`-C`) | Archive outside the source tree |
| `tar -tzf ...` | List archive contents without extracting | Both fictional files listed |
| `cmp` archive hash manifests | Detect changed archive bytes before loss | No output, successful exit |
| `mv .../source/service.txt .../lost/service.txt` | Simulates loss by moving only the generated file aside | Source missing, preserved copy in `lost` |
| `tar -xzf ... -C .../restored` | Extract (`x`) only this script's trusted archive into an empty location | Two restored files |
| `cmp` baseline and restored manifests | Compare recovered content with pre-loss content | `PASS: two restored files ...` |

The file in `lost` is not used for restoration. The backup is the recovery source. Never substitute an untrusted archive: extraction can contain dangerous paths.

At each pause, use a second terminal and the printed run directory to inspect the files. For example, assign `lab_run` to that exact printed path, then run:

```bash
ls -la "$lab_run/source" "$lab_run/backup" "$lab_run/restored"
cat "$lab_run/baseline.sha256"
```

After PASS, read `restored/service.txt` and compare its fictional service name with the baseline. For a negative check, append `changed` to the **restored fictional** service file in your temporary run, then run `diff -u "$lab_run/lost/service.txt" "$lab_run/restored/service.txt"`. Expect a difference (exit 1); this proves comparison can detect changed content. Rerun the guided script for a fresh successful exercise.

Do not claim Linux-server recovery from macOS output. Repeat on an existing Linux host later, without sudo, to establish Linux evidence. Temporary directories can disappear; save sanitized observations promptly.

## 3. Optional rsync alternative (Mac or Linux)

Use only the generated run directory from the script; inspect `echo "$lab_run"` first. This creates a separate backup, not a live mirror of a real directory. Run one line at a time:

```bash
mkdir "$lab_run/rsync-source" "$lab_run/rsync-backup" "$lab_run/rsync-restored"
printf 'Fictional rsync recovery note\n' > "$lab_run/rsync-source/note.txt"
rsync -avn "$lab_run/rsync-source/" "$lab_run/rsync-backup/"
rsync -av "$lab_run/rsync-source/" "$lab_run/rsync-backup/"
cmp "$lab_run/rsync-source/note.txt" "$lab_run/rsync-backup/note.txt"
mv "$lab_run/rsync-source/note.txt" "$lab_run/lost/rsync-note.txt"
rsync -av "$lab_run/rsync-backup/" "$lab_run/rsync-restored/"
cmp "$lab_run/lost/rsync-note.txt" "$lab_run/rsync-restored/note.txt"
```

`-a` is archive mode, `-v` is verbose and `-n` previews without copying. The trailing slash copies directory contents. The first preview should name `note.txt`; both `cmp` checks should return no output and exit 0. Explain why the second copy reads the backup, not the now-empty source. No `--delete` is used. A production mirror without version retention can overwrite good backups with corruption; deletion propagation makes this worse. This tiny comparison checks file bytes, not Linux ACLs or ownership.

## 4. PowerShell file-content exercise

On an existing isolated non-DC Windows practice machine, open this folder in VS Code and choose a PowerShell terminal. Normal user rights suffice:

```powershell
$PSVersionTable.PSVersion
Get-Content .\practice\backup-restore\file-backup.ps1
.\practice\backup-restore\file-backup.ps1
```

PowerShell 5.1+ or 7 is needed. If policy blocks a script, inspect `Get-ExecutionPolicy -List` and use an approved signed-script workflow; do not weaken machine policy. PowerShell 7 on Mac can practice these file commands if already installed, but that is not Windows Server testing.

`New-Item` creates a fresh GUID-named temp directory; `Set-Content` creates fictional text; `Get-FileHash` captures SHA256; `Compress-Archive` creates a ZIP; `Move-Item` simulates loss without deleting; `Expand-Archive` restores into a fresh directory; `Compare-Object` checks filename/hash pairs. Expected: two baseline lines, pauses, simulated loss and final PASS. ZIP is a file-content exercise, **not WSB**, and does not preserve/validate NTFS ACLs or AD.

Do not connect to or change DC01/MGMT01 for this walkthrough. No AWS hosts have been started or modified. If no Windows environment is available, mark this section pending.

## 5. Environment-dependent follow-up

See [WINDOWS-AWS-FOLLOW-UP.md](WINDOWS-AWS-FOLLOW-UP.md). It explains WSB creation and file recovery on an isolated server, and keeps EBS and AD recovery as separate later work.

## Troubleshooting checkpoints

| Symptom | Check and next action |
|---|---|
| File not found in VS Code | Confirm opened repository, branch and terminal `pwd`; locate `practice/backup-restore` in Explorer |
| Script stops before a pause | Read the first error. Check available temp storage with `df -h`; rerun for a fresh directory, never use sudo |
| Hash command missing | Linux needs `sha256sum`; Mac uses `shasum -a 256`. Script chooses automatically |
| Archive command fails | Check `tar --version`, free disk space and source readability; do not simulate loss until backup verification passes |
| Manifest mismatch | Keep the failed run for inspection; compare filenames and hashes with `diff -u`; inspect whether content changed |
| `rsync` unavailable | Skip optional section until an approved local package is available; tar lab still works |
| PowerShell command unavailable | Confirm shell/version; Windows Server Backup cmdlets require the server feature and elevation, ZIP commands do not |
| Permission denied | Stay in the generated workspace; do not use `/etc`, real home documents, SYSVOL, NTDS or mounted production paths |
| No PASS after interruption | Record incomplete, not recovered; rerun from the beginning |

## Evidence and interview practice

Copy [REPORT-TEMPLATE.md](REPORT-TEMPLATE.md) to `evidence/local/backup-restore.md` (ignored by Git). Record platform, date, commit, actual commands, manifest, missing-file check, restoration output and failures. Review/redact before publishing any excerpt. Do not commit archives or temporary data. Mark Windows, WSB, AWS and AD tests pending until separately verified.

Three checks: Why is a same-disk archive insufficient? What does a matching SHA256 prove and leave untested? Why is restoring a text file different from restoring a domain controller?

After actual practice, describe only your verified result: “I backed up fictional files, simulated loss, restored into a separate directory and compared restored hashes with the original baseline.” Add platform and measured recovery time only when observed. Next goal: repeat on Linux, then plan WSB on a disposable non-DC server.

## Primary references

- [Microsoft: wbadmin start backup](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/wbadmin-start-backup)
- [Microsoft: system-state backup](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/wbadmin-start-systemstatebackup)
- [Microsoft: AD forest recovery guide](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/forest-recovery-guide/ad-forest-recovery-guide)
- [GNU tar manual](https://www.gnu.org/software/tar/manual/tar.html)
- [rsync manual](https://download.samba.org/pub/rsync/rsync.1)
- [AWS: creating EBS snapshots](https://docs.aws.amazon.com/ebs/latest/userguide/ebs-creating-snapshot.html)
