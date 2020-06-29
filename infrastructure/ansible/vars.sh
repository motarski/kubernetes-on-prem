#!/bin/bash

# Define colors
readonly RESET="\033[0m"
readonly YELLOW="\033[1;33m"
readonly BLUE="\033[1;34m"
readonly WHITE="\033[1;37m"
readonly RED="\033[1;31m"
readonly GREEN="\033[1;32m"

# Value is pulled from master vars.yaml
readonly FQDN=$(cat ansible/vars.yaml | grep FQDN: | awk '{print $2}' | sed -e 's/"//g')
