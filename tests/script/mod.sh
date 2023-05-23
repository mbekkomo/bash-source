#!/usr/bin/env bash

mod_hello() {
    printf "Hello %s\n" "$1"
}

export -f mod_hello
export MOD_VARIABLE="a mod variable"
