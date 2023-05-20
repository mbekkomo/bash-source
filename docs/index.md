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

* [SOURCE_PATH](#source_path)
* [SOURCE_SEARCHERS](#source_searchers)
* [source](#source)
* [.](#)

### SOURCE_PATH

An array containing path search of `source`.
```bash
declare -a SOURCE_PATH=("." "$HOME/.local/share/bash")
```

### SOURCE_SEARCHERS
 An array containing searcher functions of `source`.
 ```bash
 declare -a SOURCE_SEARCHERS=()
 ```

### source

A patched `source` function. In package search, `$1` append to list paths in `SOURCE_PATH` with suffix `.sh` or `.bash`. In script search, `$1` append to list paths in `SOURCE_PATH`.

#### Arguments

* **$1** (Package): or script name.
* **...** (Arguments): passed to package/script.

### .

Alias of `source`.

#### Arguments

* **$1** (Package): or script name.
* **...** (Arguments): passed to package/script.

