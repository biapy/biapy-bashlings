# Biapy Bashlings

A `bash` functions library.

Bashlings are `bash` functions to be sourced in `bash` scripts. These functions
are a hold-out from earlier times, and should be a last resort. Prefer using
tools provided by a real `bash` framework.

# Usage

Import Biapy Bashlings in the project:

```bash
git submodule add 'https://github.com/biapy/biapy-bashlings.git' 'libs/biapy-bashlings'
```

See [Cloning](#cloning) for including submodules when cloning a repository.

Make use of a Biapy Bashling function (e.g. `in-list`):

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/in-list.bash"

in-list "${value}" "${example_list[@]}" && echo "Found."
```

## Third party libraries

Biapy Bashling makes use of:

- **[bs: Bash build system](https://github.com/labaneilers/bs)** for managing build
  actions.
- **[shdoc](https://github.com/reconquest/shdoc)** for generating markdown
  documentation from code.
- **[Bats-core: Bash Automated Testing System](https://github.com/bats-core/bats-core)**
  and its helper libraries
  [bats-support](https://github.com/bats-core/bats-support)
  and [bats-assert](https://github.com/bats-core/bats-assert)
  for unit testing.

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