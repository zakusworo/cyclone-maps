#!/usr/bin/env bash
# submit.sh NAME sw_lng sw_lat ne_lng ne_lat  -> asks BBBike extract for a Mapsforge .map of the box (email=nobody).
set -euo pipefail
name=$1 swlng=$2 swlat=$3 nelng=$4 nelat=$5
as=$(python3 -c "import math;print(round(abs($nelng-$swlng)*111.32*math.cos(math.radians(($swlat+$nelat)/2))*abs($nelat-$swlat)*110.57,1))")
curl -sS -m 60 -G https://extract.bbbike.org/ --data-urlencode sw_lng=$swlng --data-urlencode sw_lat=$swlat \
  --data-urlencode ne_lng=$nelng --data-urlencode ne_lat=$nelat --data-urlencode format=mapsforge-osm.zip \
  --data-urlencode city="$name" --data-urlencode email=nobody --data-urlencode as=$as --data-urlencode pg=0 \
  --data-urlencode lang=en --data-urlencode expire=$(date +%s) --data-urlencode submit=extract -o "resp-$name.html"
echo "$name ($as km²): $(sed 's/<[^>]*>//g' "resp-$name.html" | tr -s ' \n' | grep -i -m2 -E 'thank|queue|error|invalid|must|limit|already|download' | tr '\n' ' ')"
