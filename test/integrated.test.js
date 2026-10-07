import { describe, it } from 'node:test'
import assert from 'node:assert/strict'
import { EXPECTED_API_CONTRACT } from '../src/contract.js'

/**
 * Integrated check (no live network in CI): UI contract pin must stay in lockstep
 * with the documented API OpenAPI version for Project A acceptance.
 * Live runner additionally boots both servers.
 */
describe('integrated-ui-api', () => {
  it('documents current combination contract', () => {
    assert.match(EXPECTED_API_CONTRACT, /^\d+\.\d+\.\d+$/)
  })
})
