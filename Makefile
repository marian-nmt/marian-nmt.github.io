
all: run

run: build
	bundle exec jekyll serve --skip-initial-build

build: docs
	bundle exec jekyll build

install: Gemfile.lock
Gemfile.lock: Gemfile
	bundle update

zip: amunmt-website.tgz
amunmt-website.tgz: build
	tar zcf $@ _site

docs: Doxyfile.marian.in marian
	doxygen $<
marian:
	git clone https://github.com/amunmt/marian.git $@

clean-docs:
	rm -rf docs/marian

clean: clean-docs
	bundle exec jekyll clean

.PHONY: build clean docs install run zip
