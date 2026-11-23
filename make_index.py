#!/usr/bin/env python3
"""make_index.py TAG: copies maps/<Name>.map to release/<slug>-city.map and writes cities.json for release TAG.

cities.json is what Cyclone reads (raw.githubusercontent.com/zakusworo/cyclone-maps/main/cities.json):
a list of {path, title, size, date (ms), bbox [minLat, minLon, maxLat, maxLon], url, sha256}.
"""
import hashlib, json, os, shutil, struct, sys

tag = sys.argv[1]
base = f"https://github.com/zakusworo/cyclone-maps/releases/download/{tag}/"
titles = {"Jabodetabek": "Jakarta (Jabodetabek)", "Bali": "Bali (whole island)"}
os.makedirs("release", exist_ok=True)
out = []
for line in open("cities.tsv"):
    name = line.split("\t")[0]
    src = f"maps/{name}.map"
    if not os.path.exists(src):
        print("missing", name); continue
    b = open(src, "rb").read(60)
    assert b[:20] == b"mapsforge binary OSM", src
    _, _, fsize, date = struct.unpack(">iiqq", b[20:44])
    box = [round(v / 1e6, 6) for v in struct.unpack(">iiii", b[44:60])]
    assert fsize == os.path.getsize(src), src
    fn = name.lower() + "-city.map"
    shutil.copyfile(src, "release/" + fn)
    out.append({"path": "indonesia/cities/" + fn, "title": titles.get(name, name), "size": fsize, "date": date,
                "bbox": box, "url": base + fn, "sha256": hashlib.sha256(open(src, "rb").read()).hexdigest()})
    print(f"{fn:26} {fsize/1e6:6.1f} MB  {out[-1]['title']}")
json.dump(out, open("cities.json", "w"), indent=1)
print(len(out), "maps ->", "cities.json")
