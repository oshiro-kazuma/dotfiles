#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract information from JSON
model_name=$(echo "$input" | jq -r '.model.display_name')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
output_style=$(echo "$input" | jq -r '.output_style.name')

# Get project name from project directory
project_name=$(basename "$project_dir")

# Get relative path from project root
if [[ "$current_dir" == "$project_dir" ]]; then
    rel_path="."
else
    rel_path=${current_dir#"$project_dir/"}
fi

# Get git information (skip locks for reliability)
git_branch=""
git_status=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

    # Check for uncommitted changes
    if ! git diff --quiet 2>/dev/null || ! git diff --staged --quiet 2>/dev/null; then
        git_status="*"
    fi

    # Check for untracked files
    if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
        git_status="${git_status}+"
    fi
fi

# Get account info (cached for 5 minutes, per-config to prevent cross-account contamination)
active_config_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
config_key=$(basename "$active_config_dir")
# Derive a human-readable profile name: strip leading dot and "claude-" prefix
# e.g. ".claude-oshiro" -> "oshiro", ".claude" -> ""
profile_name=$(echo "$config_key" | sed 's/^\.//' | sed 's/^claude-//' | sed 's/^claude$//')

auth_cache="/tmp/claude-auth-cache-${config_key}"
if [ ! -f "$auth_cache" ] || [ $(($(date +%s) - $(stat -f %m "$auth_cache" 2>/dev/null || echo 0))) -gt 300 ]; then
    tmp=$(mktemp "${auth_cache}.XXXXXX")
    if CLAUDE_CONFIG_DIR="$active_config_dir" claude auth status 2>/dev/null > "$tmp" && jq -e '.email' "$tmp" >/dev/null 2>&1; then
        mv "$tmp" "$auth_cache"
    else
        rm -f "$tmp"
    fi
fi
auth_email=$(jq -r '.email // ""' "$auth_cache" 2>/dev/null)
auth_org=$(jq -r '.orgName // ""' "$auth_cache" 2>/dev/null)

# Detect Telemetry/OTEL env vars in the process tree (cached per-PPID).
# Claude Code masks these for its subprocesses, but the upstream value
# may still be set on the parent — we want a persistent visual reminder.
otel_warn=""
otel_cache="/tmp/claude-otel-check-${PPID}"
if [ ! -f "$otel_cache" ]; then
    OTEL_RE='(CLAUDE_CODE_ENABLE_TELEMETRY|OTEL_METRICS_EXPORTER|OTEL_LOGS_EXPORTER|OTEL_TRACES_EXPORTER|OTEL_EXPORTER_OTLP_PROTOCOL|OTEL_EXPORTER_OTLP_ENDPOINT|OTEL_EXPORTER_OTLP_HEADERS|OTEL_LOG_USER_PROMPTS|OTEL_LOG_TOOL_DETAILS|OTEL_LOG_TOOL_CONTENT)'
    pid=$PPID
    hits=""
    for _ in 1 2 3 4; do
        [ -z "$pid" ] && break
        [ "$pid" -le 1 ] && break
        line=$(ps eww -o command= -p "$pid" 2>/dev/null) || break
        match=$(printf '%s' "$line" | grep -oE "${OTEL_RE}=[^[:space:]]+" || true)
        [ -n "$match" ] && hits="$hits$match"$'\n'
        pid=$(ps -o ppid= -p "$pid" 2>/dev/null | tr -d ' ')
    done
    printf '%s' "$hits" | sort -u | grep -v '^$' > "$otel_cache" 2>/dev/null || true
fi
if [ -s "$otel_cache" ]; then
    otel_count=$(wc -l < "$otel_cache" | tr -d ' ')
    otel_warn="$(printf '\033[41;97m') ⚠ OTEL:${otel_count} $(printf '\033[0m') "
fi

# Build status line with colors (using printf for ANSI codes)
status_line="${otel_warn}"

# Account info in magenta (with profile name prefix if not default)
if [[ -n "$auth_email" ]]; then
    if [[ -n "$profile_name" ]]; then
        status_line="${status_line}$(printf '\033[33m')[${profile_name}]$(printf '\033[0m') "
    fi
    status_line="${status_line}$(printf '\033[35m')${auth_email}$(printf '\033[0m')"
    if [[ -n "$auth_org" ]]; then
        status_line="${status_line}$(printf '\033[35m') @ ${auth_org}$(printf '\033[0m')"
    fi
    status_line="${status_line} "
fi

# Project name in cyan
status_line="${status_line}$(printf '\033[36m')${project_name}$(printf '\033[0m')"

# Current directory in blue
status_line="${status_line} $(printf '\033[34m')${rel_path}$(printf '\033[0m')"

# Git info in yellow/red
if [[ -n "$git_branch" ]]; then
    if [[ -n "$git_status" ]]; then
        status_line="${status_line} $(printf '\033[31m')${git_branch}${git_status}$(printf '\033[0m')"
    else
        status_line="${status_line} $(printf '\033[33m')${git_branch}$(printf '\033[0m')"
    fi
fi

# Model and output style in green
status_line="${status_line} $(printf '\033[32m')${model_name}$(printf '\033[0m')"
if [[ "$output_style" != "default" && -n "$output_style" ]]; then
    status_line="${status_line} $(printf '\033[32m')[${output_style}]$(printf '\033[0m')"
fi

echo "$status_line"
