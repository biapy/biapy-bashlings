## Index

* [process-long-option](#process-long-option)

### process-long-option

Try to process argument as a long option (starting by --).

#### Environment

- **$allowed_options** A list of allowed optins names
with * suffix if option argument is allowed and + suffix if option
argument is required.

#### Arguments

* **$1** (string): The argument to be processed.

#### Variables set

* **option** (any): 1 if --option as no value, "value" if --option=value is used.
* **...** (any): variables corresponding to accepted options.

#### Exit codes

* **0**: if the argument is a supported long option.
* **1**: if $1 is missing.
* **2**: if $1 is not a long option.
* **1**: if $1 is not an allowed option.
* **1**: if the option requires an argument and none is provided.
* **1**: if the option does not support arguments and one is provided.

#### See also

* [validate-option()](#validate-option)

