# pilotfish MCP 0.1.72: full GAIA Level 1 (53) and AssistantBench (33), through this harness

Run by the pilotfish team for lightpanda-io/agent-benchmarks#17, as asked there: the full validation sets, no task
exclusions, a published pilotfish release, Linux, text-only tools, headless. One run so far.

| Suite | Strict | Avg duration | Timeouts |
|---|---:|---:|---:|
| AssistantBench (33) | **72.7%** (24/33; soft 67.3%) | 429 s | 0 / 33 |
| AssistantBench, leaving out the 6 tasks with an answer-key lookup | **66.7%** (18/27) | 435 s | 0 / 27 |
| GAIA Level 1 (53) | **88.7%** (47/53) | 80 s | 0 / 53 |
| GAIA Level 1, leaving out the 9 tasks with an answer-key lookup | **86.4%** (38/44) | 76 s | 0 / 44 |

AssistantBench by difficulty: Medium 85.7% (12/14), Hard 63.2% (12/19).

The figures are the runners' own `scores.json` (`accuracy_strict` / `accuracy` and `avg_duration_s`); the "leaving out"
rows apply the same graders to the remaining tasks. Durations are this machine's and network's, so compare them with
care against runs made elsewhere.

## Setup

- Harness: this branch, `pilotfish-backend`: `lightpanda-io/main` plus `--backend pilotfish` (commit `862aa3b`, wired
  like browser-use). The runners `gaia-mcp-run` and `assistantbench-mcp-run`, `--model claude-sonnet-4-6 --workers 4
  --timeout 1800`, the harness's own system prompt, `--strict-mcp-config` and `--disallowed-tools` lockdown. Each
  folder's `manifest.json` has the exact argv.
- Agent: Claude Code 2.1.330 (`claude -p`, Claude Max sign-in, no API key).
- pilotfish: `@gaiventures/pilotfish-mcp@0.1.72` from npm (MIT), started by the harness through `npx`,
  `PILOTFISH_HEADLESS=1`. `browser_screenshot` and `browser_resume` are denied, so it is text-only and unattended. No
  proxy, no CAPTCHA solving, no stealth: plain Chrome on the machine's own network. `browser_search` is a web search
  API (Keenable's keyless endpoint, as Lightpanda's MCP `search` falls back to).
- Machine: Ubuntu 24.04 on WSL2 (kernel 6.6), Windows 11, Node 22, Google Chrome 158, a residential connection in India.
- GAIA attachments as the MCP runner handles them: the 3 XLSX, 1 DOCX, 1 PPTX, 1 TXT and 1 PY files are given as text;
  the 2 PNG and 2 MP3 files are skipped (`attachment_status` in each row).
- Every tool call in every trace is a pilotfish MCP tool (plus `ToolSearch`, which only loads their schemas): no
  shell, file or other web tools.

## Answer keys

With a web search tool Claude sometimes looked for the benchmark's own answers: the task id, "GAIA benchmark" or
"AssistantBench" in a query, or copies of the datasets and other agents' outputs on Hugging Face and GitHub. That
happened in 9 GAIA tasks (all 4 whose PNG or MP3 attachment the runner skips among them) and 6 AssistantBench tasks,
and all 15 ended correct. `answer-key-lookups.json` lists each task with the queries and addresses involved; the
second row of each suite above leaves those tasks out. Blocking those queries and hosts in the harness, as discussed
in the issue, would apply to every backend alike.

## Files

- `gaia-l1/` and `assistantbench/`: `predictions.jsonl` (every task's answer, gold, duration, usage and tool-call
  trace), `scores.json` and `manifest.json`, as the runners wrote them.
- `answer-key-lookups.json`: the tasks above and the calls that looked for answers.
- `run.sh`: the run itself, to repeat it.

## Running it yourself

From the root of this branch, with uv, Node 22+, Google Chrome or Chromium, Claude Code signed in and an `HF_TOKEN`
with access to GAIA:

```bash
git clone -b pilotfish-backend https://github.com/NitinReddy-A/agent-benchmarks.git
cd agent-benchmarks
HF_TOKEN=... bash pilotfish-full-0.1.72/run.sh 0.1.72 results/pilotfish-0.1.72
```

or the runners directly: `uv run gaia-mcp-run --backend pilotfish --model claude-sonnet-4-6 --workers 4 --timeout 1800`
(and `assistantbench-mcp-run`). The backend is pinned to `@gaiventures/pilotfish-mcp@0.1.72`; `PILOTFISH_MCP_PACKAGE`
picks another published version.
