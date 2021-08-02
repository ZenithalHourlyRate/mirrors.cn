const fs = require('fs');
const list = require('./meta');

MAP = {}

async function generate() {
  for (url in list) {
    if (list[url] != "  ") {
      if (!(list[url] in MAP))
        MAP[list[url]] = [url];
      else
        MAP[list[url]].push(url);
    }
  }

  for (pr in MAP) {
    await fs.mkdir(pr, {recursive: true}, (err) => {
      if (err) throw err;
    })
    c = "module.exports =\n" + JSON.stringify(MAP[pr], null, 2);
    console.log(pr, JSON.stringify(MAP[pr]))
    await fs.writeFile(pr + "/mirrors.js", c, (err) => {
      if (err) throw err;
    });
  }

  fallback = []
  for (pr in MAP) {
    fallback = fallback.concat(MAP[pr])
  }
  c = "module.exports =\n" + JSON.stringify(fallback, null, 2);
  await fs.writeFile("mirrors.js", c, (err) => {
    if (err) throw err;
  });

}

generate()
