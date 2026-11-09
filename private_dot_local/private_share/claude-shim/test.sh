#!/bin/sh
# Self-check for the claude shim. Run with: sh ~/.local/share/claude-shim/test.sh
# Interactive prompting needs a pty, so only the non-interactive paths are covered here.

shim_dir=$(cd "$(dirname "$0")" && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/bin" "$tmp/home/work/siderolabs/talos" "$tmp/home/work/siderolabs-other" "$tmp/home/work/personal"
cat >"$tmp/bin/claude" <<'EOF'
#!/bin/sh
printf '%s|%s|%s\n' "${CLAUDE_CONFIG_DIR:-}" "${CLAUDE_PROFILE:-}" "$*"
EOF
chmod +x "$tmp/bin/claude"

home=$tmp/home
fail=0

check() {
	want=$1
	cwd=$2
	shift 2
	got=$(cd "$home/$cwd" && env -u CLAUDE_PROFILE -u CLAUDE_CONFIG_DIR HOME="$home" PATH="$shim_dir:$tmp/bin:$PATH" "$@" </dev/null 2>/dev/null)
	if [ "$got" != "$want" ]; then
		echo "FAIL cwd=$cwd cmd=$* want=$want got=$got"
		fail=1
	fi
}

work=$home/.claude-work

check "$work|work|-c" work/siderolabs/talos claude -c
check "$work|work|" work/siderolabs claude
check "|personal|-c" work/personal claude -c
check "|personal|" work/siderolabs-other claude
check "|personal|" work/siderolabs/talos env CLAUDE_PROFILE=personal claude
check "|personal|" work/siderolabs/talos env CLAUDE_PROFILE=personal CLAUDE_CONFIG_DIR=/x claude
check "$work|work|" work/personal env CLAUDE_PROFILE=work claude
check "/x||" work/siderolabs/talos env CLAUDE_CONFIG_DIR=/x claude
check "|personal|a b" work/personal claude "a b"
check "" work/personal env CLAUDE_PROFILE=bogus claude

none=$(cd "$home" && env -u CLAUDE_PROFILE HOME="$home" PATH="$shim_dir:/usr/bin:/bin" claude </dev/null 2>&1)
status=$?
if [ "$status" -ne 127 ] || [ "$none" != 'claude-shim: no claude binary found on PATH' ]; then
	echo "FAIL missing binary: status=$status out=$none"
	fail=1
fi

[ "$fail" -eq 0 ] && echo 'claude-shim: all checks passed'
exit "$fail"
