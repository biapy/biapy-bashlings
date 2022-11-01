#!/bin/sh

# Run unit tests using bats.
./test/bats/bin/bats './test/internals'
./test/bats/bin/bats './test'
