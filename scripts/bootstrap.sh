#!/usr/bin/env bash
#
# workbuddy-config/bootstrap.sh
# Symlink shared configs into ~/.workbuddy/
# Run from the workbuddy-config repo root.
#

set -e

WORKBUDDY_DIR="$HOME/.workbuddy"
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== WorkBuddy Config Bootstrap ==="
echo "Repo: $REPO_DIR"
echo "Target: $WORKBUDDY_DIR"
echo

# Skills
echo "[1/3] Linking skills..."
SKILLS_TARGET="$WORKBUDDY_DIR/skills"
mkdir -p "$SKILLS_TARGET"
for skill in "$REPO_DIR/skills"/*; do
  if [ -d "$skill" ]; then
    NAME=$(basename "$skill")
    DEST="$SKILLS_TARGET/$NAME"
    if [ -L "$DEST" ]; then
      echo "  skip: $NAME (already symlinked)"
    elif [ -d "$DEST" ]; then
      echo "  skip: $NAME (already exists — manual merge needed)"
    else
      ln -s "$skill" "$DEST"
      echo "  linked: $NAME"
    fi
  fi
done

# Connectors
echo "[2/3] Linking connectors..."
CONNECTORS_TARGET="$WORKBUDDY_DIR/connectors-marketplace/connectors"
mkdir -p "$CONNECTORS_TARGET"
for conn in "$REPO_DIR/connectors"/*; do
  if [ -d "$conn" ]; then
    NAME=$(basename "$conn")
    DEST="$CONNECTORS_TARGET/$NAME"
    if [ -L "$DEST" ]; then
      echo "  skip: $NAME (already symlinked)"
    elif [ -d "$DEST" ]; then
      echo "  skip: $NAME (already exists — manual merge needed)"
    else
      ln -s "$conn" "$DEST"
      echo "  linked: $NAME"
    fi
  fi
done

# MCP reference
echo "[3/3] MCP config..."
MCP_TARGET="$WORKBUDDY_DIR/.mcp.shared-reference.json"
if [ -f "$REPO_DIR/mcp.json" ]; then
  cp "$REPO_DIR/mcp.json" "$MCP_TARGET"
  echo "  copied: mcp.json → ~/.workbuddy/.mcp.shared-reference.json"
  echo "  (copy this to ~/.workbuddy/.mcp.json and edit as needed)"
fi

echo
echo "=== Done ==="
echo "Restart WorkBuddy to pick up new skills and connectors."
