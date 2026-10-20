# Publish the portfolio

Target: a NEW repository named `systems-administration-labs` under your own GitHub account.
Do not upload this into the existing AI application repository or an unrelated project.
The package is ready to publish; no GitHub repository has been created by this package.

## Browser route

1. Open https://github.com/new while signed in as your own account.
2. Repository name: `systems-administration-labs`.
3. Description: `Hands-on Windows, Linux, AWS and networking labs with PowerShell automation and verified troubleshooting evidence.`
4. Choose Public if ready for recruiters. Do not initialize README, license or gitignore
   when following the Git push route below. Create repository.
5. Follow the commands below. If using Upload files instead, include the contents of the
   extracted folder, not the ZIP. Confirm `.gitignore` is included.

## Mac Git route

From the extracted folder, first review the files and `.gitignore`.
If this is already a Git checkout, inspect its current remote before changing anything.

```bash
cd ~/systems-administration-labs
git init -b main
git status
# Review staged files and ensure no credentials or private evidence are present.
git add .
git diff --cached --stat
git diff --cached
git commit -m "Add Windows administration lab setup and portfolio roadmap"
git remote add origin https://github.com/gmatol/systems-administration-labs.git
git push -u origin main
```

Use your normal GitHub sign-in flow if Git prompts for credentials; do not put a token
in a remote URL. If the repo/remote already exists, inspect it instead of rerunning init
or overwriting its history.

## Recruiter presentation

Pin the repo after a completed lab is documented. Keep unexecuted labs labeled pending.
For each result add: what failed, your diagnostic steps, root cause, fix, verification,
and a sanitized screenshot or text log. Put approved evidence in `evidence/published/`.

Review every staged file for passwords, API keys, private keys, user data, real domain
names, account identifiers and sensitive logs. `.gitignore` helps but is not a secret scan.
Use fictional users only. The evidence template contains placeholders, not achievements.
