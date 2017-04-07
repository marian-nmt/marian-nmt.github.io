# AmuNMT Website

The website is build with Jekyll - a static site generator.
The content is created and updated on branch `jekyll`, then the static pages
are generated with Jekyll and stored in branch `master`.

We use custom theme, which is not supported by automatic GitHub Pages
generator. The static files have to be generated locally before deploying.


## Local build

To build the website locally you need to install `ruby` with gem `bundler`.

On Ubuntu 16.04 you can run:

    [sudo] apt-get install ruby-dev
    [sudo] gem install bundler

Then, install gem dependencies:

    make install

Finally, build the website (it will be generated in `_site` folder) and run a
local development server:

    make run

The website should be available at `http://127.0.0.1:4000`.


## Deployment

To update the content of website it should be enough to edit the relevant
markdown files.
When all updates have been made and the website can be still generated locally
*without errors*, you can commit and deploy your changes by running:

    ./commit-and-deploy.sh

The script commit all changes for you with default commit message, but it is
always better to commit changes on your own beforehand and set a relevant
message.
