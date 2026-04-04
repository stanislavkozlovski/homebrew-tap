#!/usr/bin/env python3

from __future__ import annotations

import argparse
import re
from pathlib import Path


FORMULA_PATH = Path(__file__).resolve().parents[1] / "Formula" / "dclaude.rb"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("version")
    parser.add_argument("--repo", required=True)
    parser.add_argument("--sha256", required=True)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    sha256 = args.sha256.lower()

    if not re.fullmatch(r"[0-9a-f]{64}", sha256):
        raise SystemExit("error: --sha256 must be a 64-character hex string")

    url = (
        f"https://github.com/{args.repo}/releases/download/v{args.version}/"
        f"dclaude-v{args.version}.tar.gz"
    )

    contents = FORMULA_PATH.read_text()
    contents, url_count = re.subn(
        r'^  url "[^"]+"\n',
        f'  url "{url}"\n',
        contents,
        count=1,
        flags=re.MULTILINE,
    )
    contents, sha_count = re.subn(
        r'^  sha256 "[0-9a-f]{64}"\n',
        f'  sha256 "{sha256}"\n',
        contents,
        count=1,
        flags=re.MULTILINE,
    )

    if url_count != 1 or sha_count != 1:
        raise SystemExit(f"error: failed to update {FORMULA_PATH}")

    FORMULA_PATH.write_text(contents)


if __name__ == "__main__":
    main()
