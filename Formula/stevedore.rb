class Stevedore < Formula
  desc "A super-lightweight TUI for monitoring Docker containers and logs"
  homepage "https://github.com/cclxxi/stevedore"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/cclxxi/stevedore/releases/download/v0.2.0/stevedore-aarch64-apple-darwin.tar.xz"
      sha256 "18fc1db1bbd856755c18447e7aebe5aefbb3b5fcff9b2e7ed3c93fa55fa84674"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cclxxi/stevedore/releases/download/v0.2.0/stevedore-x86_64-apple-darwin.tar.xz"
      sha256 "ac7d80779698a7ad233df7f04c4d32054c007ea0db3a0cf472065ffba37c9e42"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/cclxxi/stevedore/releases/download/v0.2.0/stevedore-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7db3986466347a802dfc315760f349578414425ea7db0bfb95e1e9fd37ae3f21"
    end
    if Hardware::CPU.intel?
      url "https://github.com/cclxxi/stevedore/releases/download/v0.2.0/stevedore-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d8eeb07a093b65eed2d7115fb4965cc9d5f07a8a471e6ab14a213e528f8227db"
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
