---
name: Bug report
about: Create a report to help us improve
title: ''
labels:
  - triage
  - bug
assignees:
  - landure
---

### Description

**Describe the issue:**
A clear and concise description of what the bug is.

### How to reproduce

**To Reproduce:**
Minimal code reproducing the unwanted behavior:

```bash
source "${BASH_SOURCE[0]%/*}/vendor/biapy-bashlings/src/in-list.bash"

example_list=("needle" "in" "haystack")
value="needle"

in-list "${value}" "${example_list[@]}" && echo "Found."
```

### Expected behavior

**Describe the expected behavior:**
A clear and concise description of what you expected to happen.

### Environment

Bash version:

```bash
bash --version
```

OS: (e.g. Linux, FreeBSD, MacOS)

For GNU/Linux, provide Linux Standard Base release information:

```bash
lsb_release --all
```

### Additional context

Add any other context about the problem here.
