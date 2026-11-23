#!/usr/bin/env bash
set -euo pipefail

QUICKSHELL_DIR="${QUICKSHELL_DIR:-$HOME/.config/quickshell}"
MAX_AOT_WARNINGS="${MAX_AOT_WARNINGS:-253}"

QMLLINT_BIN="${QMLLINT_BIN:-$(command -v qmllint || true)}"
if [[ -z "$QMLLINT_BIN" && -x "$HOME/.local/bin/qmllint" ]]; then
	QMLLINT_BIN="$HOME/.local/bin/qmllint"
fi
if [[ -z "$QMLLINT_BIN" ]]; then
	echo "error: qmllint not found in PATH or $HOME/.local/bin/qmllint" >&2
	exit 1
fi

cd "$QUICKSHELL_DIR"

shopt -s nullglob
QML_FILES=(
	shell.qml
	Core/*.qml
	Primitives/*.qml
	Services/*.qml
	Surfaces/*.qml
	Widgets/*.qml
	Widgets/QuickSettings/*.qml
)
shopt -u nullglob

LINT_ARGS=(
	-i Core/qmldir
	-i Services/qmldir
	-i Primitives/qmldir
	-i Widgets/qmldir
	-i Surfaces/qmldir
	-I .
)

echo "[qmllint] Checking ${#QML_FILES[@]} QML files..."
LINT_OUTPUT="$("$QMLLINT_BIN" "${LINT_ARGS[@]}" "${QML_FILES[@]}" 2>&1)" || {
	printf '%s\n' "$LINT_OUTPUT" >&2
	exit 1
}
if [[ -n "$LINT_OUTPUT" ]]; then
	printf '%s\n' "$LINT_OUTPUT" >&2
	echo "[qmllint] ERROR: standard qmllint reported warnings" >&2
	exit 1
fi

AOT_OUTPUT="$("$QMLLINT_BIN" --compiler warning "${LINT_ARGS[@]}" "${QML_FILES[@]}" 2>&1 || true)"
AOT_COUNT="$(printf '%s\n' "$AOT_OUTPUT" | grep -c '^Warning:' || true)"
echo "[qmllint] AOT compiler warnings: ${AOT_COUNT} (baseline: ${MAX_AOT_WARNINGS})"

if (( AOT_COUNT > MAX_AOT_WARNINGS )); then
	echo "[qmllint] ERROR: AOT warning count (${AOT_COUNT}) exceeded baseline (${MAX_AOT_WARNINGS})" >&2
	exit 1
fi
