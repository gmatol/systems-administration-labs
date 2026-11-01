"""Runner-local file recovery checks. No cloud access or administrator rights."""
import hashlib
import os
from pathlib import Path
import subprocess
import sys
import tempfile

kind = sys.argv[1]
assert kind in ("bash", "powershell")
folder = Path(__file__).resolve().parent
script = folder / ("file-backup.sh" if kind == "bash" else "file-backup.ps1")
original = script.read_text()
extract = ('tar -xzf "$run/backup/files.tar.gz" -C "$run/restored"'
           if kind == "bash" else "Expand-Archive -LiteralPath $Zip -DestinationPath $Restore")
assert original.count(extract) == 1, "Update fault injection for changed extraction code"


def invoke(path):
    command = (["bash", str(path), "--non-interactive"] if kind == "bash" else
               ["pwsh", "-NoLogo", "-NoProfile", "-NonInteractive", "-File", str(path), "-NonInteractive"])
    result = subprocess.run(command, capture_output=True, text=True, timeout=60)
    print(result.stdout)
    print(result.stderr)
    return result


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest().upper()


def manifest(path):
    entries = {}
    for line in path.read_text(encoding="utf-8-sig").splitlines():
        checksum, name = line.split(None, 1)
        entries[name.strip()] = checksum.upper()
    return entries


result = invoke(script)
assert result.returncode == 0, f"Recovery exited {result.returncode}"
runs = [line.removeprefix("Run directory: ") for line in result.stdout.splitlines()
        if line.startswith("Run directory: ")]
assert len(runs) == 1
run = Path(runs[0])
assert not (run / "source/service.txt").exists(), "Loss was not simulated"
assert (run / "lost/service.txt").is_file(), "Missing preserved lost file"
expected = manifest(run / "baseline.sha256")
assert set(expected) == {"service.txt", "tickets.csv"}
assert manifest(run / "restored.sha256") == expected
assert {p.name for p in (run / "restored").iterdir()} == set(expected)
for name, checksum in expected.items():
    assert digest(run / "restored" / name) == checksum, name
assert digest(run / "lost/service.txt") == expected["service.txt"]
assert digest(run / "source/tickets.csv") == expected["tickets.csv"]
print("PASS: independent loss, restoration, file count and SHA256 checks")

# Mutate temporary copies only; real lab scripts and caller data remain unchanged.
faults = {
    "extraction-error": ("false" if kind == "bash" else "throw 'Injected extraction failure'"),
    "corrupt-restored-content": extract + (
        '\nprintf "corrupt\\n" >> "$run/restored/service.txt"' if kind == "bash" else
        "\nAdd-Content -LiteralPath (Join-Path $Restore 'service.txt') -Value 'corrupt'")
}
with tempfile.TemporaryDirectory(prefix="recovery-negative-") as temporary:
    for name, replacement in faults.items():
        mutant = Path(temporary) / script.name
        mutant.write_text(original.replace(extract, replacement))
        result = invoke(mutant)
        assert result.returncode != 0, f"{name} incorrectly succeeded"
        if name == "corrupt-restored-content":
            assert ("Recovery hash mismatch" in result.stderr if kind == "powershell"
                    else "differ" in result.stdout), "Did not reach hash mismatch"
        print(f"PASS: {name} rejected with exit {result.returncode}")
# Unhandled assertion/subprocess errors exit nonzero and fail the Actions step.
