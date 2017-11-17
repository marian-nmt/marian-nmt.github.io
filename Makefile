
all: run

run: build
	bundle exec jekyll serve --skip-initial-build

build:
	bundle exec jekyll build

install: Gemfile.lock
Gemfile.lock: Gemfile
	bundle update

clean:
	bundle exec jekyll clean

.PHONY: run build clean install zip
