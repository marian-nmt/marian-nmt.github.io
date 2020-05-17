
SHELL := /bin/bash

MARIAN   = marian/build
COMMANDS = marian marian-decoder marian-server marian-scorer marian-vocab marian-conv
CMDFILES = $(patsubst %,docs/cmd/%.md,$(COMMANDS))

.PHONY: build clean update-gems update-cmds update-docs install run zip Gamefile.lock


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

# generate pages with command-line options
update-cmds: $(MARIAN) $(CMDFILES)

docs/cmd/%.md: docs/cmd/_template.tmp
	sed "s/<COMMAND>/$*/" $^ > $@
	echo "Version: " >> $@
	$(MARIAN)/marian --version >> $@ 2>&1
	echo "" >> $@
	$(MARIAN)/$* -h 2>&1 | bash _scripts/help2markdown.sh | python _scripts/wrap_help.py >> $@

# generate documentation
update-docs: Doxyfile.marian.in marian
	sed -i -r "s/PROJECT_NUMBER * = .*/PROJECT_NUMBER = $$(cat marian\/VERSION)/" Doxyfile.marian.in
	doxygen $<


# download & compile marian
marian/build: marian
	mkdir -p marian/build && cd marian/build && cmake .. && make -j8
marian:
	git -C $@ pull || git clone https://github.com/marian-nmt/marian-dev.git $@
	cd marian; git checkout stable; cd ..


# clean
clean-docs:
	rm -rf docs/marian

clean: clean-docs
	bundle exec jekyll clean
