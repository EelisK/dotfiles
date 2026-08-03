#!/bin/sh

exec 2>/dev/null
printf '\a' >/dev/tty && exit 0
[ -n "$TMUX_PANE" ] || exit 0
tty=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}') || exit 0
printf '\a' >"$tty"
exit 0
