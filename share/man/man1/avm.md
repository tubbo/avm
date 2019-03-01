avm(1) - anything version manager
=================================

## SYNOPSIS

`avm SERVICE [VERSION] [ARGUMENTS]`

## DESCRIPTION

**avm** is a version manager for any backend service, like databases or
cache servers, that you can run locally for development purposes.
Inspired by **esvm**, it uses **Docker** to run your backend services in
containers, and downloads/updates images automatically if they're not
already installed.

## ARGUMENTS

*SERVICE*
  Image name of the service you wish to run.

*VERSION*
  Optional version of the service. Default: **latest**

*ARGUMENTS*
  Any arguments to `docker run` for the command.

## CONFIGURATION

You can configure **avm** automatically by using service descriptor
files at `~/.avm/SERVICE_NAME`. They contain the options passed to
`docker run` for your command, so you don't have to remember them every
time you want to start up a container.

**NOTE:** All commands use `--rm --interactive --tty` by default.

## AUTHOR

Tom Scott <http://psychedeli.ca>
