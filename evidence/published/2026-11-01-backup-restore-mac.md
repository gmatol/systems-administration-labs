Tested on macOS: fictional file backup and restoration.
Both restored files matched their original SHA256 hashes.
OS, permissions, applications, and Active Directory recovery were not tested.

Additional integrity test:
- Appended text to restored/service.txt.
- Its SHA256 changed to:
  ef53a8f32e391851a6beae7f3408adad0f143453107d92c0a65cd6a8367d16b3
- Extracted the unchanged backup into a new restored-again folder.
- Checked against the original SHA256 manifest:
  service.txt: OK
  tickets.csv: OK
  