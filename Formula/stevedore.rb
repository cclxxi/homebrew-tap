class Stevedore < Formula
  desc "A super-lightweight TUI for monitoring Docker containers and logs"
  homepage "https://github.com/cclxxi/stevedore"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cclxxi/stevedore/releases/download/v0.1.0/stevedore-aarch64-apple-darwin.tar.xz"
      sha256 "74518c18abe369b46b722dccc574bed266ed7db3d585bd71145220aa0754ce4f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cclxxi/stevedore/releases/download/v0.1.0/stevedore-x86_64-apple-darwin.tar.xz"
      sha256 "f06d5c8907d1c7e0656f5e4128c4b718fa4e624205e66c06f67680bc173e42a5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cclxxi/stevedore/releases/download/v0.1.0/stevedore-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5a323b9b32161aeed3ef9b2318b558c7fa2d920b27d3ac400a680b534d0032de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cclxxi/stevedore/releases/download/v0.1.0/stevedore-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "de3a344abba722ec76b058f2f4c7a040dfa92fe147d7d53077c1358a9773c8fa"
    end
  end
  license "GPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "stevedore" if OS.mac? && Hardware::CPU.arm?
    bin.install "stevedore" if OS.mac? && Hardware::CPU.intel?
    bin.install "stevedore" if OS.linux? && Hardware::CPU.arm?
    bin.install "stevedore" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
