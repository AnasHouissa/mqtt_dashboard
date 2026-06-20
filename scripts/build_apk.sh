#!/usr/bin/env bash
#
# Bump the app version, build a release APK, and name it mqtt_dash-<version>.apk.
#
# Usage:
#   scripts/build_apk.sh <major|minor|patch>
#
# Versioning follows semver in pubspec.yaml: "version: X.Y.Z+B" where
#   X.Y.Z = versionName (shown to users, used in the APK file name)
#   B     = versionCode (Play Store build number, always incremented)
#
#   major -> X+1.0.0     minor -> X.Y+1.0     patch -> X.Y.Z+1
# The build number B is incremented on every build regardless of the bump type.

set -euo pipefail

BUMP="${1:-}"
case "$BUMP" in
  major|minor|patch) ;;
  *)
    echo "Usage: $0 <major|minor|patch>" >&2
    exit 1
    ;;
esac

# Move to the repo root (this script lives in scripts/).
cd "$(dirname "$0")/.."

if [ ! -f pubspec.yaml ]; then
  echo "Error: pubspec.yaml not found in $(pwd)" >&2
  exit 1
fi

CURRENT="$(grep -E '^version:' pubspec.yaml | head -1 | sed -E 's/^version:[[:space:]]*//' | tr -d '[:space:]')"
if [ -z "$CURRENT" ]; then
  echo "Error: could not read 'version:' from pubspec.yaml" >&2
  exit 1
fi

SEMVER="${CURRENT%%+*}"
if [ "$CURRENT" = "$SEMVER" ]; then
  BUILD=0          # no "+B" build number present
else
  BUILD="${CURRENT##*+}"
fi

IFS='.' read -r MAJOR MINOR PATCH <<< "$SEMVER"
MAJOR="${MAJOR:-0}"; MINOR="${MINOR:-0}"; PATCH="${PATCH:-0}"

case "$BUMP" in
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  patch) PATCH=$((PATCH + 1)) ;;
esac

NEW_BUILD=$((BUILD + 1))
NEW_NAME="${MAJOR}.${MINOR}.${PATCH}"
NEW_FULL="${NEW_NAME}+${NEW_BUILD}"

# Update pubspec.yaml in place (macOS-compatible sed).
sed -i.bak -E "s/^version:.*/version: ${NEW_FULL}/" pubspec.yaml
rm -f pubspec.yaml.bak

echo "==> Version bumped: ${CURRENT} -> ${NEW_FULL} (${BUMP})"

echo "==> Building release APK..."
flutter build apk --release

SRC="build/app/outputs/flutter-apk/app-release.apk"
DEST="build/app/outputs/flutter-apk/mqtt_dash-${NEW_NAME}.apk"

if [ ! -f "$SRC" ]; then
  echo "Error: expected build output not found: $SRC" >&2
  exit 1
fi

cp "$SRC" "$DEST"

echo ""
echo "==> Done."
echo "    Version: ${NEW_FULL}"
echo "    APK:     ${DEST}"