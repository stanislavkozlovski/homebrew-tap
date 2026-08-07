class Dclaude < Formula
  desc "Run Claude Code and Codex inside Docker with same-path mounts"
  homepage "https://github.com/stanislavkozlovski/dclaude"
  url "https://github.com/stanislavkozlovski/dclaude/releases/download/v0.1.62/dclaude-v0.1.62.tar.gz"
  sha256 "ea20df8906cd53bd87661ed64bb9acd086998650b02c580ded799870c3bb4ed2"
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
