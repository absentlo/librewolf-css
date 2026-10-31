#!/usr/bin/env bash
# Copies the Graphite config into a LibreWolf or Firefox profile.
# Usage: ./install.sh [--profile DIR] [--build-addon]
# --build-addon also builds an unsigned start page in dist/, for working on its code.
# Anything it would replace is first saved as <name>.bak-<timestamp> next to the original.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
profile=""
addon=0

while (($#)); do
    case "$1" in
        --profile) [[ $# -ge 2 ]] || { echo "--profile needs a folder" >&2; exit 2; }; profile="$2"; shift 2 ;;
        --build-addon) addon=1; shift ;;
        -h|--help) sed -n '2,5p' "$0" | cut -c3-; exit 0 ;;
        *) echo "Unknown option: $1" >&2; exit 2 ;;
    esac
done

roots=(
    "$HOME/.config/librewolf/librewolf"
    "$HOME/.librewolf"
    "$HOME/.var/app/io.gitlab.librewolf-community/.librewolf"
    "$HOME/.mozilla/firefox"
    "$HOME/.config/mozilla/firefox"
    "$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox"
    "$HOME/snap/firefox/common/.mozilla/firefox"
    "$HOME/Library/Application Support/librewolf/Profiles"
    "$HOME/Library/Application Support/Firefox/Profiles"
)

if [[ -z $profile ]]; then
    found=()
    for root in "${roots[@]}"; do
        for prefs in "$root"/*/prefs.js; do
            [[ -f $prefs ]] && found+=("$(dirname "$prefs")")
        done
    done
    case ${#found[@]} in
        0) echo "No profile found. Open the browser once, close it, then run this again," >&2
           echo "or point at the folder from about:profiles: ./install.sh --profile DIR" >&2
           exit 1 ;;
        1) profile="${found[0]}" ;;
        *) echo "Which profile? about:profiles shows the one in use."
           select choice in "${found[@]}"; do
               [[ -n ${choice:-} ]] && { profile="$choice"; break; }
           done
           [[ -n $profile ]] || { echo "No profile chosen." >&2; exit 1; } ;;
    esac
fi

[[ -d $profile ]] || { echo "Not a folder: $profile" >&2; exit 1; }

stamp="$(date +%Y%m%d-%H%M%S)"
backup() {
    if [[ -e $1 ]]; then
        cp -a "$1" "$1.bak-$stamp"
        echo "Backup: $1.bak-$stamp"
    fi
}

backup "$profile/user.js"
backup "$profile/chrome"
mkdir -p "$profile/chrome"
cp "$here/profile/user.js" "$profile/"
cp "$here"/profile/chrome/*.css "$profile/chrome/"
echo "Installed user.js and chrome/ into: $profile"

if ((addon)); then
    command -v zip >/dev/null || { echo "zip is not installed. Install it to use --build-addon." >&2; exit 1; }
    mkdir -p "$here/dist"
    rm -f "$here/dist/graphite-start.xpi"
    (cd "$here/startpage" && zip -qr "$here/dist/graphite-start.xpi" .)
    echo "Built the unsigned start page: $here/dist/graphite-start.xpi"
fi

if [[ -L $profile/lock ]]; then
    echo "The browser is using this profile: restart it to apply the changes."
fi

cat <<NEXT

Next:
  1. Restart the browser.
NEXT
cat <<NEXT
  2. For the start page, download graphite-start.xpi from the newest version on
     https://github.com/absentlo/librewolf-css/releases
     then open about:addons, click the gear, and choose Install Add-on From File.
NEXT
