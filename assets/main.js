'use strict'

const ajax = function (method, url, cb) {
	let r = new XMLHttpRequest()
	r.addEventListener('error', () =>
		cb(new Error(`Request to ${method} ${url} failed.`)))
	r.addEventListener('abort', (e) =>
		cb(new Error(`Request to ${method} ${url} aborted.`)))
	r.addEventListener('load', () => cb())
	r.open(method, url)
	r.send()
}

const deleteTag = (id, cb) => ajax('delete', '/tags/' + id, cb)
const deleteDoc = (id, cb) => ajax('delete', '/documents/' + id, cb)
