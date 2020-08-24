#!/usr/bin/env bash
set -e

if [ $# -ne 1 ]
then
	echo "usage: $0 language_code"
	exit 0
fi

IROHA_LANG="$1"
IROHA_LANG_DIR="$PWD/docs/locale/$IROHA_LANG"
IROHA_DOCS_DIR="$IROHA_LANG_DIR/docs"

# Prepare folder for translation
mkdir -p "$IROHA_DOCS_DIR"

# Create symlinks for docs directory
lndir "$PWD"/iroha/docs/ "$IROHA_DOCS_DIR"

# Replace absolute symlinks with relative
symlinks -rc "$IROHA_LANG_DIR"

# Replace symlinks with file copies for rst, md, csv, yaml
for f in $(find "$IROHA_LANG_DIR" -type l \( -name '*.rst' -o -name '*.md' -o -name '*.csv' -o -name '*.yaml' \))
do
	cp --remove-destination $(readlink -f $f) $f
done

# Copy CONTRIBUTING.* from iroha repo root
cp "$PWD"/iroha/CONTRIBUTING.* "$IROHA_LANG_DIR"/

# Update locale.yaml with given language code
echo "language: \"$IROHA_LANG\"" > "$IROHA_DOCS_DIR/source/locale.yaml"
