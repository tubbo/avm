# avm: anything version manager

A version manager for any backend service, like databases or cache
servers, that you can run locally for development purposes. Inspired by
[esvm][], it uses [Docker][] to run your backend services in containers,
and downloads/updates images automatically if they're not already installed.

## Installation

Install with Homebrew:

    brew install https://raw.githubusercontent.com/tubbo/avm/master/Formula/avm.rb

If you don't have Homebrew, you can install it with this one-liner:

    curl -o- -L https://tubbo.github.com/avm/install.sh | bash

Or, manually:

    git clone https://github.com/tubbo/avm.git
    cd avm
    make install

## Usage

After installing, run the `avm` command to start a service in the
foreground. For example, if you wanted to install and run Elasticsearch
v1.5.2:

    avm elasticsearch 1.5.2

By default, `docker run` is run with the `--rm --interactive --tty` switches
applied. This ensures the container is removed after it runs so it doesn't take up
extra space on your machine, keeps the `STDIN` pipe open, and allocates
a pseudo-TTY for running commands within the container, if necessary.

### Service Descriptors

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

## Development

Run automated tests:

    make test

Verify signature:

    make verify

Contributors should issue a pull request on GitHub after verifying tests
pass.

## License

Copyright 2017-2019 Tom Scott

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[esvm]: https://github.com/elastic/esvm
[Docker]: https://www.docker.com
