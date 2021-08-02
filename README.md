# mirrors.cn

mirrors.{[bj](https://mirrors.bj.cn),[tj](https://mirrors.tj.cn),[sh](https://mirrors.sh.cn),[cq](https://mirrors.cq.cn),[he](https://mirrors.he.cn),[ha](https://mirrors.ha.cn),[sx](https://mirrors.sx.cn),[nm](https://mirrors.nm.cn),[ln](https://mirrors.ln.cn),[jl](https://mirrors.jl.cn),[hl](https://mirrors.hl.cn),[js](https://mirrors.js.cn),[zj](https://mirrors.zj.cn),[ah](https://mirrors.ah.cn),[fj](https://mirrors.fj.cn),[jx](https://mirrors.jx.cn),[sd](https://mirrors.sd.cn),[hb](https://mirrors.hb.cn),[hn](https://mirrors.hn.cn),[gd](https://mirrors.gd.cn),[gx](https://mirrors.gx.cn),[hi](https://mirrors.hi.cn),[sc](https://mirrors.sc.cn),[gz](https://mirrors.gz.cn),[yn](https://mirrors.yn.cn),[xz](https://mirrors.xz.cn),[sn](https://mirrors.sn.cn),[gs](https://mirrors.gs.cn),[qh](https://mirrors.qh.cn),[nx](https://mirrors.nx.cn),[xj](https://mirrors.xj.cn),[tw](https://mirrors.tw.cn),[hk](https://mirrors.hk.cn),[mo](https://mirrors.mo.cn)}.cn

## Policy

This is not an official product of [MirrorZ](https://github.com/tuna/mirrorz)

Not all mirror sites included in `/list/meta.js` may get itself upstreamed.

## Dev

## Build

Use `./build.sh` to build.

At the end of `build.sh`, `git reset --hard` is used for cleanup of mirrorz submodule. Take care if you modified mirrorz earlier.

## Serve

Use `./serve.sh [province [port]]` to start a local server.

## Subpath

Due to the speciality of the domains of this repo, a reverse proxy to province subpath is implemented. It is currently deployed at <mirrors-cn.zenithal.workers.dev>
