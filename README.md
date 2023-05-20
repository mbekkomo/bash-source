# bash-source
This code aims to improve Bash's `source` into more modular system.

## Why?
Bash's module system is so limited yet confusing, so I made this to cover Bash's module system problems by adding features that is already available in modern languages' module system.

How to use it?, it's very simple. Imagine that you have a `module.sh` in other directory, but you don't want to hardcode and type long path just to source it. This script helps you with that.

```bash
# /path/to/dir/module.sh

mod() {
    echo "Hello world!"
}

MOD="Hi Mom!"
```
```bash
# /path/to/main.sh

source source.sh # patch `source` and `.`

# SOURCE_PATH is an array containing paths where script/package
# will be find
SOURCE_PATH+=("/path/to/dir/%s")

source module.sh # loaded!

mod
echo "$MOD"
```
```bash
# output
Hello World!
Hi Mom!
```

## Features
  - Custom path search and path searcher.
  - Compatible with built-in `source`.
  - Easy-to-setup inside new projects or already projects.

## Installation
Drop [source.sh](/source.sh) into your project and source it.
```bash
source source.sh
```

You can also patch to it to all Bash script by setting up `BASH_ENV` environment variable into the path where [source.sh](/source.sh) is placed, no need to source it again.
```bash
export BASH_ENV="/path/to/source.sh"
```

To verify if it's working, put `source` into your script. The output should be like this.
```
source: error: script name is required
```

## License

bash-source is licensed under MIT license, see [LICENSE](/LICENSE) for more details.
