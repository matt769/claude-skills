# claude-skills

A personal marketplace of Claude Code plugins, shared across projects and machines.

## Structure

```
.claude-plugin/
  marketplace.json           # lists every plugin in this repo
plugins/
  toolkit/                   # one plugin
    .claude-plugin/
      plugin.json            # name, version, description
    agents/
      build-runner.md
      test-runner.md
    skills/
      deep-question/SKILL.md
      handoff/SKILL.md
      orchestrate/SKILL.md
    scripts/
      statusline.sh
```

Add a plugin by creating a directory under `plugins/` with its own `.claude-plugin/plugin.json`, then registering it in `.claude-plugin/marketplace.json`.

## Usage

Add this repo as a marketplace (GitHub path or local directory), then install the plugin:

```
/plugin marketplace add matt769/claude-skills
/plugin marketplace add /path/to/claude-skills     # local alternative
/plugin install toolkit@claude-skills
```

After pushing changes:

```
/plugin marketplace update claude-skills
```

## The `toolkit` plugin

### Skills

| Skill | Invocation | Purpose |
| --- | --- | --- |
| `deep-question` | Manual only (`/toolkit:deep-question`) | Interviews you about a plan or idea in rounds, walking a design tree until understanding is shared. |
| `handoff` | Manual only (`/toolkit:handoff`) | Writes a summary of the current work to a file so a fresh agent can continue. |
| `orchestrate` | Manual or automatic | Executes a plan by dispatching subagents per step, with a final build/test and documentation sweep. |

### Agents

| Agent | Purpose |
| --- | --- |
| `build-runner` | Runs build commands with large output, logs to a file, and reports root-cause errors and warnings. Diagnoses only. |
| `test-runner` | Builds and runs tests, logs to files, and reports pass/fail with failing assertions grouped by cause. Diagnoses only. |

### Status line

Plugins cannot set `statusLine`; it is a user/project `settings.json` setting. Copy the script somewhere stable and point settings at it:

```
cp plugins/toolkit/scripts/statusline.sh ~/.claude/statusline.sh
```

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statusline.sh"
  }
}
```

It shows the working directory, git branch, model, context usage, and 5-hour / 7-day rate limits (with time to reset above 70%).

Requirements: `bash`, `jq`, `git`.

## References

`deep-question` is largely based on https://github.com/mattpocock/skills/blob/main/skills/productivity/grilling/SKILL.md
