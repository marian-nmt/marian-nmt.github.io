
SHELL := /bin/bash

MARIAN   = marian-dev/build
COMMANDS = marian marian-decoder marian-server marian-scorer marian-vocab marian-conv
CMDFILES = $(patsubst %,docs/cmd/%.md,$(COMMANDS))

.PHONY: build clean update-gems update-cmds update-datafile install run zip Gamefile.lock


all: run

run: build
	bundle exec jekyll serve --skip-initial-build

build:
	bundle exec jekyll build

install: Gemfile
	bundle install
update-gems: Gemfile
	bundle update


# generate archive
zip: marian-nmt-website.tgz
marian-nmt-website.tgz: build
	tar zcf $@ _site

# Generate pages with command-line options
update-cmds: $(CMDFILES)
update-datafile: _data/marian.yml

# Generate Marian version YAML
_data/marian.yml: $(MARIAN)/marian.version $(MARIAN)/marian.sha
	_scripts/datafile.sh $^ $@

# CLI Documentation
$(MARIAN)/%.version:
	@echo "Ouput Version"
	$(MARIAN)/$* --version > $@ 2>&1

$(MARIAN)/%.help:
	@echo "Ouput Help"
	$(MARIAN)/$* --help > $@ 2>&1

$(MARIAN)/marian.sha:
	rev=$$(cd $(MARIAN) && echo "$$(git rev-parse HEAD)");\
	echo $$rev > $@

docs/cmd/%.md: docs/cmd/_template.tmp $(MARIAN)/%.version $(MARIAN)/%.help
	sed "s/<COMMAND>/$*/" $< > $@
	echo "Version: " >> $@
	cat $(MARIAN)/$*.version >> $@
	echo "" >> $@
	cat $(MARIAN)/$*.help | bash _scripts/help2markdown.sh | python _scripts/wrap_help.py >> $@


# Compile Marian
marian-dev/build: marian-dev
	mkdir -p marian-dev/build && cd marian-dev/build && cmake .. -DCOMPILE_SERVER=ON && make -j8

# Init submodule
marian-dev:
	git submodule update --init --recursive


# Clean
clean:
	bundle exec jekyll clean
