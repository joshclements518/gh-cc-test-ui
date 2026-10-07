import { createServer } from 'node:http'
import { fetchTasks } from './client.js'
import { renderTaskLine } from './contract.js'

const port = Number(process.env.PORT || 3000)
const api = process.env.API_BASE_URL || 'http://127.0.0.1:4000'

const server = createServer(async (req, res) => {
  const url = new URL(req.url ?? '/', 'http://localhost')
  if (req.method === 'GET' && (url.pathname === '/' || url.pathname === '/tasks')) {
    try {
      const tasks = await fetchTasks(api)
      const body = `<!doctype html><html><body><h1>Accel Tasks</h1><ul>${tasks
        .map((t) => `<li>${renderTaskLine(t)}</li>`)
        .join('')}</ul></body></html>`
      res.writeHead(200, { 'content-type': 'text/html; charset=utf-8' })
      res.end(body)
    } catch (err) {
      res.writeHead(502, { 'content-type': 'text/plain' })
      res.end(String(err))
    }
    return
  }
  if (req.method === 'GET' && url.pathname === '/healthz') {
    res.writeHead(200, { 'content-type': 'application/json' })
    res.end(JSON.stringify({ ok: true }))
    return
  }
  res.writeHead(404)
  res.end('not found')
})

server.listen(port, () => console.log(`accel-ui on :${port} api=${api}`))
