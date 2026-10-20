# First session: environment preparation

Today's goal: inventory the Mac, review the AWS design, then provision two Windows hosts.
AD configuration is a separate checkpoint, so the session can stop after successful RDP.

1. Extract this ZIP into your home folder. Open `systems-administration-labs` in VS Code.
2. Open Terminal and run:

```bash
cd ~/systems-administration-labs
bash scripts/mac-inventory.sh
```

Record the chip, RAM and free storage. The script does not collect serial numbers or change
system settings. Its results stay local in ignored `evidence/local/`.
The AWS path does not require the Mac to host Windows VMs.

3. Open [docs/aws-setup.md](docs/aws-setup.md). Check AWS access, costs and prerequisites.
4. Deploy the included template and confirm both machines show up in Systems Manager.
5. Set each machine's administrator password through an interactive SSM session and connect
   using an SSM RDP tunnel. Run the baseline script to name the hosts, then reboot.
6. Save a sanitized screenshot or command result showing each correct hostname.

Stop here if that uses your session. Resume with lab 01 next time.

Do not change your AI project's virtual environment or repository for these labs.
