# src/cecho.bash

Colored Echo: output text in color.

## Overview

`cecho` in a wrapper around `tput` and `echo` for outputing colored text.

## Index

* [cecho](#cecho)

### cecho

`cecho` in a wrapper around `tput` and `echo` for outputing colored text.

`cecho` support one of these text color modifiers:

- 'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white'

`cecho` support one of these background color modifiers:

- 'bgBlack', 'bgRed', 'bgGreen', 'bgYellow', 'bgBlue', 'bgMagenta', 'bgCyan', 'bgWhite'

`cecho` support one or more of these styles modifiers:

- 'bold', 'stout', 'under', 'blink', 'reverse', 'italic'

`cecho` provides theses custom styles:

- 'INFO', 'WARNING', 'ERROR', 'SUCCESS', 'DEBUG'

#### Example

```bash
source "${BASH_SOURCE[0]%/*}/libs/biapy-bashlings/src/cecho.bash"
cecho "red bold reverse" "A reversed red bold text"
cecho "INFO" "Info: there is news !"
cecho "ERROR" "Error: the news is false !"
cecho "DEBUG" "Debug: \$news is set by a waring party."
```

#### Arguments

* -f | --force Force colored output to pipe. Allow to print colored output in files.
* **$1** (string): (optional) The output color style ( color + background color + styles).
* **...** (string): The outputed contents.

#### Exit codes

* **0**: If the text is outputted successfully.
* **1**: If $1 contains an unsupported color code.

#### See also

* [http://mywiki.wooledge.org/BashFAQ/037](#httpmywikiwooledgeorgbashfaq037)
