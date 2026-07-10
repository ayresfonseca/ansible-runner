---
description: "Bump the ansible-runner image version, update the lock file, and draft a GitHub Release checklist."
name: "Bump Version"
argument-hint: "new version (e.g. 0.3.0)"
agent: "agent"
---

Bump the ansible-runner version to `$ARGUMENTS`.

## Steps

1. In [pyproject.toml](../../pyproject.toml), update the `version` field under `[tool.poetry]` to `$ARGUMENTS`.
2. Run `poetry lock` in the terminal to regenerate [poetry.lock](../../poetry.lock).
3. Verify the lock file was updated (check the `name = "ansible-runner"` entry if present, or simply confirm the command succeeded).

## Release Checklist

After completing the steps above, print this checklist for the user to complete manually:

```
## Release checklist for v$ARGUMENTS

- [ ] Review the diff: `git diff pyproject.toml poetry.lock`
- [ ] Commit: `git commit -am "chore: bump version to $ARGUMENTS"`
- [ ] Push: `git push`
- [ ] Create a GitHub Release tagged `v$ARGUMENTS` — this triggers the image build and push to ghcr.io/ayresfonseca/ansible-runner:$ARGUMENTS
- [ ] Confirm the Actions workflow completes successfully
- [ ] Verify the image is available: `docker pull ghcr.io/ayresfonseca/ansible-runner:$ARGUMENTS`
```

> Publishing is triggered automatically by a GitHub Release. Do not push images manually.
