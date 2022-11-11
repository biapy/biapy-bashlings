# Biapy Bashlings

A `bash` functions library.

Bashlings are `bash` functions to be sourced in `bash` scripts. These functions
are a hold-out from earlier times, and should be a last resort. Prefer using
tools provided by a real `bash` framework.

## Functions

<!-- brief start -->
- **[basename](./doc/basename.md)** : Strip directory from filenames.
- **[cecho](./doc/cecho.md)** : Colored Echo: output text in color.
- **[check-binary](./doc/check-binary.md)** : Check for the presence of a binary in $PATH.
- **[check_binary](./doc/check_binary.md)** : Legacy alias for `check-binary` function.
- **[download](./doc/download.md)** : Download content from a URL and write it to `/dev/stdout`.
- **[in-list](./doc/in-list.md)** : Test if a value is in a list.
- **[is-array](./doc/is-array.md)** : Test if a variable is an array.
- **[is-url](./doc/is-url.md)** : Test if a string is a HTTP, HTTPS, FTP or FILE URL.
- **[isUrl](./doc/isUrl.md)** : Legacy alias for `is-url` function.
- **[process-options](./doc/process-options.md)** : Alternative getopt for functions.
- **[processOptions](./doc/processOptions.md)** : Legacy alias for `process-options` function.
- **[realpath-check](./doc/realpath-check.md)** : Resolve the real absolute path and check its existance.
- **[realpath](./doc/realpath.md)** : Resolve the real absolute path.
- **[realpath_check](./doc/realpath_check.md)** : Legacy alias for `realpath-check` function.
<!-- brief end -->

## Usage

Import Biapy Bashlings in the project:

```bash
git submodule add \
  'https://github.com/biapy/biapy-bashlings.git' \
  'src/vendor/biapy-bashlings'
```

See [Cloning](#cloning) for including submodules when cloning a repository.

Make use of a Biapy Bashling function (e.g. `in-list`) in a script stored in
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
- [ShellCheck][shellcheck]:
  ShellCheck is a shell script analysis tool. It provides recommendations on
  good coding practices and alert of shell scripts' pitfalls.
- [shfmt][shfmt]:
  `shfmt` is a code formatter for shell scripts.

## Third party libraries

Biapy Bashling makes use of:

- **[shdoc](https://github.com/reconquest/shdoc)** for generating markdown
  documentation from code.
- [ShellCheck][shellcheck] for checking code
  quality.
- [shfmt][shfmt] for formating scripts and bats unit
  tests.
- **[Bats-core: Bash Automated Testing System][bats-core]**
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
[shellcheck]: https://github.com/koalaman/shellcheck
[shfmt]: https://github.com/mvdan/sh
