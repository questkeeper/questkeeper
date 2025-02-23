#!/bin/bash

# Public: Logs a message at a specified level.
#
# $1 - target log level, one of [info,warn,warning,error]
# $2 - message to print
function log() {
  local level="$1"
  local level_color=""
  local message="$2"

  case "$level" in
    "info")
      level_color="36"
      ;;

    "warn" | "warning")
      level_color="33"
      ;;

    "error")
      level_color="31"
      ;;

    *)
      warn "unknown log level: $level"
      ;;
  esac

  printf "\x1b[30m%s \x1b[%sm%s: \x1b[0m%s\n" "$(date +%T)" "${level_color}" "$level" "$message"
}

# Public: Logs an info message.
#
# $1 - message to print
function info() {
  log info "$1"
}

# Public: Logs a warning message.
#
# $1 - message to print
function warn() {
  log warn "$1"
}

# Public: Logs an error message.
#
# $1 - message to print
function error() {
  log error "$1"
}

# Public: Logs an error message and exits with the specified code.
#
# $1 - message to print
# $2 - exit code (defaults to 1)
function abort() {
  local message="$1"
  local code="$2"

  log error "$message"
  exit "${code:-1}"
}