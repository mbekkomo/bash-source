# bash-source

Improve Bash's `source` into more modular system.

## Overview

bash-source is a simple script that patches `source` into a more `import`-like function.

In a few words, patched `source` let you use it as how `import` function in modern languages.
```bash
#!/usr/bin/env bash

source source.sh
source Module

mod #=> Hello World!
```

Learn more about it [on Github](https://github.com/UrNightmaree/bash-source)

## Index

* [SOURCE_VERSION](#source_version)
* [SOURCE_PATH](#source_path)
* [SOURCE_SEARCHERS](#source_searchers)
* [source](#source)
* [.](#)

### SOURCE_VERSION
Version of bash-source.
```bash
declare -r SOURCE_VERSION="0.4.0"
```

### SOURCE_PATH
An array containing search path of `source`.
```bash
declare -a SOURCE_PATH=(
    "$HOME/.local/share/bash/%s"
    "$HOME/.local/share/bash/%s.sh" "$HOME/.local/share/bash/%s.bash"
    "./%s"
    "./%s.sh" "./%s.bash"
)
```

### SOURCE_SEARCHERS
An array containing searcher functions of `source`.
```bash
declare -a SOURCE_SEARCHERS=()
```

### source

A patched `source` function. If provided `script` start searching scripts in `SOURCE_PATH` or manually search it. If `args` provided pass `$2..$#` to `script`.

#### Arguments

* **$1** (script): Script name.
* **...** (args): Arguments passed to script.

#### Options
* **-r, --no-relative**: Disable relative search path when a sourced script tries to source another script using relative path.

### .

Alias for `source`.

#### Arguments

* **$1** (script): Script name.
* **...** (args): Arguments passed to script.

#### See also

* [source](#source)

