addEventListener("fetch", event => {
    event.respondWith(handler(event.request));
});

async function handler(request) {
		let url = new URL(request.url)
    let host = url.host
		let match = host.match(/mirrors\.(\w\w)\.cn/)
    let path = url.pathname
    try {
				upstream = 'https://mirrors-cn.pages.dev'
				if (match !== null)
					upstream = upstream + '/' + match[1]
        return await fetch(upstream + path, request);
    } catch (err) {
        return new Response(`bad request`, { status: 400 })
    }
}

