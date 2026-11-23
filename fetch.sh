#!/usr/bin/env bash
# fetch.sh: waits for every city in cities.tsv on download2.bbbike.org, downloads + unzips the .map (max 60 min).
cd "$(dirname "$0")"
end=$((SECONDS+3600))
while :; do
  left=0
  while IFS=$'\t' read n a b c d; do
    [ -s "maps/$n.map" ] && continue
    f=$(printf 'planet_%.3f,%.3f_%.3f,%.3f.osm.mapsforge-osm.zip' $a $b $c $d)
    if curl -sfI -m 30 "https://download2.bbbike.org/osm/extract/$f" >/dev/null; then
      curl -sSf -m 900 -C - --retry 3 -o "zips/$n.zip" "https://download2.bbbike.org/osm/extract/$f" && \
      m=$(unzip -Z1 "zips/$n.zip" | grep '\.map$' | head -1) && unzip -p "zips/$n.zip" "$m" > "maps/$n.map.tmp" && \
      mv "maps/$n.map.tmp" "maps/$n.map" && echo "$(date +%T) got $n: $(stat -c%s maps/$n.map) B ($m)" || { echo "$n download failed"; left=1; }
    else left=1; fi
  done < cities.tsv
  [ $left = 0 ] && { echo ALL DONE; break; }
  [ $SECONDS -gt $end ] && { echo TIMEOUT; ls maps; break; }
  sleep 60
done
