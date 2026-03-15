# Git Cheatsheet

## See What's Going On

```bash
git status          # full status — modified, new, and staged files
git status -s       # compact one-line-per-file version
git ls-files        # list all tracked files
git diff --staged   # show exactly what will go into the next commit
```

## Staging Files

```bash
git add .               # stage everything — modified AND new untracked files
git add -A              # same as git add .
git add -u              # stage only modified/deleted tracked files; ignores new files
git add <file>          # stage a specific file
git add -p              # interactively review and pick changes to stage
```

## Committing

```bash
git commit -m "message"         # commit what is staged
git commit -a -m "message"      # stage all modified tracked files and commit
                                # note: does NOT pick up new untracked files
```

## Pushing

```bash
git push                # push commits to remote
```

## Rolling Back
```bash
git reset --hard HEAD   # throw out all changes
git pull
```

## Checking and Fixing .gitignore

```bash
git check-ignore -v <file>      # test whether a file is ignored, and why
git rm --cached <file>          # stop tracking a file without deleting it
git rm --cached -r <folder>     # stop tracking a whole folder
```

---

## Notes

- **`git add -A` vs `git add -u`** — use `-u` if you have new scratch files you
  don't want staged; use `-A` (or `.`) when you want everything including new files.

- **Staging is a required step** — `git commit` only commits what has been staged.
  If `git status -s` still shows modified files after a commit, you forgot to
  `git add` first.

- **`.gitignore`** — commit this file to the repo so git behavior is consistent
  across all clones/devices. For entries whose filename is itself sensitive, use
  `.git/info/exclude` instead — it works the same way but is never committed or pushed.

- **Typical workflow:**
  ```bash
  git status                  # 1. see what changed
  git rm --cached <file>      # 2. untrack newly-ignored files if needed
  git add -u                  # 3. stage modified tracked files
  #   or
  git add -A                  # 3. stage everything including new files
  git diff --staged           # 4. sanity check before committing
  git commit -m "message"     # 5. commit
  git push                    # 6. push
  ```
## Cloning and Keeping Devices in Sync

### Clone the repo to a new device (do this once per device)
```bash
git clone https://github.com/LouisB-CA/dotfiles.git "$DOTFILES"
chown -R 1000:1000 "$DOTFILES"
```

### Sync workflow — on the device where you made changes
```bash
git add -u                  # or git add -A
git commit -m "message"
git push                    # sends changes up to GitHub
```

### Sync workflow — on every other device
```bash
git pull                    # pulls changes down from GitHub
```

### Check where your clone is pointing (the remote)
```bash
git remote -v               # shows the GitHub URL this clone pushes/pulls to
```

---

## Notes on Clones and Sync

- **GitHub is the hub.** No device talks directly to another — all sync goes
  through GitHub. Push from one device, pull on all the others.

- **The untracked sensitive file** lives on each device independently. It is
  never pushed, never pulled, never touched by git — as long as it is listed
  in `.gitignore` or `.git/info/exclude`.

- **`git pull` is safe** — it will never overwrite your untracked file because
  git doesn't know it exists.

- **Check for unpushed commits before pulling on another device:**
```bash
  git status      # should say "nothing to commit" before you switch devices
```
