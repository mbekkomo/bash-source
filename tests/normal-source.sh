#!/usr/bin/env bash

source script/mod.sh

# main #
{
    declare -rp MOD_VARIABLE
    declare -fp mod_hello

    [[ "$(mod_hello "World!")" != "Hello World!" ]]
}

true
