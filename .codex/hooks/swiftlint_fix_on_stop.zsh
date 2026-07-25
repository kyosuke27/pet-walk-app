#!/bin/zsh
set -u

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

cd "${repo_root}" || exit 0

# Swiftファイルに未コミット変更がない場合は、実装後ではないものとして何もしない。
if ! git status --short -- '*.swift' | grep -q .; then
    exit 0
fi

# Stop hookはstdoutの通常ログを解釈するため、SwiftLintの出力は破棄する。
if ! command -v mint >/dev/null 2>&1; then
    exit 0
fi

mint run swiftlint --fix >/dev/null 2>&1 || true
