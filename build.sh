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
  ln -s config/mirrorz.org.json mirrorz/src/config/config.json
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
unlink src/config/config.json
cd ../

## generate mirrors list
cd list && node generate.js && cd ..

## render legacy page for each province
rm -rf dist && mkdir -p dist

function render() {
  ## no $1 nor $2: render for webroot
  ## $1 and no $2: render for province with its own conf
  ## $1 '' and $2: render for province with global conf

  cp list/${1}config.json mirrorz/src/config/config.json
  cd mirrorz && yarn legacy_build && cd ../
  if [ "$#" -lt 1 ]; then
    cp -r mirrorz/dist/* dist
  else
    cp -r mirrorz/dist dist/${1}${2}
  fi
  cp dist/${1}${2}_/about/index.html dist/${1}${2}index.html
  rm -r mirrorz/dist/_/
}

for province in {bj,tj,sh,cq,he,ha,sx,nm,ln,jl,hl,js,zj,ah,fj,jx,sd,hb,hn,gd,gx,hi,sc,gz,yn,xz,sn,gs,qh,nx,xj,tw,hk,mo}; do
  echo Building for $province
  if [ -e list/$province ]; then
    render $province/
  else
    render '' $province/
  fi
done

# build for mirrors-cn.pages.dev
render

# cleanup
cd mirrorz && git reset --hard && cd ..
