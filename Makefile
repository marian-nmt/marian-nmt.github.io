
all: run

run: install build
	bundle exec jekyll serve --skip-initial-build

build:
	bundle exec jekyll build

install: Gemfile.lock
Gemfile.lock: Gemfile
	bundle update

zip: amunmt-website.tgz
amunmt-website.tgz: build
	tar zcf $@ _site

clean:
	bundle exec jekyll clean

.PHONY: run build clean install zip
