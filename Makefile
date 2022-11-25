# Biapy Bashlings Makefile

SHELL = /bin/sh

.SUFFIXES: .bash .md .bats

# grep the version from the mix file
VERSION=$(shell git tag --list | tail --lines=1)

# Define pathes.
SOURCE_PATH := ./src
DOC_PATH := ./doc
TEST_PATH := ./test
COVERAGE_PATH := ./coverage
README_PATH := ./README.md

# Define README brief keywords
BRIEF_START := <!-- brief start -->
BRIEF_END := <!-- brief end -->

# Define utilities pathes.
SHDOC := ./libs/shdoc/shdoc
BATS := ./test/bats/bin/bats
RM := rm -f
SHELLCHECK_BASH := shellcheck \
	--check-sourced \
	--external-sources \
	--shell='bash'
SHELLCHECK_BATS := shellcheck \
	--external-sources \
	--shell='bats'
SHFMT := shfmt -w -d
BASHCOV := bundle exec bashcov --

# Run shellcheck on a .bash file.
define shellcheck_bash_file
	$(SHELLCHECK_BASH) '$(1)';
endef

# Run shellcheck on a .bats file.
define shellcheck_bats_file
	$(SHELLCHECK_BATS) '$(1)';
endef

# Find *.bash files.
BASH_FILES := $(shell find $(SOURCE_PATH) -name "*.bash")
PUBLIC_BASH_FILES := $(sort $(shell find $(SOURCE_PATH) -maxdepth 1 -name "*.bash"))

# Detect sources structure based on found bash scripts.
SOURCE_STRUCTURE := $(sort $(dir $(BASH_FILES)))

# Generate *.bats files path (wildcard check the files existance).
BATS_FILES := $(wildcard $(patsubst $(SOURCE_PATH)/%,$(TEST_PATH)/%,$(BASH_FILES:%.bash=%.bats)))

# Generates *.md documentation files path
MD_FILES := $(patsubst $(SOURCE_PATH)/%,$(DOC_PATH)/%,$(BASH_FILES:%.bash=%.md))

.PHONY: help all \
	brief  \
	shellcheck-test shellcheck-src \
	shfmt-test shfmt-src \
	test coverage \
	readme-clean doc-clean coverage-clean

###
# Internal rules.
###

$(DOC_PATH)/%.md: $(SOURCE_PATH)/%.bash # Documentation generation rule.
	@mkdir -p $(@D)
	@$(SHDOC) $< > $@

doc-clean: # Remove all generated documentation files.
	@$(RM) $(MD_FILES)
	@echo "Removed generated documentation."

shellcheck-src: # Run shellcheck on all sources.
	@$(foreach bash_file,$(BASH_FILES),$(call shellcheck_bash_file,$(bash_file)))

shellcheck-test: # Run shellcheck on all tests.
	@$(foreach bats_file,$(BATS_FILES),$(call shellcheck_bats_file,$(bats_file)))

shellcheck: shellcheck-src shellcheck-test # Run shellcheck on all sources and tests.

shfmt-test: # Format bats files in test path.
	@$(SHFMT) $(BATS_FILES)

shfmt-src: # Format bash scripts in source path.
	@$(SHFMT) $(BASH_FILES)

shfmt: shfmt-test shfmt-src # Format files using shfmt.

readme-clean: # Remove README.md functions list.
	@sed --in-place --expression='/$(BRIEF_START)/,/$(BRIEF_END)/{//!d}' '$(README_PATH)'

coverage-clean: # Remove coverage folder
	@rm -r '$(COVERAGE_PATH)'

brief: # Insert brief rule result in README.md file between brief start and brief end.
	@grep '@brief' $(PUBLIC_BASH_FILES) | \
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

test: ## Run unit-tests using bats.
	$(BATS) $(BATS_FILES)

coverage: ## Compute tests coverage
	$(BASHCOV) $(BATS) $(BATS_FILES)

doc: $(MD_FILES) ## Generate documentation from sources using shdoc.

readme: brief ## Update README.md functions list.

clean: coverage-clean doc-clean readme-clean ## Remove all generated documentation files and remove functions list from README.md
