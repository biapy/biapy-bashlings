# Biapy Bashlings Makefile

SHELL = /bin/sh

.SUFFIXES: .bash .md .bats

# grep the version from the mix file
VERSION=$(shell git tag --list | tail --lines=1)

# Define pathes.
SOURCE_PATH := src
DOC_PATH := doc
TEST_PATH := test/

# Define utilities pathes.
SHDOC := ./libs/shdoc/shdoc
BATS := ./test/bats/bin/bats
RM := rm -f

# Find *.bash files.
BASH_SCRIPTS := $(shell find $(SOURCE_PATH) -name "*.bash")

# Find *.bats files
BATS_FILES := $(wildcard $(patsubst $(SOURCE_PATH)/%,$(TEST_PATH)/%,$(BASH_SCRIPTS:%.bash=%.bats)))

# Generates *.md documentation files path
MD_FILES := $(patsubst $(SOURCE_PATH)/%,$(DOC_PATH)/%,$(BASH_SCRIPTS:%.bash=%.md))

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help all test doc-clean doc-structure

help: ## Display this message.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' "$(MAKEFILE_LIST)" \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: test doc ## Run tests and generate documentation.

test: ## Run unit-tests using bats.
	$(BATS) $(BATS_FILES)

$(DOC_PATH)/%.md: $(SOURCE_PATH)/%.bash # Documentation generation rule.
	@mkdir -p $(@D)
	@$(SHDOC) $< > $@

doc: $(MD_FILES) ## Generate documentation from sources using shdoc.

doc-clean: # Remove all generated documentation files.
	@echo "Removed generated documentation."
	@$(RM) $(MD_FILES)

clean: doc-clean ## Remove all generated files (documentation)
