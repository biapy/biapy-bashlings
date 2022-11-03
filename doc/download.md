# src/download.bash

Download content from a URL and write it to `/dev/stdout`.

## Overview

`download` use `curl` or `wget` to download a URL contents and write
these data to `/dev/stdout` or to the specified file path.

## Index

* [download](#download)

### download

Download content from a URL and write it to `/dev/stdout`.
`download` use `curl` or `wget` to download a URL contents and write
these data to `/dev/stdout` or to the specified file path.

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/download.bash"
download --url=https://www.monip.org/
```

#### Arguments

* -q | --quiet Reduce output to stderr to the bare minimum.
* -v | --verbose Enable verbose mode.
* --url=<url> (required) Set the URL to fetch.
* --output-path=<path> Set where to store the downloaded contents (default to `/dev/stdout`)
* --user-agent=<user-agent> Allow to set a custom user-agent.

#### Exit codes

* **0**: If the download is successful.
* **1**: If no URL is provided.
* **1**: If the download failed.

#### Output on stdout

* The first found binary absolute path, as outputed by `command -v`.

#### See also

* [cecho](#cecho)
* [basename](#basename)
* [check-binary](#check-binary)
* [process-options](#process-options)

