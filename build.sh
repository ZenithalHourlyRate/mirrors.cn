#!/usr/bin/env bash

set -e

## build mirrorz
cd mirrorz
if ! command -v yarn; then
  # Yes, CF pages builder does not have `yarn`
  npm install --global yarn
fi
yarn --frozen-lockfile
yarn build
cd ../

## generate mirrors list
cd list && node generate.js && cd ..

## render legacy page for each province
rm -rf dist && mkdir -p dist

function render() {
  ## no $1 nor $2: render for webroot
  ## $1 and no $2: render for province with its own conf
  ## $1 '' and $2: render for province with global conf

  cp list/${1}mirrors.js mirrorz/src/config/mirrors.js
  cd mirrorz && yarn legacy_build && cd ../
  if [ "$#" -lt 1 ]; then
    cp -r mirrorz/dist/* dist
  else
    cp -r mirrorz/dist dist/${1}${2}
  fi
  cp dist/${1}${2}_/index.html dist/${1}${2}index.html
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
