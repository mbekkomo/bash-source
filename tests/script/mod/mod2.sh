#!/usr/bin/env bash

MOD2_VARIABLE="a mod 2 variable"

mod2_say() {
    local name="$1"; shift
    printf "%s says %s\n" "$name" "$*"
}

export MOD2_VARIABLE
export -f mod2_say
