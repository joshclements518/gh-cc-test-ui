import { describe, it } from 'node:test'
import assert from 'node:assert/strict'
import { EXPECTED_API_CONTRACT, renderTaskLine } from '../src/contract.js'
import { assertApiContract, fetchTasks } from '../src/client.js'

describe('ui-unit', () => {
  it('pins expected API contract', () => {
    assert.equal(EXPECTED_API_CONTRACT, '1.1.0')
  })

  it('renders baseline task line without priority', () => {
    assert.equal(renderTaskLine({ id: '1', title: 'A', status: 'open', priority: 'high' }), 'A [open] priority=high')
  })

  it('fetchTasks parses JSON', async () => {
    const tasks = await fetchTasks('http://example', async () => ({
      ok: true,
      json: async () => [{ id: '1', title: 'A', status: 'open' }],
    }))
    assert.equal(tasks[0].title, 'A')
  })

  it('assertApiContract checks version', async () => {
    const v = await assertApiContract('http://example', async () => ({
      ok: true,
      json: async () => ({ ok: true, contract: '1.1.0' }),
    }))
    assert.equal(v, '1.1.0')
  })
})
