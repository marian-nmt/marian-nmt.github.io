SHELL := /bin/bash

MARIAN   = marian-dev/build
COMMANDS = marian marian-decoder marian-server marian-scorer marian-vocab marian-conv
CMDFILES = $(patsubst %,docs/cmd/%.md,$(COMMANDS))

.PHONY: build install update-gems update-cmds update-datafile run

# Update Marian outputs and build
all: update-cmds update-datafile run

# Jekyll
run: build
	bundle exec jekyll serve --skip-initial-build

build: install
	bundle exec jekyll build

install: Gemfile
	bundle install
update-gems: Gemfile
	bundle update

## Update pages with command-line options
update-cmds: $(CMDFILES)

## Update verion datafile
update-datafile: _data/marian.yml

## Generate datafile from extracted version/sha
_data/marian.yml: $(MARIAN)/marian.version $(MARIAN)/marian.sha
	_scripts/datafile.sh $^ $@

## Extract version
$(MARIAN)/%.version: | $(MARIAN)
	@echo "Ouput Version"
	$(MARIAN)/$* --version > $@ 2>&1

## Extract helptext
$(MARIAN)/%.help: | $(MARIAN)
	@echo "Ouput Help"
	$(MARIAN)/$* --help > $@ 2>&1

## Extract submodule commmit ref (sha)
$(MARIAN)/marian.sha:
	rev=$$(cd $(MARIAN) && echo "$$(git rev-parse HEAD)");\
	echo $$rev > $@

## Build CLI markdown file
docs/cmd/%.md: docs/cmd/_template.tmp $(MARIAN)/%.version $(MARIAN)/%.help
	sed "s/<COMMAND>/$*/" $< > $@
	echo "Version: " >> $@
	cat $(MARIAN)/$*.version >> $@
	echo "" >> $@
	cat $(MARIAN)/$*.help | bash _scripts/help2markdown.sh | python _scripts/wrap_help.py >> $@

## Compile Marian
$(MARIAN):
	git submodule update --init --recursive;\
	mkdir -p marian-dev/build \
		&& cd marian-dev/build \
		&& cmake .. -DCOMPILE_SERVER=ON \
		&& make -j8

# Clean
clean:
	bundle exec jekyll clean
