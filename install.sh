#!/usr/bin/env bash
# Install a skill or skill bundle from SoheilOlia/skills.
# Usage:
#   curl -sL https://raw.githubusercontent.com/SoheilOlia/skills/main/install.sh | bash -s boil_ocean
#   curl -sL https://raw.githubusercontent.com/SoheilOlia/skills/main/install.sh | bash -s soho
#   curl -sL https://raw.githubusercontent.com/SoheilOlia/skills/main/install.sh | bash -s claude-check

set -euo pipefail

SKILL_PATH="${1:?Usage: install.sh <skill-path> (for example: boil_ocean, claude-check, or soho)}"
REPO_URL="${REPO_URL:-https://github.com/SoheilOlia/skills.git}"
TMP_DIR="$(mktemp -d)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

skill_name() {
  local skill_dir="$1"
  awk -F': *' '/^name:/{gsub(/"/, "", $2); print $2; exit}' "$skill_dir/SKILL.md"
}

fallback_install() {
  local skill_dir="$1"
  local name="$2"
  local agents_dir="${HOME}/.agents/skills"
  local claude_dir="${HOME}/.claude/skills"
  local codex_dir="${HOME}/.codex/skills"
  local cursor_dir="${HOME}/.cursor/skills"

  mkdir -p "$agents_dir" "$claude_dir" "$codex_dir" "$cursor_dir"
  rm -rf "${agents_dir}/${name}"
  cp -R "$skill_dir" "${agents_dir}/${name}"
  ln -sfn "${agents_dir}/${name}" "${claude_dir}/${name}"
  ln -sfn "${agents_dir}/${name}" "${codex_dir}/${name}"
  ln -sfn "${agents_dir}/${name}" "${cursor_dir}/${name}"
}

link_skill_aliases() {
  local installed_name="$1"
  local canonical_name="$2"
  local agents_dir="${HOME}/.agents/skills"
  local claude_dir="${HOME}/.claude/skills"
  local codex_dir="${HOME}/.codex/skills"
  local cursor_dir="${HOME}/.cursor/skills"
  local source_name
  local alias_name

  if [[ "$installed_name" == "$canonical_name" ]]; then
    return
  fi

  if [[ -e "${agents_dir}/${canonical_name}" ]]; then
    mkdir -p "$claude_dir" "$codex_dir" "$cursor_dir"
    source_name="$canonical_name"
    alias_name="$installed_name"
  elif [[ -e "${agents_dir}/${installed_name}" ]]; then
    mkdir -p "$claude_dir" "$codex_dir" "$cursor_dir"
    source_name="$installed_name"
    alias_name="$canonical_name"
  else
    return
  fi

  rm -rf "${agents_dir:?}/${alias_name}" "${claude_dir:?}/${alias_name}" "${codex_dir:?}/${alias_name}" "${cursor_dir:?}/${alias_name}"
  ln -sfn "${agents_dir}/${source_name}" "${agents_dir}/${alias_name}"
  ln -sfn "${agents_dir}/${source_name}" "${claude_dir}/${alias_name}"
  ln -sfn "${agents_dir}/${source_name}" "${codex_dir}/${alias_name}"
  ln -sfn "${agents_dir}/${source_name}" "${cursor_dir}/${alias_name}"
}

install_command_shims() {
  local skill_dir="$1"
  local name="$2"
  local claude_commands_dir="${HOME}/.claude/commands"
  local cursor_commands_dir="${HOME}/.cursor/commands"

  if [[ -d "${skill_dir}/claude-code" ]]; then
    mkdir -p "$claude_commands_dir"
    for command_file in "${skill_dir}"/claude-code/*.md; do
      [[ -f "$command_file" ]] || continue
      cp "$command_file" "${claude_commands_dir}/$(basename "$command_file")"
    done
  fi

  if [[ -d "${skill_dir}/cursor" ]]; then
    mkdir -p "$cursor_commands_dir"
    for command_file in "${skill_dir}"/cursor/*.md; do
      [[ -f "$command_file" ]] || continue
      cp "$command_file" "${cursor_commands_dir}/$(basename "$command_file")"
    done
  fi
}

install_one() {
  local skill_dir="$1"
  local name
  local folder_name
  folder_name="$(basename "$skill_dir")"
  name="$(skill_name "$skill_dir")"

  if [[ -z "$name" ]]; then
    echo "Could not read skill name from ${skill_dir}/SKILL.md" >&2
    exit 1
  fi

  if [[ "${SKILLS_INSTALL_USE_SQ:-1}" == "1" ]] && command -v sq >/dev/null 2>&1 && sq agents skills --help >/dev/null 2>&1; then
    sq agents skills add "$skill_dir"
  else
    fallback_install "$skill_dir" "$name"
    echo "Installed skill '${name}' globally"
  fi

  link_skill_aliases "$folder_name" "$name"
  install_command_shims "$skill_dir" "$name"

  if [[ "${SKILLS_INSTALL_USE_AMP:-1}" == "1" ]] && command -v amp >/dev/null 2>&1; then
    amp skill add "$skill_dir" --global >/dev/null 2>&1 || true
  fi
}

git clone --depth 1 "$REPO_URL" "$TMP_DIR" >/dev/null 2>&1

TARGET="${TMP_DIR}/${SKILL_PATH}"

if [[ -f "${TARGET}/SKILL.md" ]]; then
  install_one "$TARGET"
elif [[ -d "${TARGET}/skills" ]]; then
  found=0
  for skill_dir in "${TARGET}"/skills/*; do
    if [[ -d "$skill_dir" && -f "${skill_dir}/SKILL.md" ]]; then
      install_one "$skill_dir"
      found=1
    fi
  done
  if [[ "$found" -eq 0 ]]; then
    echo "No installable skills found under ${SKILL_PATH}/skills" >&2
    exit 1
  fi
else
  echo "No installable skill or bundle found at '${SKILL_PATH}'" >&2
  exit 1
fi

echo "Installed ${SKILL_PATH}"
