# Cyclone city maps

Offline maps of Indonesian cities for [Cyclone](https://github.com/zakusworo/cyclone-beta), the bike computer app.
The maps from download.mapsforge.org stop at island level (Java alone is 918 MB). These files cover one city
area each, usually 10–150 MB.

Cyclone lists them by itself: **Options → Offline maps → Find maps for my location**, or search by city name.
The smallest map that covers you comes first.

## Maps

<!-- cities -->
| City | Size | Area (lat / lon) |
|---|---|---|
| Ambon | 2 MB | -3.80…-3.55 / 128.05…128.30 |
| Bali (whole island) | 56 MB | -8.90…-8.05 / 114.40…115.75 |
| Balikpapan | 7 MB | -1.35…-1.05 / 116.75…117.05 |
| Bandar Lampung | 6 MB | -5.55…-5.30 / 105.15…105.40 |
| Bandung | 60 MB | -7.20…-6.75 / 107.35…107.85 |
| Banjarmasin (with Banjarbaru) | 12 MB | -3.55…-3.25 / 114.50…114.90 |
| Banyuwangi | 4 MB | -8.35…-8.10 / 114.25…114.45 |
| Batam | 5 MB | 0.95…1.20 / 103.85…104.20 |
| Cirebon | 12 MB | -6.85…-6.60 / 108.40…108.65 |
| Garut | 5 MB | -7.35…-7.10 / 107.80…108.05 |
| Jakarta (Jabodetabek) | 155 MB | -6.75…-6.05 / 106.50…107.20 |
| Jambi | 7 MB | -1.75…-1.50 / 103.45…103.75 |
| Jayapura | 1 MB | -2.70…-2.50 / 140.55…140.80 |
| Jember | 5 MB | -8.30…-8.05 / 113.55…113.80 |
| Kediri | 4 MB | -7.95…-7.70 / 111.90…112.15 |
| Kendari | 3 MB | -4.05…-3.90 / 122.45…122.65 |
| Kupang | 4 MB | -10.25…-10.10 / 123.50…123.70 |
| Labuan Bajo | 1 MB | -8.70…-8.40 / 119.80…120.10 |
| Lake Toba (Samosir) | 2 MB | 2.30…2.95 / 98.50…99.20 |
| Lombok (whole island) | 39 MB | -9.00…-8.15 / 115.80…116.75 |
| Magelang (with Borobudur) | 8 MB | -7.65…-7.40 / 110.10…110.35 |
| Makassar | 15 MB | -5.30…-5.00 / 119.35…119.60 |
| Malang | 13 MB | -8.10…-7.80 / 112.45…112.80 |
| Manado | 6 MB | 1.35…1.60 / 124.75…125.00 |
| Medan | 27 MB | 3.45…3.75 / 98.55…98.85 |
| Padang | 9 MB | -1.05…-0.80 / 100.25…100.50 |
| Palembang | 8 MB | -3.10…-2.85 / 104.60…104.90 |
| Palu | 5 MB | -1.00…-0.75 / 119.75…119.95 |
| Pekalongan | 4 MB | -6.95…-6.80 / 109.55…109.75 |
| Pekanbaru | 3 MB | 0.40…0.65 / 101.30…101.55 |
| Pontianak | 7 MB | -0.15…0.10 / 109.20…109.45 |
| Purwokerto | 11 MB | -7.55…-7.30 / 109.10…109.35 |
| Salatiga | 2 MB | -7.42…-7.25 / 110.40…110.60 |
| Samarinda | 8 MB | -0.65…-0.35 / 117.05…117.30 |
| Semarang | 28 MB | -7.20…-6.90 / 110.25…110.60 |
| Serang and Cilegon | 6 MB | -6.20…-5.95 / 105.90…106.25 |
| Solo | 13 MB | -7.70…-7.45 / 110.65…110.95 |
| Sukabumi | 6 MB | -7.05…-6.80 / 106.80…107.05 |
| Surabaya | 44 MB | -7.50…-7.10 / 112.50…112.90 |
| Tasikmalaya | 7 MB | -7.45…-7.25 / 108.10…108.35 |
| Tegal | 6 MB | -6.95…-6.80 / 109.05…109.25 |
| Yogyakarta | 65 MB | -8.20…-7.55 / 110.00…110.85 |
<!-- /cities -->

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
