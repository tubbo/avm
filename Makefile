# Build scripts for AVM. These tasks will generate documentation,
# commands, and of course install the AVM script itself to an executable
# location.
#
# Shoutouts to @postmodern and @isaacs, I lifted most of their ideas to
# make this...

.PHONY: build test check install uninstall clean clobber command release verify

PROGRAM=avm
SHELL=/usr/bin/env zsh
PREFIX?=$(DESTDIR)/usr/local
HOMER_PATH?=$(PWD)
SOURCE_PATH=$(PWD)
DIRS=bin share
INSTALL_DIRS=`find $(DIRS) -type d`
INSTALL_FILES=`find $(DIRS) -type f`
VERSION="0.2.0"

PKG_DIR=dist
PKG_NAME=$(PROGRAM)-$(VERSION)
PKG=$(PKG_DIR)/$(PKG_NAME).tar.gz
TAG=.git/refs/tags/$(VERSION)
SIG=$(PKG).asc

# Install this script to /usr/local and build manpages
all: build
build: docs/index.html $(PKG) $(SIG)

# Install gem dependencies
vendor/bundle:
	@bundle check || bundle install

# Remove generated files
clobber: clean
	@rm -rf dist

clean:
	@rm -rf docs/index.html share/man/man1/avm.1

# Run BATS tests
test:
	@bats test
check: test

# Generate man pages from markdown
share/man/man1/avm.1:
share/man/man1/avm.1.html: vendor/bundle
	@bundle exec ronn --date="2019-03-01" --manual="User Manual" --organization="$(PROGRAM)" share/man/man1/avm.md
docs/index.html: share/man/man1/avm.1.html
	@mkdir -p docs
	@mv share/man/man1/avm.1.html docs/index.html

# Move scripts to /usr/local. Typically requires `sudo` access.
install:
	@cp bin/avm $(PREFIX)/bin/avm
	@cp share/man/man1/avm.1 $(PREFIX)/share/man/man1/avm.1

# Remove scripts from /usr/local. Typically requires `sudo` access.
uninstall:
	@rm -rf $(PREFIX)/bin/avm $(PREFIX)/share/man/man1/avm.1

# Generate a new command
command:
	@cp share/homer/command/bin.sh bin/homer-${NAME}
	@cp share/homer/command/doc.txt share/doc/homer/${NAME}.txt
	@cp share/homer/command/test.bats test/homer-${NAME}-test.bats
	@chmod +x bin/homer-${NAME}

# Tag the current state of the codebase as a released version
$(TAG):
	@git tag v$(VERSION)

# Generate ctags
tags:
	@ctags -R .

# Create a package for the current version of the codebase. This
# omits developer-centric files like tests and build manifests for the
# released version of the package.
$(PKG_DIR):
	@mkdir -p $(PKG_DIR)
$(PKG): $(PKG_DIR)
	@git archive --output=$(PKG) --prefix=$(PKG_NAME)/ HEAD $(DIRS) ./Makefile

# Cryptographically sign the package so its contents can be verified at
# a later date
$(SIG): $(PKG)
	@gpg --sign --detach-sign --armor $(PKG)

# Release the latest version of Homer to GitHub
release: clean build $(TAG)
	@git add dist
	@git commit dist -m "Release v${VERSION}"
	@git push origin master
	@git push origin --tags

# Verify the contents of a package
verify: $(PKG) $(SIG)
	@gpg --verify $(SIG) $(PKG)
