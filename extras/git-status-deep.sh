#!/usr/bin/env bash
# git-status-deep.sh — Enhanced git repository status with remote comparison
# written by Claude 4.6, 2026-05-22

set -euo pipefail

# ── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

header()  { echo -e "\n${BOLD}${CYAN}══ $* ══${RESET}"; }
info()    { echo -e "  ${GREEN}✔${RESET}  $*"; }
warn()    { echo -e "  ${YELLOW}⚠${RESET}  $*"; }
err()     { echo -e "  ${RED}✘${RESET}  $*"; }
detail()  { echo -e "  ${DIM}$*${RESET}"; }

# ── 1. Find the repo root (walk up from CWD) ────────────────────────────────
find_git_root() {
    local dir="${PWD}"
    while [[ "${dir}" != "/" ]]; do
        if [[ -d "${dir}/.git" ]]; then
            echo "${dir}"
            return 0
        fi
        dir="$(dirname "${dir}")"
    done
    return 1
}

header "Locating repository"

if ! GIT_ROOT=$(find_git_root); then
    err "No .git directory found in '${PWD}' or any parent directory."
    exit 1
fi

info "Repository root: ${GIT_ROOT}"
cd "${GIT_ROOT}"

# ── 2. Basic git status ──────────────────────────────────────────────────────
header "Working tree status"
git_status=$(git status --short 2>&1)

if [[ -z "${git_status}" ]]; then
    info "Working tree is clean — nothing to commit."
else
    echo "${git_status}" | while IFS= read -r line; do
        detail "${line}"
    done
fi

# Count staged / unstaged / untracked
staged=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
unstaged=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')

echo
[[ "${staged}"    -gt 0 ]] && warn "${staged} staged file(s) ready to commit"
[[ "${unstaged}"  -gt 0 ]] && warn "${unstaged} unstaged change(s)"
[[ "${untracked}" -gt 0 ]] && warn "${untracked} untracked file(s)"
[[ "${staged}" -eq 0 && "${unstaged}" -eq 0 && "${untracked}" -eq 0 ]] && \
    info "No staged, unstaged, or untracked files."

# Stashes
stash_count=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
[[ "${stash_count}" -gt 0 ]] && warn "${stash_count} stash entry/entries present"

# ── 3. Branch information ────────────────────────────────────────────────────
header "Branch information"

BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || true)
if [[ -z "${BRANCH}" ]]; then
    BRANCH=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
    warn "Detached HEAD at commit ${BRANCH}"
else
    info "Current branch: ${BOLD}${BRANCH}${RESET}"
fi

# Last commit
last_commit=$(git log -1 --pretty=format:"%h  %s  ${DIM}(%ar by %an)${RESET}" 2>/dev/null || echo "no commits")
detail "Last commit: ${last_commit}"

# ── 4. Remote detection ─────────────────────────────────────────────────────
header "Remote comparison"

# Find the tracking remote for the current branch, fall back to 'origin'
REMOTE=$(git config --get "branch.${BRANCH}.remote" 2>/dev/null || true)
if [[ -z "${REMOTE}" ]]; then
    # Fall back: use 'origin' if it exists
    if git remote get-url origin &>/dev/null; then
        REMOTE="origin"
        warn "Branch '${BRANCH}' has no explicit tracking remote; using 'origin'."
    else
        err "No remote configured. Cannot compare with GitHub."
        exit 0
    fi
fi

REMOTE_URL=$(git remote get-url "${REMOTE}" 2>/dev/null || echo "")
info "Remote '${REMOTE}': ${REMOTE_URL}"

# Fetch quietly so we have up-to-date refs
echo -e "  ${DIM}Fetching from ${REMOTE}…${RESET}"
if ! git fetch "${REMOTE}" --prune --quiet 2>/dev/null; then
    err "Fetch from '${REMOTE}' failed (network issue or auth error)."
    exit 1
fi

# Determine the remote-tracking branch name
REMOTE_TRACKING=$(git config --get "branch.${BRANCH}.merge" 2>/dev/null | sed 's|refs/heads/||' || true)
if [[ -z "${REMOTE_TRACKING}" ]]; then
    REMOTE_TRACKING="${BRANCH}"   # assume same name on remote
fi
REMOTE_REF="${REMOTE}/${REMOTE_TRACKING}"

# Check whether the remote branch actually exists
if ! git rev-parse --verify "${REMOTE_REF}" &>/dev/null; then
    warn "Remote branch '${REMOTE_REF}' does not exist."
    warn "This branch may be local-only and has not been pushed yet."
    exit 0
fi

info "Comparing local '${BRANCH}' to '${REMOTE_REF}'"

# Commits ahead / behind
AHEAD=$(git rev-list --count "${REMOTE_REF}..HEAD" 2>/dev/null)
BEHIND=$(git rev-list --count "HEAD..${REMOTE_REF}" 2>/dev/null)

echo
if [[ "${AHEAD}" -eq 0 && "${BEHIND}" -eq 0 ]]; then
    info "Branch is ${GREEN}up to date${RESET} with ${REMOTE_REF}."
else
    [[ "${AHEAD}"  -gt 0 ]] && warn "Local is ${AHEAD} commit(s) ${YELLOW}AHEAD${RESET} of ${REMOTE_REF} (unpushed)."
    [[ "${BEHIND}" -gt 0 ]] && warn "Local is ${BEHIND} commit(s) ${RED}BEHIND${RESET} ${REMOTE_REF} (need to pull)."
    [[ "${AHEAD}" -gt 0 && "${BEHIND}" -gt 0 ]] && \
        warn "Branches have ${RED}DIVERGED${RESET} — a merge or rebase will be required."
fi

# ── 5. Unpushed commits (log) ────────────────────────────────────────────────
if [[ "${AHEAD}" -gt 0 ]]; then
    header "Unpushed commits (local → remote)"
    git log --oneline "${REMOTE_REF}..HEAD" | while IFS= read -r line; do
        detail "  ↑ ${line}"
    done
fi

# ── 6. Incoming commits (log) ────────────────────────────────────────────────
if [[ "${BEHIND}" -gt 0 ]]; then
    header "Incoming commits (remote → local)"
    git log --oneline "HEAD..${REMOTE_REF}" | while IFS= read -r line; do
        detail "  ↓ ${line}"
    done
fi

# ── 7. Other local branches ──────────────────────────────────────────────────
header "Other local branches"
other_branches=$(git branch --format='%(refname:short)' | grep -v "^${BRANCH}$" || true)
if [[ -z "${other_branches}" ]]; then
    detail "(none)"
else
    while IFS= read -r b; do
        detail "  • ${b}"
    done <<< "${other_branches}"
fi

echo -e "\n${DIM}Done.${RESET}\n"


