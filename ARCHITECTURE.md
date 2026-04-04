# Architecture

This repository is a minimal Homebrew tap for `stanislavkozlovski/dclaude`.

## Components

- `Formula/dclaude.rb` installs the upstream release tarball into `libexec` and symlinks `dclaude` and `dcodex` into `bin`.
- `util/update_dclaude_formula.py` is the release-automation entrypoint. It rewrites the formula `url` and `sha256` in place for a tagged upstream release.
- `README.md` and `HOWRUN.md` document the install path for end users.

## Release Model

The tap expects upstream release tarballs at:

`https://github.com/<repo>/releases/download/v<version>/dclaude-v<version>.tar.gz`

The tarball is expected to unpack to a top-level directory from `git archive`, such as `dclaude-<version>/`, with executable wrapper scripts at the repo root:

- `dclaude`
- `dcodex`

## Runtime Model

The formula does not build software. It stages the extracted upstream repository under `libexec`, patches the repo-local wrapper scripts for a global Homebrew install, and exposes `dclaude` and `dcodex` through Homebrew-managed symlinks in `bin`.

At install time the formula:

- pins the packaged asset location through `DCLAUDE_HOME=<libexec>`
- keeps the current git repository as the runtime workspace root
- preserves the upstream Docker image build flow, but points the build context at the packaged files in `libexec`
- short-circuits `--version` so the Homebrew test stays offline and does not require Docker

## Database Schema

None.

This repository has no database, migrations, tables, collections, or persisted application state.
