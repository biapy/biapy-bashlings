# Biapy Bashlings

[![linting](https://github.com/biapy/biapy-bashlings/actions/workflows/super-linter.yaml/badge.svg)](https://github.com/biapy/biapy-bashlings/actions/workflows/super-linter.yaml)
[![tests](https://github.com/biapy/biapy-bashlings/actions/workflows/ci.yaml/badge.svg)](https://github.com/biapy/biapy-bashlings/actions/workflows/ci.yaml)
[![coverage](https://codecov.io/gh/biapy/biapy-bashlings/branch/main/graph/badge.svg?token=4HLU62R4TB)](https://codecov.io/gh/biapy/biapy-bashlings)
[![CodeFactor](https://www.codefactor.io/repository/github/biapy/biapy-bashlings/badge)](https://www.codefactor.io/repository/github/biapy/biapy-bashlings)

A `bash` functions library.

Bashlings are `bash` functions to be sourced in `bash` scripts. These functions
are a hold-out from earlier times, and should be a last resort. Prefer using
tools provided by a real `bash` framework.

## Functions

<!-- brief start -->
- **[available-fd](./doc/available-fd.md)** : Find first unused file descriptor
  (fd) (for `bash` < 4.1 (e.g. macOS)).
- **[cecho](./doc/cecho.md)** : Colored Echo: output text in color.
- **[check-binary](./doc/check-binary.md)** : Check for the presence of a
  binary in $PATH.
- **[download](./doc/download.md)** : Download content from a URL and write it
  to `/dev/stdout`.
- **[in-list](./doc/in-list.md)** : Test if a value is in a list.
- **[is-array](./doc/is-array.md)** : Test if a variable is an array.
- **[is-url](./doc/is-url.md)** : Test if a string is a HTTP, HTTPS, FTP or
  FILE URL.
- **[join-array](./doc/join-array.md)** : Join an array contents with a string
  separator.
- **[process-options](./doc/process-options.md)** : Alternative getopt for
  functions.
- **[realpath-check](./doc/realpath-check.md)** : Resolve the real absolute
  path and check for its existence.
- **[realpath](./doc/realpath.md)** : Resolve the real absolute path.
- **[repeat-string](./doc/repeat-string.md)** : Repeat a string N times.
<!-- brief end -->

## Usage

Import Biapy Bashlings in the project:

```bash
git submodule add \
  'https://github.com/biapy/biapy-bashlings.git' \
  'lib/biapy-bashlings'
```

See [Cloning](#cloning) for including submodules when cloning a repository.

Make use of a Biapy Bashlings' function (e.g. `in-list`) in a script stored in
`src` folder:

```bash
source "${BASH_SOURCE[0]%/*}/../lib/biapy-bashlings/src/in-list.bash"

in-list "${value}" "${example_list[@]}" && echo "Found."
```

## Script skeleton

[skeleton.bash](./skeleton.bash) is a skeleton of `bash` script implementation.
It includes option processing, `--quiet` and `--verbose` implementation
examples, and basic error messages.

## Bash resources

- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/html_node/index.html):
  The reference for Bash syntax and functionalities.
- [Bash FAQ](https://mywiki.wooledge.org/BashFAQ/):
  Frequently Asked Questions about Bash. This is a very good reference full of
  examples and recommendations.
- [ShellCheck][shellcheck]:
  ShellCheck is a shell script analysis tool. It provides recommendations on
  good coding practices and alert of shell scripts' pitfalls.
- [shfmt][shfmt]:
  `shfmt` is a code formatter for shell scripts.
- [Bash-it](https://github.com/Bash-it/bash-it):
  Bash-it is a [Oh My Zsh](https://ohmyz.sh/) inspired collection of Bash
  commands and scripts for Bash 3.2+.

Package managers for publishing bash scripts:

- [bpkg](https://bpkg.sh/).
- [basher](https://www.basher.it/).
- [Homebrew](https://brew.sh/).

Other interesting resources:

- [Shell Script Best Practices](https://sharats.me/posts/shell-script-best-practices/).
- [Expanding Bash arrays safely with `set -u`](https://gist.github.com/dimo414/2fb052d230654cc0c25e9e41a9651ebe).
- [Writing a TUI in BASH @ GitHub](https://github.com/dylanaraps/writing-a-tui-in-bash).

## Third party libraries

Biapy Bashlings uses:

- [shdoc](https://github.com/reconquest/shdoc) for generating markdown
  documentation from code.
- [ShellCheck][shellcheck] for checking code
  quality.
- [shfmt][shfmt] for formatting scripts and bats unit
  tests.
- [Bats-core: Bash Automated Testing System][bats-core]
  for unit testing, with its helper libraries:
  - [bats-support](https://github.com/bats-core/bats-support).
  - [bats-assert](https://github.com/bats-core/bats-assert).
  - [bats-file](https://github.com/bats-core/bats-file).

Biapy Bashlings uses these GitHub actions for Continuous Integration:

- [Super-Linter](https://github.com/github/super-linter) for lint checks.
- [Setup BATS testing framework](https://github.com/marketplace/actions/setup-bats-testing-framework)
  unit-tests, with its helper action:
  - [Setup Bats libs](https://github.com/marketplace/actions/setup-bats-libs).

## Contributing

### Git

#### Cloning

This library uses the [bats][bats-core] library for unit-testing.

Clone the repository with the additional libraries:

```bash
git clone --recurse-submodules 'git@github.com:biapy/biapy-downloader'
```

#### Updating submodules

Update the submodules with:

```bash
git submodule update --remote
```

[bats-core]: https://github.com/bats-core/bats-core
[shellcheck]: https://github.com/koalaman/shellcheck
[shfmt]: https://github.com/mvdan/sh

#### Utilities

The `Makefile` provides these rules:

- **help** : Display a short help message about the rules available in the
  `Makefile`.
- **clean** : Delete generated documentation in `doc/` and remove functions
  list from `README.md`.
- **format** : format files using `shfmt` on `*.bash` files in `src/` and
  `*.bats` files in `test/`.
- **check** : check files for errors using `shellcheck` on `*.bash` files
  in `src/`.
- **test** : run unit tests.
- **doc** : Generate documentation in `doc/` using `shdoc`.
- **readme** : Update function list in `README.md`.
- **all** : All of the above.

## Thanks

- [Un modèle pour démarrer un script shell @ Deblan Blog (fr)](https://www.deblan.io/post/647/modele-pour-demarrer-script-shell).
