#!/usr/bin/env bash
# run_batch.sh NEW.tsv TAG: submits NEW.tsv to BBBike 8 at a time (rate limit), fetches every city in cities.tsv,
# (submitted.list remembers requests across restarts), rebuilds cities.json + README, uploads new maps to release TAG, then commits and pushes (index last).
set -uo pipefail
cd "$(dirname "$0")"
new=$1 tag=$2 i=0
while IFS=$'\t' read -r n a b c d t; do
  [ -s "maps/$n.map" ] && continue
  grep -qx "$n" submitted.list 2>/dev/null && continue   # already asked for (a restart must not resubmit)
  if [ $i -gt 0 ] && [ $((i % 8)) = 0 ]; then echo "$(date +%T) pause 16 min (BBBike limit)"; sleep 960; fi
  for try in 1 2 3; do
    out=$(./submit.sh "$n" "$a" "$b" "$c" "$d"); echo "$(date +%T) $out"
    case $out in *"Too many"*) sleep 960;; *"Thank you"*) echo "$n" >> submitted.list; break;; *) break;; esac
  done
  i=$((i+1)); sleep 10
done < "$new"
./fetch.sh 90
python3 check_maps.py maps/*.map 2>/dev/null | grep -v " OK " && { echo "BAD MAP, stopping"; exit 1; }
python3 make_index.py "$tag" | tail -2
have=$(gh release view "$tag" --json assets -q '.assets[].name')
for f in release/*.map; do
  b=$(basename "$f"); grep -qx "$b" <<< "$have" && continue
  for t in 1 2 3; do gh release upload "$tag" "$f" && echo "up $b" && break; done
done
git add cities.tsv cities.json README.md make_index.py fetch.sh run_batch.sh submit.sh && \
  git -c user.name=zakusworo -c user.email=greataji13@gmail.com commit -qm "More cities: $(python3 -c "import json;print(len(json.load(open('cities.json'))))") maps" && git push -q && echo PUSHED
