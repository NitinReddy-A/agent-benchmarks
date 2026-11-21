#!/usr/bin/env bash
# The exact run behind this folder: full GAIA Level 1 (53) then AssistantBench (33), pilotfish from npm, Linux.
# Needs: uv, Node 22+ (npx), Google Chrome or Chromium, Claude Code signed in, and HF_TOKEN with GAIA access.
# Usage, from the repository root: HF_TOKEN=... bash pilotfish-full-0.1.72/run.sh [pilotfish-mcp version] [out dir]
set -u
VERSION="${1:-0.1.72}"
OUT="${2:-results/pilotfish-$VERSION}"
: "${HF_TOKEN:?set HF_TOKEN (GAIA is a gated dataset)}"
export PILOTFISH_MCP_PACKAGE="@gaiventures/pilotfish-mcp@$VERSION"
unset PILOTFISH_MCP_CLI
uv sync
mkdir -p "$OUT"
COMMON="--backend pilotfish --model claude-sonnet-4-6 --workers 4 --timeout 1800"
uv run gaia-mcp-run $COMMON --resume --out-dir "$OUT/gaia-l1" 2>&1 | tee "$OUT/gaia-l1.log"
uv run assistantbench-mcp-run $COMMON --resume --out-dir "$OUT/assistantbench" 2>&1 | tee "$OUT/assistantbench.log"
