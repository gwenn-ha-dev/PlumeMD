#!/bin/bash
# README captures — CHARTE.md §12. `make shots` delegates here.
#
# Each shot opens one of the sample documents in outils/exemples/ — written for
# the captures, nothing personal — in the built app, in one language and one
# appearance, and captures its window with the charter's capturer. The French
# shots open the French documents: the app shows what it is given.
set -euo pipefail
cd "$(dirname "$0")/.."
capturer=${CHARTE:-../../Charte}/outils/capturer.sh
app=build/PlumeMD.app
[ -d "$app" ] || { echo "captures: build the app first (make package)" >&2; exit 1; }

shot() {  # shot <document> <language> <Light|Dark> <out> [launch arguments…]
  local doc=$1 lang=$2 look=$3 out=$4; shift 4
  pkill -x PlumeMD 2>/dev/null || true
  sleep 1
  open -n -a "$PWD/$app" "$PWD/$doc" --args \
    -ApplePersistenceIgnoreState YES -AppleInterfaceStyle "$look" -NSRequiresAquaSystemAppearance "$( [ "$look" = Light ] && echo YES || echo NO )" \
    -AppleLanguages "($lang)" -AppleLocale "${lang}_$( [ "$lang" = en ] && echo GB || echo FR )" "$@"
  # Wait for the document window (up to 20 s), then let it settle.
  for _ in $(seq 20); do
    swift "$(dirname "$capturer")/capturer.swift" PlumeMD >/dev/null 2>&1 && break
    sleep 1
  done
  sleep 2
  "$capturer" PlumeMD "$out"
}

for lang in en fr; do
  if [ "$lang" = en ]; then
    suffix="" walk="outils/exemples/en/Crozon walk.md" notes="outils/exemples/en/HTTP cache.md"
  else
    suffix=".fr" walk="outils/exemples/fr/Randonnée Crozon.md" notes="outils/exemples/fr/Cache HTTP.md"
  fi
  shot "$walk"  "$lang" Light "docs/img/preview$suffix.png"
  shot "$walk"  "$lang" Light "docs/img/editor$suffix.png" -startInEditor YES
  shot "$notes" "$lang" Dark  "docs/img/dark$suffix.png"
done
pkill -x PlumeMD 2>/dev/null || true
