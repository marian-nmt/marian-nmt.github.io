# Marian Website

The website is build with Jekyll - a static site generator.
The content is created and updated on branch `jekyll`, then the static pages
are generated with Jekyll and stored in the branch `master`.

:warning: Please **do not update files directly in `master`**. :warning:

## Automated build

The documentation is automatically built and deployed to the [marian-nmt][web]
website using GitHub Actions.

This covers:
  - Generation of CLI version/help markdown pages
  - Generation of API documentation (developer docs)
  - Building of the Jekyll source
  - Deployment to website

The CLI and API document content is determined by the pinned version of the
marian-dev submodule.

### The CLI documentation

This pipeline is triggered by pushes on the source branch `jekyll`, and, on
success, the resulting site is pushed to the GitHub pages branch (`master`).

**Caution!** When new CLI documentation is produced, an automated commit is
pushed onto the source branch (message: `Update CLI options:`).
<!--
This is necessary due to the renderedtimestamp of these files being
determined from their last-commit date.
-->
For pull requests against the source branch, the resulting site is available as
an artifact and should be reviewed before approval.

To review a downloaded jekyll artifact, you can serve it locally with, for
example:
```shell
python3 -m http.server -d /path/to/downloaded/artifact/
```


## Local build
For development and test purposes, you can also build the site locally.

If cloning the repository for the first time, download the remote branch:

    git clone https://github.com/marian-nmt/marian-nmt.github.io
    cd marian-nmt.github.io
    git fetch origin jekyll
    git checkout jekyll

To build the website locally you need to install `ruby` with gem `bundler`.

On Ubuntu you can run:
```shell
[sudo] apt-get install ruby-dev
[sudo] gem install bundler
```

Then, install gem dependencies:
```shell
make install
```

Finally, build the website (it will be generated in `_site` folder) and run a
local development server:

```shell
make run
```
The website should be available at `http://127.0.0.1:4000`.

### Documentation
Documentation in this repository is built from the Jekyll source, with two exceptions:
 1. The developer API documentation is built on the [marian-nmt/marian-dev][api_action] repository.
 2. The CLI documentation is generated from the `marian` command, and is ran locally as described below.

### Pages with command-line options

Pages with command-line options for Marian tools have are generated using the provided Makefile:

```shell
make -B update-cmds
make -B update-datafile
```
The first command generates the version, and help output. The second generates a
data file containing the version and commit of Marian used. This compiles
Marian, so a GPU is required.

## Logos

Put a logo image into `assets/logos/` and update `_data/logos.yml`.  Use a PNG
image with transparent background.


## Tag reference

| Tag | Description |
| --- | --- |
| `[Text](/permalink/)` | An active link to another subpage of the website identified by its permalink. |
| `{% github_link <repository>/<path/to/file> %}` | An active link to a file/directory `<path/to/file>` in the given repository, i.e. `http://github.com/marian-nmt/<repository>/tree/master/<path/to/file>`. |
| `{% github_link "clickable text" <repository>/<path/to/file> %}` | An active link to a file/directory `<path/to/file>` in the given repository with `clickable text`. |
| `[Text](/link){:target="_blank"}` | Opens the linked document in a new window or tab. |
| `$$ x_{i}^{j} $$` | A LaTeX mathematical formula. |
| `[Text](/path/to/an/image){:.no-lightbox}` | Disable the automatic image box. |

<!-- Links -->
[web]: htts://marian-nmt.github.io
[api_action]: https://github.com/marian-nmt/marian-dev/actions/workflows/documentation.yml
