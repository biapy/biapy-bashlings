# Biapy Bashlings

A `bash` functions library.

Bashlings are `bash` functions to be sourced in `bash` scripts. These functions
are a hold-out from earlier times, and should be a last resort. Prefer using
tools provided by a real `bash` framework.

# Usage

Import Biapy Bashlings in the project:

```bash
git submodule add \
  'https://github.com/biapy/biapy-bashlings.git' \
  'src/vendor/biapy-bashlings'
```

See [Cloning](#cloning) for including submodules when cloning a repository.

Make use of a Biapy Bashling function (e.g. `in-list`) in a file in
`src` folder:

```bash
source "${BASH_SOURCE[0]%/*}/vendor/biapy-bashlings/src/in-list.bash"

in-list "${value}" "${example_list[@]}" && echo "Found."
```

## Bash resources

- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/html_node/index.html):
  The reference for Bash syntax and functionalities.
- [Bash FAQ](https://mywiki.wooledge.org/BashFAQ/):
  Frequently Asked Questions about Bash. This is a very good reference full of
  examples and recommendations.
- [argp.sh](https://sourceforge.net/projects/argpsh/):
  Complex argument processor supporting long options
  (see [BashFAQ/035](https://mywiki.wooledge.org/BashFAQ/035)).
- [ShellCheck](https://github.com/koalaman/shellcheck):
  ShellCheck is a shell script analysis tool. It provides recommendations on
  good coding practices and alert of shell scripts' pitfalls.
- [shfmt](https://github.com/mvdan/sh):
  `shfmt` is a code formatter for shell scripts.

## Third party libraries

Biapy Bashling makes use of:

- **[shdoc](https://github.com/reconquest/shdoc)** for generating markdown
  documentation from code.
- **[Bats-core: Bash Automated Testing System](https://github.com/bats-core/bats-core)**
  for unit testing, with its helper libraries:
  - [bats-support](https://github.com/bats-core/bats-support).
  - [bats-assert](https://github.com/bats-core/bats-assert).
  - [bats-file](https://github.com/bats-core/bats-file).

## Contributing

### Git

#### Cloning

This library uses the [bats][bats-core] library for unit-testing.

Clone the repository with the additionnal libraries:

```bash
git clone --recurse-submodules 'git@github.com:biapy/biapy-downloader'
```

#### Updating submodules

Update the submodules with:

```bash
git submodule update --remote
```

[bats-core]: https://github.com/bats-core/bats-core