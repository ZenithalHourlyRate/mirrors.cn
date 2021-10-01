#!/usr/bin/env bash

set -e

github_remote="https://github.com/"
if [ "$1" == "git" ]; then
  github_remote="git@github.com:"
fi

## prepare mirrorz
if [ ! -e mirrorz/static/json/legacy ]; then
  git clone ${github_remote}mirrorz-org/mirrorz-json-legacy.git mirrorz/static/json/json-legacy
  mv mirrorz/static/json/json-legacy/data mirrorz/static/json/legacy
  rm -rf mirrorz/static/json/json-legacy
fi
if [ ! -e mirrorz/static/json/site ]; then
  git clone ${github_remote}mirrorz-org/mirrorz-json-site.git mirrorz/static/json/site
fi

if [ ! -e mirrorz/src/config ]; then
  git clone ${github_remote}mirrorz-org/mirrorz-config.git mirrorz/src/config
  # prepare mirrorz/src/config/config.json later
fi
if [ ! -e mirrorz/src/parser ]; then
  git clone ${github_remote}mirrorz-org/mirrorz-parser.git mirrorz/src/parser
fi
if [ ! -e mirrorz/src/i18n ]; then
  git clone ${github_remote}mirrorz-org/mirrorz-i18n.git mirrorz/src/i18n
fi

if [ ! -e mirrorz/legacy ]; then
  git clone ${github_remote}mirrorz-org/mirrorz-legacy.git mirrorz/legacy
fi

## generate mirrors list
cd list && node generate.js && cd ..
cp list/config.json mirrorz/src/config/config.json

## build mirrorz
cd mirrorz
if ! command -v yarn; then
  # Yes, CF pages builder does not have `yarn`
  npm install --global yarn
fi
### prepare env
yarn other_ln
yarn legacy_env
### prepare dep
yarn --frozen-lockfile
cd legacy
yarn --frozen-lockfile
cd ..
yarn build
cd ../

## cleanup
rm -rf dist

## render mirrors-cn.pages.dev
cd mirrorz && yarn legacy_build && cd ../
cp -r mirrorz/dist dist
cp dist/_/about/index.html dist/index.html

## render legacy page for each province
function render() {
  ## $1: render for province with its own conf

  rm -r mirrorz/dist/_/
  cp list/${1}/config.json mirrorz/src/config/config.json
  cd mirrorz && yarn legacy_build && cd ../
  cp -r mirrorz/dist dist/${1}
  cp dist/${1}/_/about/index.html dist/${1}/index.html
}

for province in {bj,tj,sh,cq,he,ha,sx,nm,ln,jl,hl,js,zj,ah,fj,jx,sd,hb,hn,gd,gx,hi,sc,gz,yn,xz,sn,gs,qh,nx,xj,tw,hk,mo}; do
  echo Building for $province
  if [ -e list/$province ]; then
    render $province
  else
    mkdir -p dist/$province
    # frontend redirection to mirrors-cn.pages.dev
    cp index.html dist/$province/
  fi
done

# cleanup
cd mirrorz && git reset --hard && cd ..
