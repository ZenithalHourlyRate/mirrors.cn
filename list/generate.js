const fs = require('fs');
const list = require('./meta');

MAP = {}

async function generate() {
  for (url in list) {
    let pr = "  ";
    if (url.startsWith("https"))
      pr = list[url][1]
    else
      pr = list[url]
    if (pr != "  ") {
      let c = null
      if (url.startsWith("https"))
        c = [url, list[url][0]]
      else
        c = url
      if (!(pr in MAP))
        MAP[pr] = [c];
      else
        MAP[pr].push(c);
    }
  }

  for (pr in MAP) {
    await fs.mkdir(pr, {recursive: true}, (err) => {
      if (err) throw err;
    })
    let j = {
      url: `https://mirrors.${pr}.cn`,
      display_legacy: `mirrors.${pr}.cn`,
      language: "zh",
      about: [
        "legacy",
      ],
      mirrors_legacy: [],
      mirrors: {},
    }
    for (c of MAP[pr]) {
      if (typeof(c) === "string")
        j.mirrors_legacy.push(c)
      else
        j.mirrors[c[0]] = c[1]
    }
    config = JSON.stringify(j, null, 2);
    console.log(pr, JSON.stringify(j))
    await fs.writeFile(pr + "/config.json", config, (err) => {
      if (err) throw err;
    });
  }

  fallback = []
  for (pr in MAP) {
    fallback = fallback.concat(MAP[pr])
  }
  let j = {
    url: `https://mirrors-cn.pages.dev`,
    display_legacy: `mirrors-cn.pages.dev`,
    language: "zh",
    about: [
      "legacy",
    ],
    mirrors_legacy: [],
    mirrors: {},
  }
  for (c of fallback) {
    if (typeof(c) === "string")
      j.mirrors_legacy.push(c)
    else
      j.mirrors[c[0]] = c[1]
  }
  config = JSON.stringify(j, null, 2);
  await fs.writeFile("config.json", config, (err) => {
    if (err) throw err;
  });

}

generate()
