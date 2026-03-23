---
name: install-ecc-skill
version: 1.0.0
description: >-
  Install any skill from LobsterFarm/everything-claude-code into the local
  OpenClaw workspace. Lists available skills, fetches the selected one, and
  places it in ~/.openclaw/workspace/skills/. TRIGGER when user asks to install
  an ECC skill, browse available skills, or says "install skill <name>".
origin: lobsterfarm
---

# Install ECC Skill

Install skills from `LobsterFarm/everything-claude-code` into the local OpenClaw workspace.

## When to Activate

- User says "install skill <name>"
- User asks "what ECC skills are available?"
- User asks to browse or search available skills
- User wants to add a skill to the running OpenClaw instance

## Step 1: Get a GitHub Token

```bash
TOKEN=$(node /home/ec2-user/.openclaw/credentials/github-token.js)
```

If this fails, stop and tell the user: "GitHub token unavailable — check ~/.openclaw/credentials/github-token.js"

## Step 2: List Available Skills (if no skill name given)

```bash
TOKEN=$(node /home/ec2-user/.openclaw/credentials/github-token.js)
curl -s \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/LobsterFarm/everything-claude-code/contents/skills" \
  | jq -r '.[].name' | sort
```

Present the list to the user. Ask which skill(s) they want to install.

## Step 3: Check if Already Installed

```bash
SKILL_NAME="<skill-name>"
INSTALL_DIR="$HOME/.openclaw/workspace/skills/$SKILL_NAME"

if [ -d "$INSTALL_DIR" ]; then
  echo "Already installed: $INSTALL_DIR"
fi
```

If already installed, ask the user if they want to update it.

## Step 4: Fetch and Install the Skill

```bash
TOKEN=$(node /home/ec2-user/.openclaw/credentials/github-token.js)
SKILL_NAME="<skill-name>"
INSTALL_DIR="$HOME/.openclaw/workspace/skills/$SKILL_NAME"
TMP_DIR="/tmp/ecc-skill-$SKILL_NAME"
ECC_REPO="LobsterFarm/everything-claude-code"

# Fetch skill file list
FILES=$(curl -s \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/$ECC_REPO/contents/skills/$SKILL_NAME" \
  | jq -r '.[] | select(.type=="file") | .name')

mkdir -p "$INSTALL_DIR"

# Download each file
for FILE in $FILES; do
  curl -s \
    -H "Authorization: Bearer $TOKEN" \
    -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/$ECC_REPO/contents/skills/$SKILL_NAME/$FILE" \
    | jq -r '.content' | base64 -d > "$INSTALL_DIR/$FILE"
  echo "  Downloaded: $FILE"
done
```

Note: Only top-level files are fetched (SKILL.md, _meta.json, config.json). Subdirectories (hooks/, agents/, scripts/) are Claude Code-specific and skipped.

## Step 5: Verify

```bash
SKILL_NAME="<skill-name>"
INSTALL_DIR="$HOME/.openclaw/workspace/skills/$SKILL_NAME"

echo "Installed files:"
ls -la "$INSTALL_DIR"

echo ""
echo "SKILL.md frontmatter:"
head -8 "$INSTALL_DIR/SKILL.md"
```

## Step 6: Confirm to User

Report:
- Skill name and install path
- Files installed
- How to activate it (tell the agent to load the skill by name)

```
Installed: api-design → ~/.openclaw/workspace/skills/api-design
Files: SKILL.md, _meta.json
To activate: tell the agent to load skill "api-design"
```

## Installing Multiple Skills

If the user wants to install several at once, repeat Steps 3–5 for each skill name.

Recommended bundle for spend-tracker development:
- `api-design`
- `backend-patterns`
- `deployment-patterns`
- `architecture-decision-records`
- `verification-loop`
- `tdd-workflow`
- `security-review`
