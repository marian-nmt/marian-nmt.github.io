
run: build
	bundle exec jekyll serve --skip-initial-build

build:
	lessc ./assets/less/styles.less > ./assets/css/styles.css
	bundle exec jekyll build

setup:
	bundle update

zip: amunmt-website.tgz

amunmt-website.tgz: build
	tar zcf $@ _site

clean:
	bundle exec jekyll clean

.PHONY: run build setup zip clean
