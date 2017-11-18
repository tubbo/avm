# avm: anything version manager

A version manager for any backend service, like databases or cache
servers, that you can run locally for development purposes. Inspired by
[esvm][esvm], it uses [Docker][docker] to run your backend services in
containers, and downloads/updates images automatically if they're not
already installed.

## Installation

Install with Homebrew:

    brew install https://raw.githubusercontent.com/tubbo/avm/master/Formula/avm.rb

Or, manually:

    git clone https://github.com/tubbo/avm.git
    cd avm
    make install

## Usage

After installing, run the `avm` command to start a service in the
foreground. For example, if you wanted to install and run Elasticsearch
v1.5.2:

    avm elasticsearch 1.5.2

For most services, this won't be suitable because the port of the
service won't be properly mapped. For this, you'll need a **service
descriptor file** located at `~/.avm/$SERVICE_NAME` to pass options to
the `docker run` command when your service's container is started. This
can be anything from a simple port mapping to complex configuration and
first-run commands. In the elasticsearch realm, we might want to have a
service descriptor file at `~/.avm/elasticsearch` that looks something
like the following:

    -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node"

This string of text gets passed verbatim to `docker run`.

[esvm]: https://github.com/elastic/esvm
[docker]: https://www.docker.com
