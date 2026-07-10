---
description: "Prepare a new release: bump version in pyproject.toml, regenerate the lock file, lint the workflow YAML, and draft a GitHub Release summary."
name: "Prepare Release"
argument-hint: "new version (e.g. 0.3.0)"
agent: "agent"
---

Prepare a release for the **ansible-runner** project. The new version is: **${{input}}**.

## Steps

### 1. Bump version
Update the `version` field in [pyproject.toml](../../pyproject.toml) to `${{input}}`, then run:

```sh
poetry lock
```

### 2. Lint the workflow YAML
Run the following and report any errors. Fix issues before proceeding.

```sh
poetry run yamllint .github/workflows/publishing-image.yml
```

### 3. Draft a GitHub Release summary
Review the git log since the last tag. Group commits by their Conventional Commits prefix (`feat`, `fix`, `chore`, `refactor`, `docs`, `ci`, `build`, `perf`). Produce a concise release summary in this format:

```
## What's Changed

### ✨ Features (`feat`)
- <bullet per feat commit>

### 🐛 Bug Fixes (`fix`)
- <bullet per fix commit>

### 🔧 Chores & Maintenance (`chore`, `build`, `ci`, `refactor`, `docs`, `perf`)
- <bullet per remaining commit>

**Full Changelog**: https://github.com/ayresfonseca/ansible-runner/compare/<previous-tag>...v${{input}}
```

- Omit any section that has no commits.
- Strip the `type(scope):` prefix from bullet text; keep it readable.
- If a commit message does not follow Conventional Commits, place it under Chores.

## Reminder
- After this prompt completes, create a GitHub Release tagged `v${{input}}` — the [publishing-image workflow](../../.github/workflows/publishing-image.yml) triggers on `release: published` and will build and push `ghcr.io/ayresfonseca/ansible-runner:${{input}}` automatically.
- Do **not** edit `poetry.lock` manually — Poetry manages it.
