class Dclaude < Formula
  desc "Run Claude Code and Codex inside Docker with same-path mounts"
  homepage "https://github.com/stanislavkozlovski/dclaude"
  url "https://github.com/stanislavkozlovski/dclaude/releases/download/v0.1.73/dclaude-v0.1.73.tar.gz"
  sha256 "d9ccf154d8089ad239db2c8481e5d1f5ef3406a5b6610fd2b2196e906a56ada6"
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
