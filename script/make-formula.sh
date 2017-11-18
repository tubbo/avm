#!/usr/local/bin/zsh
#
# Generate homebrew formula text

version=$1
sha=$(shasum -a 256 pkg/avm-$version.tar.gz | awk '{ print $1 }')

cat <<ruby
class Avm < Formula
  desc "Anything Version Manager"
  homepage "https://github.com/tubbo/avm"
  url "https://github.com/tubbo/avm/archive/v$version.tar.gz"
  sha256 "$sha"

  head "https://github.com/tubbo/avm.git"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
ruby
