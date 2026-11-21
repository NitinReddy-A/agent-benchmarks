# pilotfish MCP on GAIA Level 1 (15 tasks), through this harness

> Superseded by [`pilotfish-full-0.1.72/`](../pilotfish-full-0.1.72/): the full GAIA Level 1 (53) and AssistantBench (33) sets on pilotfish 0.1.72. This folder is the earlier 15-task subset on 0.1.71, kept as it was linked in the issue.

Run by the pilotfish team for lightpanda-io/agent-benchmarks#17. Both tools ran on the same machine, network, model,
harness and prompt, one after the other, never at once.

| | pilotfish | Lightpanda |
|---|---|---|
| Correct (15 tasks) | **13/15** | 10/15 |
| Correct, 12 tasks with no answer-key lookup by either run (see below) | **10/12** | 7/12 |
| Mean cost per task (the harness's `total_cost_usd`) | $0.15 | $0.20 |
| Mean time per task | 67 s | 101 s |
| Tool calls / model turns (all 15) | 54 / 132 | 61 / 144 |
| Timeouts (1,800 s) | 0 | 0 |

## Setup

- Harness: this repository at `b19572e`, plus the commit on this branch (`--backend pilotfish`). Runner `gaia-mcp-run`,
  `--model claude-sonnet-4-6 --workers 4 --timeout 1800`, attachments included as the runner inlines them.
- Agent: Claude Code 2.1.326 (`claude -p`), the harness's own system prompt, `--strict-mcp-config` and
  `--disallowed-tools` lockdown. Text-only tools, headless.
- pilotfish: `@gaiventures/pilotfish-mcp@0.1.71` (MIT). The run drove a local build of the commit that was published
  as 0.1.71, through `PILOTFISH_MCP_CLI`; `PILOTFISH_HEADLESS=1`. `browser_screenshot` and `browser_resume` are denied.
  No proxy, no CAPTCHA solving, no stealth: plain Chrome on the machine's own network.
- Lightpanda: 1.0.4 (official x86_64-linux release), run inside WSL2 on the same Windows machine, over stdio.
- Machine: Windows 11, a residential connection in India.
- Every tool call in every trace is an MCP tool of the backend under test (plus `ToolSearch`, which only loads their
  schemas): no shell, file or web tools.

## Tasks

GAIA `2023_level1` validation, in dataset order: the first 17 tasks, less 2 whose source pages do not load in a headless
browser from this network (`5d0080cb`, a University of Leicester journal PDF, and `72e110e7`, BASE search). The same 15
for both tools, listed in `task-ids.json`. This is a declared subset, not the full 53.

## Answer keys

With a web search tool, Claude sometimes searched for the benchmark's own answers (the GAIA task id, "GAIA benchmark",
copies of the dataset on GitHub or Hugging Face). It did so with both tools: pilotfish in `5cfb274c`, `a1e91b78` and
`cca530fc`, Lightpanda in `5cfb274c` and `cca530fc`. The second row of the table above leaves those 3 tasks out for both.
Worth a look for the harness as a whole, since any search tool can reach these copies.

## Per task

| Task | pilotfish | Lightpanda | Gold |
|---|---|---|---|
| `e1fc63a2` | ✓ 17 (61 s, $0.12) | ✗ 17000 (48 s, $0.19) | 17 |
| `8e867cd7` | ✓ 3 (61 s, $0.20) | ✓ 3 (40 s, $0.23) | 3 |
| `ec09fa32` | ✓ 3 (190 s, $0.20) | ✓ 3 (713 s, $0.81) | 3 |
| `a1e91b78` † | ✓ 3 (89 s, $0.33) | ✓ 3 (27 s, $0.08) | 3 |
| `46719c30` | ✗ A New Software Agent 'Learning' A… (104 s, $0.30) | ✗ A New Software Agent 'Learning' A… (241 s, $0.52) | Mapping Human Oriented Inform… |
| `4b6bb5f7` | ✓ THE CASTLE (39 s, $0.09) | ✗ INT. THE CASTLE - DAY (27 s, $0.08) | THE CASTLE |
| `cffe0e32` | ✓ Fred (29 s, $0.05) | ✓ Fred (39 s, $0.07) | Fred |
| `2d83110e` | ✗ API Error: Sonnet 4.6 can't help … (5 s, $0.02) | ✗ API Error: Sonnet 4.6 can't help … (5 s, $0.03) | Right |
| `5cfb274c` † | ✓ No (34 s, $0.08) | ✓ No (83 s, $0.21) | No |
| `27d5d136` | ✓ (¬A → B) ↔ (A ∨ ¬B) (26 s, $0.04) | ✓ (¬A → B) ↔ (A ∨ ¬B) (22 s, $0.05) | (¬A → B) ↔ (A ∨ ¬B) |
| `dc28cf18` | ✓ 2 (58 s, $0.07) | ✓ 2 (40 s, $0.06) | 2 |
| `b816bfce` | ✓ fluffy (35 s, $0.10) | ✓ fluffy (30 s, $0.10) | fluffy |
| `42576abe` | ✓ Maktay Mato Apple (16 s, $0.02) | ✓ Maktay Mato Apple (14 s, $0.03) | Maktay mato apple |
| `b415aba4` | ✓ diamond (239 s, $0.49) | ✗ crystalline diamond (109 s, $0.34) | diamond |
| `cca530fc` † | ✓ Rd5 (25 s, $0.06) | ✓ Rd5 (74 s, $0.24) | Rd5 |

† a run of either tool looked up the answer key in this task.

`2d83110e` (a reversed sentence) ends at once with "API Error: Sonnet 4.6 can't help with this" with both tools.

## Files

- `pilotfish/` and `lightpanda/`: the runner's `predictions.jsonl` (per task: prediction, gold, duration, trace of tool
  calls, usage), `scores.json` and `manifest.json`, as written; only the local path in front of the runner's name in
  `argv` is removed.
- `task-ids.json`: the 15 task ids, run with the branch's `BENCH_IDS` filter.
