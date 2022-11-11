# Biapy Bashlings Makefile

SHELL = /bin/sh

.SUFFIXES: .bash .md .bats

# grep the version from the mix file
VERSION=$(shell git tag --list | tail --lines=1)

# Define pathes.
SOURCE_PATH := ./src
DOC_PATH := ./doc
TEST_PATH := ./test
README_PATH := ./README.md

# Define README brief keywords
BRIEF_START := <!-- brief start -->
BRIEF_END := <!-- brief end -->

# Define utilities pathes.
SHDOC := ./libs/shdoc/shdoc
BATS := ./test/bats/bin/bats
RM := rm -f
SHELLCHECK := shellcheck \
	--check-sourced \
	--external-sources \
	--shell=bash
SHFMT := shfmt -w -d

# Find *.bash files.
BASH_SCRIPTS := $(shell find $(SOURCE_PATH) -name "*.bash")
PUBLIC_BASH_SCRIPTS := $(sort $(shell find $(SOURCE_PATH) -maxdepth 1 -name "*.bash"))

# Detect sources structure based on found bash scripts.
SOURCE_STRUCTURE := $(sort $(dir $(BASH_SCRIPTS)))

# Generate *.bats files path (wildcard check the files existance).
BATS_FILES := $(wildcard $(patsubst $(SOURCE_PATH)/%,$(TEST_PATH)/%,$(BASH_SCRIPTS:%.bash=%.bats)))

# Generates *.md documentation files path
MD_FILES := $(patsubst $(SOURCE_PATH)/%,$(DOC_PATH)/%,$(BASH_SCRIPTS:%.bash=%.md))

.PHONY: help all \
	brief  \
	shellcheck \
	shfmt-test shfmt-src \
	test \
	readme-clean doc-clean 

###
# Internal rules.
###

$(DOC_PATH)/%.md: $(SOURCE_PATH)/%.bash # Documentation generation rule.
	@mkdir -p $(@D)
	@$(SHDOC) $< > $@

doc-clean: # Remove all generated documentation files.
	@$(RM) $(MD_FILES)
	@echo "Removed generated documentation."

shellcheck: # Run shellcheck on all sources.
	@$(SHELLCHECK) $(SOURCE_STRUCTURE:%=--source-path=%) \
		$(BASH_SCRIPTS)

shfmt-test: # Format bats files in test path.
	@$(SHFMT) $(BATS_FILES)

shfmt-src: # Format bash scripts in source path.
	@$(SHFMT) $(BASH_SCRIPTS)

shfmt: shfmt-test shfmt-src # Format files using shfmt.

readme-clean: # Remove README.md functions list.
	@sed --in-place --expression='/$(BRIEF_START)/,/$(BRIEF_END)/{//!d}' $(README_PATH)

brief: # Insert brief rule result in README.md file between brief start and brief end.
	@grep '@brief' $(PUBLIC_BASH_SCRIPTS) | \
		awk 'match($$0, "^$(SOURCE_PATH)/(.*)\\.bash:#[[:blank:]]*@brief[[:blank:]]*(.*)[[:blank:]]*$$", contents) { \
				printf "- **[%s]($(DOC_PATH)/%s.md)** : %s\n", contents[1], contents[1], contents[2] \
			}' | \
		sed --in-place --expression='/$(BRIEF_START)/,/$(BRIEF_END)/{//!d};/$(BRIEF_START)/r /dev/stdin' $(README_PATH)

###
# Front-end rules.
###

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Display this message.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' "$(MAKEFILE_LIST)" \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: clean format check test doc readme ## Run tests and generate documentation.

check: shellcheck ## Run shellcheck on sources.

format: shfmt ## Format files with shfmt.

test: check ## Run unit-tests using bats.
	@$(BATS) $(BATS_FILES)

doc: $(MD_FILES) ## Generate documentation from sources using shdoc.

readme: brief ## Update README functions list.

clean: doc-clean readme-clean ## Remove all generated files (documentation)
