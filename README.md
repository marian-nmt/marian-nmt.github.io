# AmuNMT Website

The website is build with Jekyll - a static site generator.
The content is created and updated on branch `jekyll`, then the static pages
are generated with Jekyll and stored in branch `master`.

We use custom theme, which is not supported by automatic GitHub Pages
generator. The static files have to be generated locally.


## Local build

To build the website locally you need to install _ruby_ with gem _bundler_, and
the CSS pre-processor _Less_ (this requirement is temporarily).

On Ubuntu 16.04 you can run:

    sudo apt-get install ruby-dev node-less
    sudo gem install bundler

Then, to install all dependencies run: 

    make install
    
`make` command will build and serve the website locally. It will be available
from `127.0.0.1:4000`.
