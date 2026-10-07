import { EXPECTED_API_CONTRACT } from './contract.js'

/**
 * @param {string} baseUrl
 * @param {typeof fetch} [fetchImpl]
 */
export async function fetchTasks(baseUrl, fetchImpl = fetch) {
  const res = await fetchImpl(`${baseUrl.replace(/\/$/, '')}/tasks`)
  if (!res.ok) throw new Error(`tasks ${res.status}`)
  return /** @type {Promise<Array<{id:string,title:string,status:string,priority?:string}>>} */ (
    res.json()
  )
}

/**
 * @param {string} baseUrl
 * @param {typeof fetch} [fetchImpl]
 */
export async function assertApiContract(baseUrl, fetchImpl = fetch) {
  const res = await fetchImpl(`${baseUrl.replace(/\/$/, '')}/healthz`)
  if (!res.ok) throw new Error(`healthz ${res.status}`)
  const body = /** @type {{ contract?: string }} */ (await res.json())
  if (body.contract !== EXPECTED_API_CONTRACT) {
    throw new Error(`contract mismatch: ui expects ${EXPECTED_API_CONTRACT}, api has ${body.contract}`)
  }
  return body.contract
}
