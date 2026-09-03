class Dclaude < Formula
  desc "Run Claude Code and Codex inside Docker with same-path mounts"
  homepage "https://github.com/stanislavkozlovski/dclaude"
  url "https://github.com/stanislavkozlovski/dclaude/releases/download/v0.1.82/dclaude-v0.1.82.tar.gz"
  sha256 "5886c05949490c475d1b1148c3e4d84ad50ccc3ba36a2b372caf7c4d40488fb1"
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
