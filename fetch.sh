#!/usr/bin/env bash
# fetch.sh [MINUTES]: waits for every city in cities.tsv on download2.bbbike.org, downloads + unzips the .map.
# A zip is fetched fresh on each try (BBBike may still be writing it) and used only if `unzip -t` passes.
cd "$(dirname "$0")"
end=$((SECONDS + 60 * ${1:-60}))
while :; do
  left=0
  while IFS=$'\t' read -r n a b c d t; do
    [ -s "maps/$n.map" ] && continue
    f=$(printf 'planet_%.3f,%.3f_%.3f,%.3f.osm.mapsforge-osm.zip' "$a" "$b" "$c" "$d")
    u="https://download2.bbbike.org/osm/extract/$f"
    if curl -sfI -m 30 "$u" >/dev/null && curl -sSf -m 900 -o "zips/$n.zip.part" "$u" \
       && unzip -tq "zips/$n.zip.part" >/dev/null 2>&1; then
      mv "zips/$n.zip.part" "zips/$n.zip"
      m=$(unzip -Z1 "zips/$n.zip" | grep '\.map$' | head -1)
      unzip -p "zips/$n.zip" "$m" > "maps/$n.map.tmp" && mv "maps/$n.map.tmp" "maps/$n.map" \
        && echo "$(date +%T) got $n: $(stat -c%s "maps/$n.map") B"
    else
      rm -f "zips/$n.zip.part"; left=1
    fi
  done < cities.tsv
  [ $left = 0 ] && { echo "ALL DONE"; break; }
  if [ $SECONDS -gt $end ]; then
    echo "TIMEOUT, missing:"; while IFS=$'\t' read -r n r; do [ -s "maps/$n.map" ] || echo " $n"; done < cities.tsv
    break
  fi
  sleep 60
done
