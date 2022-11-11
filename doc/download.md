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

#### Options

* **-q** | **--quiet**

  Reduce output to stderr to the bare minimum.

* **-v** | **--verbose**

  Enable verbose mode.

* **-w** | **--wget**

  Force using `wget`.

* **-c** | **--curl**

  Force using `curl`.

* **--url=\<url\>**

  Set the URL to fetch (alternative to setting **$1**).

* **--output-path=\<path\>**

  Set where to store the downloaded contents (default to `/dev/stdout`)

* **--user-agent=\<user-agent\>**

  Allow to set a custom user-agent.

#### Arguments

* **$1** (string): The URL to fetch (alternative to using **--url=<url>**)

#### Exit codes

* **0**: If the download is successful.
* **1**: If no URL is provided.
* **1**: If too many arguments provided.
* **1**: If both argument and --url provided.
* **1**: If the download failed.

#### Output on stdout

* The first found binary absolute path, as outputed by `command -v`.

#### Output on stderr

* Verbose mode messages, when enabled.
* Error if no URL is provided.
* Error if too many arguments provided.
* Error if both argument and --url provided.
* Error if the download failed.

#### See also

* [cecho](./cecho.md#cecho)
* [basename](./basename.md#basename)
* [check-binary](./check-binary.md#check-binary)
* [process-options](./process-options.md#process-options)

