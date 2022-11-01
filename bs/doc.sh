#!/bin/sh

# Build documentation using shdoc.

find ./src/ -name "*.bash" | \
  while read -r 'file'; do
    filename="$( echo "${file}" \
      | sed -e 's|^./src/||' \
        -e 's/\.[^\.]*sh$//' )"
    doc="./doc/${filename}.md"
    mkdir --parent "$( dirname "${doc}" )"
    echo "Building documentation for ${file} in ${doc}"
    ./libs/shdoc/shdoc < "${file}" > "${doc}"
  done
