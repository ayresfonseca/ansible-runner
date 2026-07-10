---
description: "Add an Ansible collection to the ansible-runner image. Updates collections/requirements.yml and verifies the Docker build succeeds."
name: "Add Ansible Collection"
argument-hint: "collection name (e.g. community.network or community.network:==5.0.0)"
agent: "agent"
---

Add the Ansible collection `$ARGUMENTS` to the ansible-runner image.

## Steps

1. In [collections/requirements.yml](../../collections/requirements.yml), append the collection under the `collections:` key.
   - If `$ARGUMENTS` contains a version pin (e.g. `community.network:==5.0.0`), use the expanded object form:
     ```yaml
     - name: community.network
       version: "==5.0.0"
     ```
   - Otherwise, use the short name form (e.g. `- community.network`), consistent with the existing entries.

2. Build the Docker image locally to verify the collection installs correctly:
   ```sh
   docker build -t ansible-runner-test .
   ```

3. Confirm the collection is available in the built image:
   ```sh
   docker run --rm ansible-runner-test ansible-galaxy collection list
   ```

4. If the build or collection list fails, report the error and do not proceed.

## After Verification

Print this commit checklist:

```
## Checklist for adding $ARGUMENTS

- [ ] Review the diff: `git diff collections/requirements.yml`
- [ ] Commit: `git commit -am "feat: add $ARGUMENTS collection"`
- [ ] Push and open a PR, or bump the version with /bump-version if releasing immediately
```
