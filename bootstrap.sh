#!/bin/sh

HOST_OS=$(uname)

EXIT_SUCCESS() {
  exit 0
}

EXIT_FAILURE() {
  exit 1
}

deos_bin() {
  for path in .deos/bin/darwin .deos/bin/vagrant .deos/bin/travis
  do
    [ ! -f "$path/deos" ] && cp src/deos.py $path/deos
    [ -f "$path/deos" ] && chmod +x $path/deos
    [ ! -f "$path/logger" ] && cp src/logger.py $path/logger
    [ -f "$path/logger" ] && chmod +x $path/logger
    [ ! -f "$path/print" ] && cp src/print.py $path/print
    [ -f "$path/print" ] && chmod +x $path/print
    [ ! -f "$path/spinner" ] && cp src/spinner.sh $path/spinner
    [ -f "$path/spinner" ] && chmod +x $path/spinner
  done
}

deos_venv() {
  path=.deos/venv/$1
  bin=virtualenv
  venv=default
  flag=--no-site-packages
  [ ! -d "$path/$venv" ] && (cd $path && $bin $venv $flag)
}

deos_init() {
  for path in .deos .deos/bin .deos/obj .deos/venv\
              .deos/bin/darwin .deos/bin/vagrant .deos/bin/travis\
              .deos/obj/darwin .deos/obj/vagrant .deos/obj/travis\
              .deos/venv/darwin .deos/venv/vagrant .deos/venv/travis
  do
    [ ! -d "$path" ] && mkdir $path
  done
}

deos_clean() {
  [ -d ".deos" ] && rm -rf .deos
  [ -f "Makefile" ] && rm Makefile
}

deos_darwin() {
  deos_clean
  deos_init
  deos_venv "darwin"
  deos_bin
  .deos/bin/darwin/deos
  EXIT_SUCCESS
}

deos() {
  case "${HOST_OS:-nil}" in
    Darwin)
      deos_darwin
    ;;
    Linux)
      EXIT_FAILURE
    ;;
    *)
      EXIT_FAILURE
    ;;
  esac
}

main() {
  deos
}

main
