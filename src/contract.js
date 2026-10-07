/** Expected API OpenAPI info.version for this UI build. */
export const EXPECTED_API_CONTRACT = '1.0.0'

/** @param {{ id: string, title: string, status: string, priority?: string }} task */
export function renderTaskLine(task) {
  // Baseline UI has no priority badge (Project A adds it when contract is 1.1.0).
  return `${task.title} [${task.status}]`
}
