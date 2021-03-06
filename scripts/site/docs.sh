#!/bin/bash

ARG_DEFS=(
  "--version-name=(.*)"
)

echo "##### "
echo "##### site/docs.sh"
echo "#####"

function init {
  SITE_DIR=$HOME/ionic-site

  ../clone/clone.sh --repository="driftyco/ionic-site" \
    --directory="$SITE_DIR" \
    --branch="gh-pages"
}

# Example: ./scripts/site/publish.sh --action=docs --version-name=nightly
function run {

  cd ../..
  VERSION=$(readJsonProp "package.json" "version")

  node_modules/.bin/gulp docs --doc-version="$VERSION_NAME" --dist=$SITE_DIR
  node_modules/.bin/gulp docs-index --dist=$SITE_DIR

  cd $SITE_DIR

  CHANGES=$(git status --porcelain)

  # if no changes, don't commit
  if [[ "$CHANGES" == "" ]]; then
    echo "-- No changes detected in docs for $VERSION_NAME; docs not updated."
  else
    git add -A
    git commit -am "docs: update for $VERSION"
    git push -q origin gh-pages

    echo "-- Updated docs for $VERSION_NAME succesfully!"
  fi
}

source $(dirname $0)/../utils.inc
