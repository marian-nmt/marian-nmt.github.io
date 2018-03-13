
COMMANDS = marian marian-decoder marian-server marian-scorer

.PHONY: build clean update-cmds update-docs install run zip


all: run

run: build update-docs
	bundle exec jekyll serve --skip-initial-build

build:
	bundle exec jekyll build

install: Gemfile.lock
Gemfile.lock: Gemfile
	bundle update


# generate archive
zip: marian-nmt-website.tgz
marian-nmt-website.tgz: build
	tar zcf $@ _site

# generate pages with command-line options
update-cmds: marian/build $(patsubst %,docs/cmd/%.md,$(COMMANDS))
update-cmd-files: $(patsubst %,docs/cmd/%.md,$(COMMANDS))

docs/cmd/%.md: docs/cmd/_template.tmp
	sed "s/<COMMAND>/$*/" $^ > $@
	./marian/build/$* -h 2>&1 | bash _scripts/help2markdown.sh >> $@
	echo "Version: " >> $@
	./marian/build/marian --version >> $@ 2>&1

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
