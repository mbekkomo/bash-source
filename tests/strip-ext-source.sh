#!/usr/bin/env bash

source script/mod

# main #
{
    declare -rp MOD_VARIABLE
    declare -fp mod_hello

    [[ "$(mod_hello "World!")" != "Hello World!" ]]
}

true
