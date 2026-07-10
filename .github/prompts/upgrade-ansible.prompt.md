---
description: "Upgrade the ansible-core upper-bound constraint in ansible-runner. Updates pyproject.toml, regenerates the lock file, rebuilds the image, and verifies the new version."
name: "Upgrade Ansible"
argument-hint: "new upper bound (e.g. 2.22 — the constraint will become <2.22)"
agent: "agent"
---

Upgrade the `ansible-core` upper-bound constraint in the ansible-runner image to `<$ARGUMENTS`.

## Steps

1. In [pyproject.toml](../../pyproject.toml), update the `ansible-core` version constraint under `[tool.poetry.dependencies]`:
   ```toml
   ansible-core = "<$ARGUMENTS"
   ```

2. Run `poetry lock` to resolve and regenerate [poetry.lock](../../poetry.lock):
   ```sh
   poetry lock
   ```

3. Build the Docker image to verify the new `ansible-core` version installs and all collections remain compatible:
   ```sh
   docker build -t ansible-runner-test .
   ```

4. Confirm the installed Ansible version inside the image:
   ```sh
   docker run --rm ansible-runner-test ansible --version
   ```

5. Confirm all collections still load without errors:
   ```sh
   docker run --rm ansible-runner-test ansible-galaxy collection list
   ```

6. If any step fails (build error, collection conflict, import error), stop and report the failure with the full error output. Do not proceed.

## After Verification

Print this checklist:

```
## Checklist for ansible-core <$ARGUMENTS

- [ ] Review the diff: `git diff pyproject.toml poetry.lock`
- [ ] Confirm ansible --version output matches expectations
- [ ] Commit: `git commit -am "chore: upgrade ansible-core to <$ARGUMENTS"`
- [ ] Push, then bump the version with /bump-version and create a GitHub Release to publish the image
```

> The current constraint is `<2.21`. Do not set the upper bound lower than the currently resolved version — check `poetry.lock` for the installed version before committing.
