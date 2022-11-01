#!/bin/sh

# Build documentation using shdoc.

find ./src/ -name "*.bash" | \
  while read -r 'file'; do
    filename="$( basename "${file}" | sed -e 's/\.[^\.]*sh$//' )"
    doc="./doc/${filename}.md"
    echo "Building documentation for ${file} in ${doc}"
    ./libs/shdoc/shdoc < "${file}" > "${doc}"
  done
