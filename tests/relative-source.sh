#!/usr/bin/env bash

# shellcheck disable=SC1091 # it is valid
source script/mod/mod.sh

# main #
{
    declare -rp MOD1_VARIABLE
    # shellcheck disable=SC2153 # it is assigned
    declare -rp MOD2_VARIABLE
    declare -fp mod2_say

    [[ "$(mod2_say "Bash" "Hello!")" = "Bash says Hello!" ]]
}

true
