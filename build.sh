#!/usr/bin/env bash

set -e

## build mirrorz
git submodule update --init --recursive
cd mirrorz
if ! command -v yarn; then
  # Yes, CF pages builder does not have `yarn`
  npm install --global yarn
fi
yarn --frozen-lockfile
yarn build
cd ../

## render legacy page for each province
rm -rf dist && mkdir -p dist
for province in {bj,tj,sh,cq,he,ha,sx,nm,ln,jl,hl,js,zj,ah,fj,jx,sd,hb,hn,gd,gx,hi,sc,gz,yn,xz,sn,gs,qh,nx,xj,tw,hk,mo}; do
  echo Building for $province
  if [ -e list/$province ]; then
    cp list/$province/mirrors.js mirrorz/src/config/mirrors.js
    cd mirrorz && yarn legacy_build && cd ../
    cp -r mirrorz/dist dist/$province
    cp dist/$province/_/index.html dist/$province/index.html
    rm -r mirrorz/dist/_/
  else
    ln -s ../dist dist/$province
  fi
done

# restore mirrorz and build for mirrors-cn.pages.dev
cd mirrorz && git reset --hard && yarn legacy_build && cd ..
cp -r mirrorz/dist/* dist
cp dist/_/index.html dist/index.html
