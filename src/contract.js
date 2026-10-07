/** Expected API OpenAPI info.version for this UI build. */
export const EXPECTED_API_CONTRACT = '1.1.0'

/** @param {{ id: string, title: string, status: string, priority?: string }} task */
export function renderTaskLine(task) {
  const p = task.priority ? ` priority=${task.priority}` : ''
  return `${task.title} [${task.status}]${p}`
}
