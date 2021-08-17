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
  ln -s ../config/config.json mirrorz/src/parser/config.json
fi
if [ ! -e mirrorz/src/i18n ]; then
  git clone ${github_remote}mirrorz-org/mirrorz-i18n.git mirrorz/src/i18n
  ln -s ../config/config.json mirrorz/src/i18n/config.json
fi

if [ ! -e mirrorz/legacy ]; then
  git clone ${github_remote}mirrorz-org/mirrorz-legacy.git mirrorz/legacy
  ln -s ../ mirrorz/legacy/mirrorz
  ln -s ../src/config/config.json mirrorz/legacy/config.json
  ln -s ../src/i18n mirrorz/legacy/i18n
  ln -s ../static/json/legacy mirrorz/legacy/json-legacy
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
cp -r dist mirrors-cn

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
    cp -r mirrors-cn dist/$province
  fi
done

# cleanup
cd mirrorz && git reset --hard && cd ..
