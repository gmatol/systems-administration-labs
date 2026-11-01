# Validation status — 2026-10-31

## Assistant-side Linux workspace checks

Base inspected: `main` commit `636f77fb7d9f3ddbf9f90c0a23200c244aefb650`.
Existing completed AD incidents and Terraform work were preserved. No AGENTS.md was found in the checkout.

- `bash -n practice/backup-restore/file-backup.sh`: passed.
- `bash practice/backup-restore/file-backup.sh --non-interactive`: exited 0; source/service.txt absence confirmed; restored file count 2; pre-loss and restored SHA256 manifests matched.
- Baseline `service.txt`: `c2bf7b834a498c4e7e576e8f35491b48dd3f439642c6e65d5114a882bcba6a2f`.
- Baseline `tickets.csv`: `4e4823ac86dc61bb29f964b53b2d242286a5946d1746280fc7c59d2c036b0ace`.
- Optional rsync sequence: preview, backup, simulated loss, restore and both byte comparisons passed.
- Negative check: appended text to the restored fictional service file; comparison detected the difference as expected.
- Invalid mode: rejected with usage text and exit 2.

These results belong to the assistant's ephemeral Linux workspace, not Guot's Mac, Windows environment or AWS environment. They are not evidence of a completed personal lab.

## Pending verification

- Guided user practice and actual evidence capture.
- macOS/BSD tar execution.
- PowerShell execution (PowerShell is unavailable in the checking workspace); script reviewed only.
- Windows Server Backup creation/catalog/file recovery on a disposable non-DC server.
- NTFS/Linux permissions, ownership, ACLs, application consistency and full-server recovery.
- EBS snapshot creation/restore and AD system-state/disaster recovery.

No AWS API operations, instance changes, snapshots or DC restores were performed. No study schedules were changed.

## Automated runner checks — 2026-11-01

Added `.github/workflows/backup-restore.yml` for pull requests (including drafts),
limited to this exercise and its workflow. Ubuntu runs Bash; Windows runs
PowerShell via pwsh. Both use the standard-library Python test harness.
Only fresh runner-local temporary directories and fictional files are used.
Contents permission is read-only; checkout credentials are not persisted.
No secrets, AWS credentials, deployments or remote server access are used.

The harness independently checks exit 0, the missing source file, preserved
lost file, exactly two restored files, and recomputed SHA256 values against
the baseline and restored manifests. Temporary mutated script copies test
extraction errors and corrupt restored content; each must exit nonzero.
Harness assertions fail the workflow step; no continue-on-error is used.

Assistant Linux workspace: new Bash harness passed, including both negative
cases (exit 1). GitHub-hosted Ubuntu and Windows results are pending review.
PowerShell execution remains unverified until a Windows job succeeds.

Personal Mac and Windows Server exercises remain pending. Automated file-content
recovery does not demonstrate Windows Server Backup, NTFS permission recovery,
Active Directory recovery or full-server disaster recovery. DC01 and MGMT01
were not accessed or modified. Keep PR #3 draft pending personal validation.
