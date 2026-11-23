# Cyclone city maps

Offline maps of Indonesian cities for [Cyclone](https://github.com/zakusworo/cyclone-beta), the bike computer app.
The maps from download.mapsforge.org stop at island level (Java alone is 918 MB). These files cover one city
area each, usually 10–150 MB.

Cyclone lists them by itself: **Options → Offline maps → Find maps for my location**, or search by city name.
The smallest map that covers you comes first.

## Maps

| City | Area (lat / lon) |
|---|---|
| Bandung | −7.20…−6.75 / 107.35…107.85 |
| Jakarta (Jabodetabek) | −6.75…−6.05 / 106.50…107.20 |
| Surabaya | −7.50…−7.10 / 112.50…112.90 |
| Semarang | −7.20…−6.90 / 110.25…110.60 |
| Yogyakarta | −8.20…−7.55 / 110.00…110.85 |
| Solo | −7.70…−7.45 / 110.65…110.95 |
| Malang | −8.10…−7.80 / 112.45…112.80 |
| Bali (whole island) | −8.90…−8.05 / 114.40…115.75 |
| Palembang | −3.10…−2.85 / 104.60…104.90 |

Files, sizes and checksums: [`cities.json`](cities.json). The files themselves are on the
[Releases](https://github.com/zakusworo/cyclone-maps/releases) page, one release per build (`maps-YYYY-MM`).

Format: Mapsforge binary map, so any Mapsforge app can open them too (Cruiser, Locus Map, OruxMaps, c:geo).

## How they are made

1. `cities.tsv` holds each city's box. `submit.sh` asks the [BBBike extract service](https://extract.bbbike.org/)
   for a "Mapsforge OSM" extract of it.
2. `fetch.sh` waits for the extracts on download2.bbbike.org, downloads and unzips them.
3. `check_maps.py` checks each header the way Cyclone does (magic, stated length, date, box).
4. `make_index.py maps-YYYY-MM` renames the files and writes `cities.json`; the files go up as release assets.

The maps are rebuilt every few months. Cyclone notices the newer date in `cities.json` and offers the update.

## Licence

Map data © [OpenStreetMap contributors](https://www.openstreetmap.org/copyright), available under the
[Open Database License (ODbL) 1.0](https://opendatacommons.org/licenses/odbl/1-0/). These files are a derived
database and are shared under the same licence. Extracts made with the BBBike extract service by Wolfram Schneider.
The scripts in this repository are free to use.
