# gh-cc-test-ui

Synthetic **UI** reference app for the Ash accelerator feature journey (Increment A).

Calls the Accel Tasks API (`API_BASE_URL`, default `http://127.0.0.1:4000`) and renders a task list.
Contract consumer: `src/contract.js` pins the expected OpenAPI version from the API repo.
