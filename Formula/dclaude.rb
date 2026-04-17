class Dclaude < Formula
  desc "Run Claude Code and Codex inside Docker with same-path mounts"
  homepage "https://github.com/stanislavkozlovski/dclaude"
  url "https://github.com/stanislavkozlovski/dclaude/releases/download/v0.1.3/dclaude-v0.1.3.tar.gz"
  sha256 "89cd1850442f06f7b53cddf61aa2dc272152b3d31ce39a39eb0095780ac46fda"
  license :cannot_represent

  def install
    libexec.install Dir["*"]

    # Upstream wrappers assume a repo-local checkout; patch them for Homebrew.
    %w[dclaude dcodex].each do |wrapper|
      inreplace libexec/wrapper do |s|
        raise "failed to patch #{wrapper} for Homebrew" unless s.gsub!(
          /PROJECT_ROOT=.*?exit 1\n}\n\n/m,
          <<~EOS
            if [ "${1:-}" = "--version" ]; then
              echo "#{version}"
              exit 0
            fi

            DCLAUDE_HOME="#{libexec}"

          EOS
        )
        raise "failed to patch #{wrapper} for Homebrew" unless s.gsub!(
          'source "$PROJECT_ROOT/scripts/agent-common.sh"',
          'source "$DCLAUDE_HOME/scripts/agent-common.sh"',
        )
      end
    end

    inreplace libexec/"scripts/agent-common.sh" do |s|
      raise "failed to set DCLAUDE_HOME" unless s.gsub!(
        'DCLAUDE_IMAGE_NAME="${DCLAUDE_IMAGE_NAME:-dclaude:local}"',
        <<~EOS.chomp,
          DCLAUDE_IMAGE_NAME="${DCLAUDE_IMAGE_NAME:-dclaude:local}"
          DCLAUDE_HOME="${DCLAUDE_HOME:-#{libexec}}"
        EOS
      )
      s.gsub! "./$tool", "$tool"
      raise "failed to patch build context" unless s.gsub!('from $PROJECT_ROOT', 'from $DCLAUDE_HOME')
      raise "failed to patch docker build path" unless s.gsub!(
        'docker build -t "$DCLAUDE_IMAGE_NAME" "$PROJECT_ROOT"',
        'docker build -t "$DCLAUDE_IMAGE_NAME" "$DCLAUDE_HOME"',
      )
      raise "failed to patch workspace root detection" unless s.gsub!(
        'PROJECT_ROOT="$(cd "$(git rev-parse --show-toplevel)" && pwd -P)"',
        <<~EOS.chomp,
          PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || die "$WRAPPER_NAME must be run from inside a git repository"
          PROJECT_ROOT="$(cd "$PROJECT_ROOT" && pwd -P)"
        EOS
      )
    end

    bin.install_symlink libexec/"dclaude"
    bin.install_symlink libexec/"dcodex"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dclaude --version")
    assert_match version.to_s, shell_output("#{bin}/dcodex --version")
    assert_match "usage: dclaude", shell_output("#{bin}/dclaude --help")
  end
end
