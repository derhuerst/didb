'use strict'

const ajax = function (method, url, data, cb) {
	if (arguments.length < 4) { cb = data; data = null }
	let r = new XMLHttpRequest()
	r.addEventListener('error', () =>
		cb(new Error(`Request to ${method} ${url} failed.`)))
	r.addEventListener('abort', (e) =>
		cb(new Error(`Request to ${method} ${url} aborted.`)))
	r.addEventListener('load', () => cb())
	r.open(method, url, true)
	if (data) r.send(data)
	else r.send()
}

const deleteTag = (id, cb) => ajax('DELETE', '/tags/' + id, cb)
const deleteDoc = (id, cb) => ajax('DELETE', '/documents/' + id, cb)

const updateDoc = (id, data, cb) => ajax('PATCH', '/documents/' + id, data, cb)
