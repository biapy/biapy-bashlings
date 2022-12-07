# src/is-url.bash

Test if a string is a HTTP, HTTPS, FTP or FILE URL.

## Overview

`is-url` tests if given string match with a URL validation regex restricted
to web protocols (i.e. HTTP, HTTPS, FTP and FILE).

## Index

* [is-url](#is-url)

### is-url

Test if given string match with a URL validation regex restricted
to web protocols (i.e. HTTP, HTTPS and FTP).

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/is-url.bash"
if is-url "${url}"; then
  wget "${url}"
else
  echo "Error: '${url}' is not a valid url." >&2
  exit 1
fi
```

#### Arguments

* **$1** (string): A string that may be a valid URL.

#### Exit codes

* **0**: If string is a valid HTTPS, HTTP, FTP or FILE URL.
* **1**: If argument is missing or more than one argument given.
* **1**: If string is not a URL or URL with an invalid protocol.

#### Output on stderr

* Error if the argument is missing or more than one argument is given.

#### See also

* [cecho](./cecho.md#cecho)
* [Check for valid link (URL) @ Stack Overflow](https://stackoverflow.com/questions/3183444/check-for-valid-link-url)

