#!/bin/bash -v

set -e

git commit -a -m 'Commit local changes to Jekyll sources' || true
git push origin jekyll
JEKYLL_ENV=production bundle exec jekyll build
git checkout master
rsync -ca _site/* .
rm -rf _site Doxyfile.marian.in *~
git add * || true
git commit -a -m 'Commit static pages'
git push origin master
git checkout jekyll
