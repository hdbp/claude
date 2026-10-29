# claude — backup of my Claude Code + Claude Desktop setup

Mirror of everything user-installed or user-developed across Claude Code and the Claude desktop app.
Run `./backup.sh` to refresh (rsync `--delete`, so the repo always reflects the current machine),
then commit. `./restore.sh` rebuilds the setup on a fresh Mac.

| Path | Source on disk | What |
|---|---|---|
| `claude-code/skills/` | `~/.claude/skills/` | user skills (art_*_writing, ena/geo-database, h1nucratio-local, paperclip, reverse-engineer-anything, scientific-visualization, scikit-bio) |
| `claude-code/agents/`, `hooks/`, `dev-mods/` | `~/.claude/{agents,hooks,dev-mods}/` | custom subagents, hook scripts, mods |
| `claude-code/settings*.json` | `~/.claude/settings*.json` | permissions, hooks, enabled plugins, model, theme |
| `claude-code/mcp-servers.json` | `~/.claude.json` (mcpServers + per-project mcpServers only) | user-scope and project MCP servers |
| `claude-code/plugins/*.json` | `~/.claude/plugins/` | installed_plugins / known_marketplaces / config / blocklist — enough for `restore.sh` to reinstall every third-party plugin |
| `claude-code/plugins/local/` | local-directory marketplaces (`mcpmarket-my-toolkit`) | my own plugin, copied in full |
| `agents-shared/` | `~/.agents/` | skills/plugins shared with other agents (Codex etc.) |
| `claude-desktop/claude_desktop_config.json` | `~/Library/Application Support/Claude/` | desktop MCP servers |
| `claude-desktop/extensions/*/manifest.json` + `extensions-installations.json` | `…/Claude Extensions/` | installed desktop extensions (manifests + versions; bundles reinstall from the directory) |
| `claude-desktop/extensions-settings/` | `…/Claude Extensions Settings/` | per-extension config |
| `claude-desktop/scheduled-tasks/` | `~/Claude/Scheduled/` | Cowork scheduled tasks |
| `claude-ai/synced/` | `…/local-agent-mode-sessions/skills-plugin/` | skills + plugins synced down from claude.ai |

**Not backed up on purpose:** third-party plugin caches (`~/.claude/plugins/cache`, ~90 MB, reproducible),
extension bundles (~500 MB of node_modules), sessions / history / projects / telemetry, and every credential
file (`~/.claude/.credentials.json`, OAuth state in `~/.claude.json`, keychain items).

**Secrets:** every JSON file goes through `redact.py`, which blanks values under key names like
`*key*`, `*token*`, `*secret*`, `*password*`, `Authorization`, and anything shaped like an API key.
`backup.sh` refuses to finish if a key-shaped string survives. Redacted values must be re-entered after
`restore.sh`. This repo is public, so keep it that way — do not commit un-redacted files.
