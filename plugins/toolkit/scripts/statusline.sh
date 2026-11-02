#!/usr/bin/env bash
input=$(cat)

BLUE=$'\033[01;34m'
GREEN=$'\033[0;32m'
RED=$'\033[0;31m'
PURPLE=$'\033[0;35m'
CYAN=$'\033[0;36m'
YELLOW=$'\033[0;33m'
RESET=$'\033[0m'

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // .model // empty')
ctx=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
rl5=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rl5_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
rl7=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
rl7_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

branch=$(git -C "$cwd" branch --show-current 2>/dev/null)

reset_str() {
    local pct=$1 reset_at=$2
    local now diff h m
    pct=${pct%.*}
    reset_at=${reset_at%.*}
    [ -n "$pct" ] && [ -n "$reset_at" ] || return 0
    now=$(date +%s)
    diff=$(( reset_at - now ))
    if [ "$pct" -gt 70 ] && [ "$diff" -gt 0 ]; then
        h=$(( diff / 3600 ))
        m=$(( (diff % 3600) / 60 ))
        printf " (reset %dh%dm)" "$h" "$m"
    fi
}

rl5_extra=$(reset_str "$rl5" "$rl5_reset")
rl7_extra=$(reset_str "$rl7" "$rl7_reset")

out="${BLUE}${cwd}${RESET}"
[ -n "$branch" ] && out+="${GREEN}(${branch})${RESET}"
out+=" | ${RED}${model}${RESET}"
[ -n "$ctx" ] && out+=" (${PURPLE}${ctx%.*}%${RESET})"
[ -n "$rl5" ] && out+=" | 5h: ${CYAN}${rl5%.*}%${rl5_extra}${RESET}"
[ -n "$rl7" ] && out+=" | 7d: ${YELLOW}${rl7%.*}%${rl7_extra}${RESET}"

printf "%s" "$out"
