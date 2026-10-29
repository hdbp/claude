#!/usr/bin/env bash
# Restore skills/plugins/config from this repo onto a fresh machine. Idempotent; never overwrites
# credentials. Review the diff of settings.json / claude_desktop_config.json before copying them.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CC="$HOME/.claude"; AS="$HOME/Library/Application Support/Claude"
RS="rsync -a --exclude .DS_Store"

echo "== Claude Code skills / agents / hooks"
mkdir -p "$CC"
for d in skills agents hooks commands dev-mods; do
  [ -d "$REPO/claude-code/$d" ] && $RS "$REPO/claude-code/$d/" "$CC/$d/"
done
[ -f "$REPO/claude-code/CLAUDE.md" ] && cp -n "$REPO/claude-code/CLAUDE.md" "$CC/CLAUDE.md" || true
[ -d "$REPO/agents-shared" ] && $RS "$REPO/agents-shared/" "$HOME/.agents/"

echo "== locally developed plugins"
mkdir -p "$CC/plugins"
for p in "$REPO"/claude-code/plugins/local/*/; do
  [ -d "$p" ] || continue; n=$(basename "$p")
  $RS "$p" "$CC/plugins/$n/"
  claude plugin marketplace add "$CC/plugins/$n" 2>/dev/null || true
done

echo "== marketplaces + third-party plugins (from installed_plugins.json)"
python3 -c 'import json,sys
for k,v in json.load(open(sys.argv[1])).items():
    s=v.get("source",{}); s=s if isinstance(s,dict) else v
    if s.get("source")=="github": print(k, s["repo"])' "$REPO/claude-code/plugins/known_marketplaces.json" | while read -r name src; do
  claude plugin marketplace add "$src" 2>/dev/null || true
done
python3 -c 'import json,sys
for k in json.load(open(sys.argv[1]))["plugins"]: print(k)' "$REPO/claude-code/plugins/installed_plugins.json" | while read -r spec; do
  claude plugin install "$spec" 2>/dev/null || echo "   (manual) claude plugin install $spec"
done

echo "== configs (copied only if absent; otherwise diff and merge by hand)"
cp -n "$REPO/claude-code/settings.json" "$CC/settings.json" 2>/dev/null || echo "   ~/.claude/settings.json exists — diff: diff $REPO/claude-code/settings.json $CC/settings.json"
echo "   MCP servers for ~/.claude.json are in claude-code/mcp-servers.json (values marked <REDACTED> need re-entering)"
echo "   Claude Desktop: claude-desktop/claude_desktop_config.json → $AS/claude_desktop_config.json"
echo "   Claude Desktop extensions: reinstall from the directory; versions listed in claude-desktop/extensions-installations.json"
echo "   Claude (claude.ai) skills/plugins: claude-ai/synced — re-upload via Settings > Capabilities > Skills if not synced"
echo "done"
