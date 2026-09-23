#!/bin/bash
# Waybar "now playing" widget backed by the playerctl CLI.
#
# This replaces waybar's native `mpris` module. That module segfaults in
# waybar 0.15.0 when a media player appears (e.g. a browser video starts):
#
#   #0 Glib::DispatchNotifier::send_notification(Glib::Dispatcher*)
#   ... libplayerctl ... libgio (D-Bus)
#
# It is a known upstream bug, fixed only on waybar git master
# (commits a8162186 "disconnect GLib signals before destroying objects",
# c19abf37 "defer widget visibility to update()..."), so no `mpris`
# config option can avoid it. Querying playerctl as a plain CLI tool
# keeps libplayerctl/GLib signals out of the waybar process entirely.
#
# Contract: prints one line of JSON for waybar's custom module
# (`"return-type": "json"`) and is safe to run when no player is active.

set -u

emit() {
    # $1 = text, $2 = tooltip, $3 = class
    jq -cn --arg text "$1" --arg tooltip "$2" --arg class "$3" \
        '{text: $text, tooltip: $tooltip, class: $class}'
}

if ! command -v playerctl >/dev/null 2>&1; then
    emit "" "playerctl is not installed" "stopped"
    exit 0
fi

# playerctl exits non-zero when there is no controllable player.
if ! playerctl -s status >/dev/null 2>&1; then
    emit "" "No media player" "stopped"
    exit 0
fi

status="$(playerctl -s status 2>/dev/null)"
player="$(playerctl -s metadata --format '{{playerName}}' 2>/dev/null)"
artist="$(playerctl -s metadata --format '{{artist}}' 2>/dev/null)"
title="$(playerctl -s metadata --format '{{title}}' 2>/dev/null)"
album="$(playerctl -s metadata --format '{{album}}' 2>/dev/null)"

# Collapse newlines/tabs and repeated spaces so a long title can't break
# the module layout.
clean() {
    printf '%s' "$1" | tr '\n\r\t' '    ' | sed -e 's/  */ /g' -e 's/^ //' -e 's/ $//'
}
artist="$(clean "$artist")"
title="$(clean "$title")"
album="$(clean "$album")"

if [ "$status" = "Stopped" ] || { [ -z "$artist" ] && [ -z "$title" ]; }; then
    emit "" "No media playing" "stopped"
    exit 0
fi

case "$status" in
    Playing) icon="▶"; class="playing" ;;
    Paused)  icon="⏸"; class="paused" ;;
    *)       icon="⏹"; class="stopped" ;;
esac

if [ -n "$artist" ] && [ -n "$title" ]; then
    text="$artist - $title"
elif [ -n "$title" ]; then
    text="$title"
else
    text="$artist"
fi

# Truncate for the bar; the tooltip keeps the full text.
trunc="$(printf '%s' "$text" | cut -c1-40)"
if [ "$trunc" != "$text" ]; then
    text="$trunc…"
else
    text="$trunc"
fi

tooltip="$player — $status"
[ -n "$artist" ] && tooltip+=$'\n'"$artist"
[ -n "$title" ]  && tooltip+=$'\n'"$title"
[ -n "$album" ]  && tooltip+=$'\n'"$album"

emit "$icon $text" "$tooltip" "$class"
