class Avm < Formula
  desc "Anything Version Manager"
  homepage "https://github.com/tubbo/avm"
  url "https://github.com/tubbo/avm/archive/v0.1.1.tar.gz"
  sha256 "240ff1544ab10f3d79402478fd1456fb528e5a62b99b4830227706d33c4889c0"

  head "https://github.com/tubbo/avm.git"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
