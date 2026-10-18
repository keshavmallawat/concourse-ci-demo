# concourse-ci-demo

A small Node.js application used to demonstrate **Concourse CI** as a container-native, pipeline-as-code alternative to Jenkins.
Built for the DevOps (216U01E744) Theory IA-2 case study, KJSCE, Group 110.

## What the pipeline does

```
GitHub repo --(new commit)--> [ test ] --(passed)--> [ build-image ]
                               npm test               Docker image built
                               in node:20-alpine      with oci-build-task
```

* `test` runs the unit tests inside a fresh `node:20-alpine` container.
* `build-image` only runs when `test` passed (`passed: [test]`) and builds the `Dockerfile` into an image.
* A failing test turns `test` red and **blocks** `build-image`. This is the gate shown in the demo.

## Repository layout

| File | Purpose |
|---|---|
| `app.js` | Tiny HTTP app plus two functions (`add`, `greet`) |
| `app.test.js` | Unit tests using Node's built-in test runner (no dependencies) |
| `package.json` | `npm test` runs `node --test` |
| `Dockerfile` | Image built by the `build-image` job |
| `pipeline.yml` | The Concourse pipeline (resource + two jobs) |
| `scripts/` | PowerShell helpers for Windows (start, deploy, break/fix test, stop) |

## Prerequisites

* Docker Desktop (running)
* Node.js 18+ (only to run the tests locally)
* Git, and a **public** GitHub repository named `concourse-ci-demo` containing these files
* `fly` CLI, downloaded from the Concourse web UI (links at the bottom of http://localhost:8080)

## Run it (PowerShell, from this folder)

```powershell
npm test                                   # sanity check, should pass
.\scripts\start-concourse.ps1              # downloads official docker-compose.yml, starts Concourse
# open http://localhost:8080 (test / test), download fly.exe, put it on PATH
.\scripts\deploy-pipeline.ps1 -GithubUser <your-github-username>
```

Equivalent raw commands:

```bash
fly -t local login -c http://localhost:8080 -u test -p test
fly -t local set-pipeline -p demo -c pipeline.yml -v github_user=<your-github-username>
fly -t local unpause-pipeline -p demo
fly -t local trigger-job -j demo/test -w
```

## Demo scenario (failure and fix)

```powershell
.\scripts\break-test.ps1    # test fails, build-image is blocked (red)
.\scripts\fix-test.ps1      # test passes, build-image runs (green)
```

Concourse checks the repo every 30 s; the scripts also run `fly check-resource` to speed this up.

## Troubleshooting

| Symptom | Check |
|---|---|
| UI not reachable | `docker compose ps` in `concourse-runtime`, then `docker compose logs` |
| `build-image` fails to start | The task needs `privileged: true` and the quickstart worker is privileged; make sure Docker Desktop is using WSL2 |
| Pipeline never triggers | Repo must be public and branch must be `main`; run `fly -t local check-resource -r demo/repo` |
| Worker not registering | `fly -t local workers` should list one worker; restart with `docker compose restart` |
| Everything broken on Windows | Use GitHub Codespaces (Linux) and run the same commands there |

## Clean up

```powershell
.\scripts\stop-concourse.ps1
```
