addEventListener("fetch", event => {
    event.respondWith(handler(event.request));
});

async function handler(request) {
    let url = new URL(request.url)
    //console.log("href:", url.href)
    let origin = url.origin
    let match = origin.match(/mirrors\.(\w\w)\.cn/)
    let path = url.pathname
    try {
        let main = 'https://mirrors-cn.pages.dev'
        let upstream = main
        if (match !== null)
            upstream = main + '/' + match[1]
        response = await fetch(upstream + path, request);
        //console.log("req:", upstream + path);
        if ([301, 302, 303, 307, 308].includes(response.status)) {
            let target_path = (new URL(response.headers.get("Location"), main)).pathname;
            let proxied_path = target_path;
            if (match !== null)
                proxied_path = target_path.replace('/' + match[1], '')
            //console.log("302:", response.status, target_path, origin + proxied_path)
            return await Response.redirect(origin + proxied_path, 302)
        }
        return response;
    } catch (err) {
        return new Response(`bad request`, { status: 400 })
    }
}


