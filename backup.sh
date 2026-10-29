#!/usr/bin/env bash
# Back up user-installed / user-developed Claude Code + Claude Desktop skills, plugins,
# extensions and config into this repo. Re-runnable: rsync --delete keeps the repo a mirror.
# Secrets: every JSON config is passed through redact.py; credential files are never copied.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CC="$HOME/.claude"
AS="$HOME/Library/Application Support/Claude"
RS="rsync -a --delete --exclude .DS_Store --exclude __pycache__ --exclude node_modules --exclude .git"
redact() { python3 "$REPO/redact.py" "$1" > "$2"; }

echo "== Claude Code (~/.claude)"
mkdir -p "$REPO/claude-code/plugins"
$RS --exclude synced "$CC/skills/"   "$REPO/claude-code/skills/"
$RS "$CC/agents/"                     "$REPO/claude-code/agents/"
$RS "$CC/hooks/"                      "$REPO/claude-code/hooks/"
[ -d "$CC/commands" ] && $RS "$CC/commands/" "$REPO/claude-code/commands/"
[ -d "$CC/dev-mods" ] && $RS "$CC/dev-mods/" "$REPO/claude-code/dev-mods/"
[ -f "$CC/CLAUDE.md" ] && cp "$CC/CLAUDE.md" "$REPO/claude-code/CLAUDE.md"
redact "$CC/settings.json"       "$REPO/claude-code/settings.json"
[ -f "$CC/settings.local.json" ] && redact "$CC/settings.local.json" "$REPO/claude-code/settings.local.json"
# user-scope + per-project MCP servers from ~/.claude.json (everything else in that file is app state)
python3 - "$HOME/.claude.json" <<'PY' | python3 "$REPO/redact.py" - > "$REPO/claude-code/mcp-servers.json"
import json, sys
d = json.load(open(sys.argv[1]))
out = {"mcpServers": d.get("mcpServers", {}),
       "projects": {p: {"mcpServers": v["mcpServers"]} for p, v in d.get("projects", {}).items() if v.get("mcpServers")}}
print(json.dumps(out, indent=2))
PY

echo "== Claude Code plugins"
for f in installed_plugins.json known_marketplaces.json config.json blocklist.json; do
  [ -f "$CC/plugins/$f" ] && redact "$CC/plugins/$f" "$REPO/claude-code/plugins/$f"
done
# locally developed plugin(s): marketplaces whose source is a local directory are copied in full
python3 -c 'import json,sys
for k,v in json.load(open(sys.argv[1])).items():
    s=v.get("source",{}); s=s if isinstance(s,dict) else v
    if s.get("source")=="directory": print(k, s["path"])' "$CC/plugins/known_marketplaces.json" | while read -r name path; do
  $RS "$path/" "$REPO/claude-code/plugins/local/$name/"
  find "$REPO/claude-code/plugins/local/$name" -name '*.json' | while read -r j; do redact "$j" "$j.tmp" && mv "$j.tmp" "$j"; done
done
# third-party plugins are NOT copied (reinstallable); restore.sh reinstalls them from installed_plugins.json

echo "== ~/.agents (shared skills dir)"
[ -d "$HOME/.agents" ] && $RS "$HOME/.agents/" "$REPO/agents-shared/"

echo "== Claude Desktop"
mkdir -p "$REPO/claude-desktop/extensions-settings" "$REPO/claude-desktop/extensions"
redact "$AS/claude_desktop_config.json" "$REPO/claude-desktop/claude_desktop_config.json"
redact "$AS/extensions-installations.json" "$REPO/claude-desktop/extensions-installations.json"
[ -f "$AS/mcp-user-tool-toggles.json" ] && redact "$AS/mcp-user-tool-toggles.json" "$REPO/claude-desktop/mcp-user-tool-toggles.json"
for j in "$AS/Claude Extensions Settings"/*.json; do redact "$j" "$REPO/claude-desktop/extensions-settings/$(basename "$j")"; done
# extensions: manifests only (the installed bundles are ~500 MB of node_modules and reinstall from the directory)
for e in "$AS/Claude Extensions"/*/; do
  n=$(basename "$e"); mkdir -p "$REPO/claude-desktop/extensions/$n"
  [ -f "$e/manifest.json" ] && cp "$e/manifest.json" "$REPO/claude-desktop/extensions/$n/manifest.json"
done
# claude.ai-synced skills & plugins (what you uploaded / installed in Claude), and Cowork scheduled tasks
$RS "$AS/local-agent-mode-sessions/skills-plugin/" "$REPO/claude-ai/synced/"
[ -d "$HOME/Claude/Scheduled" ] && $RS "$HOME/Claude/Scheduled/" "$REPO/claude-desktop/scheduled-tasks/"

echo "== leftover-secret scan"
if grep -rIEl '(sk-ant-[A-Za-z0-9_-]{20}|sk-[A-Za-z0-9]{32}|ghp_[A-Za-z0-9]{30}|github_pat_[A-Za-z0-9_]{30}|AKIA[0-9A-Z]{16}|xox[abp]-[0-9A-Za-z-]{20})' "$REPO" --exclude-dir=.git; then
  echo "!! possible secrets above — fix before pushing"; exit 1
fi
date -u +"%Y-%m-%dT%H:%M:%SZ" > "$REPO/.last-backup"
echo "done: $(du -sh "$REPO" --exclude=.git 2>/dev/null | cut -f1)"
