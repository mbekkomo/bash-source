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
declare -r SOURCE_VERSION="0.3.0"
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

A patched `source` function. In package search, `$1` append to list paths in `SOURCE_PATH` with suffix `.sh` or `.bash`. In script search, `$1` append to list paths in `SOURCE_PATH`.

#### Arguments

* **$1** (script): Script name.
* **...** (args): Arguments passed to script.

### .

Alias for `source`.

#### Arguments

* **$1** (script): Script name.
* **...** (args): Arguments passed to script.

#### See also

* [source](#source)

