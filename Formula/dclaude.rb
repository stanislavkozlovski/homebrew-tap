class Dclaude < Formula
  desc "Run Claude Code and Codex inside Docker with same-path mounts"
  homepage "https://github.com/stanislavkozlovski/dclaude"
  url "https://github.com/stanislavkozlovski/dclaude/releases/download/v0.1.86/dclaude-v0.1.86.tar.gz"
  sha256 "d4e0c7dcdf48453c877fbd559e88099657d6c8cf3e2bf91bb854fad5b7b270c4"
  license :cannot_represent

  def install
    libexec.install Dir["*"]

    bin.install_symlink libexec/"dclaude"
    bin.install_symlink libexec/"dcodex"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dclaude --version")
    assert_match version.to_s, shell_output("#{bin}/dcodex --version")
    assert_match "usage: dclaude", shell_output("#{bin}/dclaude --help")
  end
end
