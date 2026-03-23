#!/usr/bin/env bash
# make-openclaw-compatible.sh
# Adds _meta.json and version frontmatter to ECC-style skills for OpenClaw compatibility.
#
# Usage:
#   ./scripts/make-openclaw-compatible.sh <skills-dir>
#
# Example:
#   # Convert a cloned ECC repo
#   ./scripts/make-openclaw-compatible.sh /tmp/everything-claude-code/skills
#
#   # Convert this repo's own skills
#   ./scripts/make-openclaw-compatible.sh ./skills

set -euo pipefail

SKILLS_DIR="${1:-./skills}"
TIMESTAMP=$(node -e "console.log(Date.now())" 2>/dev/null || python3 -c "import time; print(int(time.time()*1000))")
MODIFIED=0
SKIPPED=0

if [ ! -d "$SKILLS_DIR" ]; then
  echo "Error: $SKILLS_DIR is not a directory" >&2
  exit 1
fi

echo "Processing skills in: $SKILLS_DIR"
echo ""

for skill_dir in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill_dir")
  skill_md="$skill_dir/SKILL.md"
  meta_json="$skill_dir/_meta.json"

  if [ ! -f "$skill_md" ]; then
    echo "  SKIP  $skill_name (no SKILL.md)"
    ((SKIPPED++)) || true
    continue
  fi

  # Add _meta.json if missing
  if [ ! -f "$meta_json" ]; then
    cat > "$meta_json" <<EOF
{
  "slug": "$skill_name",
  "version": "1.0.0",
  "publishedAt": $TIMESTAMP
}
EOF
    echo "  META  $skill_name → _meta.json created"
    ((MODIFIED++)) || true
  fi

  # Add version to SKILL.md frontmatter if missing
  if grep -q "^---" "$skill_md" && ! grep -q "^version:" "$skill_md"; then
    # Insert version after the first line (opening ---)
    if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i '' "1a\\
version: 1.0.0
" "$skill_md"
    else
      sed -i "0,/^---$/{ /^---$/{n; s/^/version: 1.0.0\n/} }" "$skill_md"
    fi
    echo "  VER   $skill_name → version added to frontmatter"
    ((MODIFIED++)) || true
  fi
done

echo ""
echo "Done. Modified: $MODIFIED skill(s), Skipped: $SKIPPED"
