#!/usr/bin/env python3
"""make_index.py TAG: copies maps/<Name>.map to release/<slug>-city.map and writes cities.json for release TAG.

cities.json is what Cyclone reads (raw.githubusercontent.com/zakusworo/cyclone-maps/main/cities.json):
a list of {path, title, size, date (ms), bbox [minLat, minLon, maxLat, maxLon], url, sha256}.
"""
import hashlib, json, os, shutil, struct, sys

tag = sys.argv[1]
base = f"https://github.com/zakusworo/cyclone-maps/releases/download/{tag}/"

os.makedirs("release", exist_ok=True)
out = []
for line in open("cities.tsv"):
    cols = line.rstrip("\n").split("\t"); name = cols[0]; title = cols[5] if len(cols) > 5 else name
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
    out.append({"path": "indonesia/cities/" + fn, "title": title, "size": fsize, "date": date,
                "bbox": box, "url": base + fn, "sha256": hashlib.sha256(open(src, "rb").read()).hexdigest()})
    print(f"{fn:26} {fsize/1e6:6.1f} MB  {title}")
json.dump(out, open("cities.json", "w"), indent=1)
# README table, smallest first
rows = ["| City | Size | Area (lat / lon) |", "|---|---|---|"] + [
    f"| {o['title']} | {o['size']/1e6:.0f} MB | {o['bbox'][0]:.2f}…{o['bbox'][2]:.2f} / {o['bbox'][1]:.2f}…{o['bbox'][3]:.2f} |"
    for o in sorted(out, key=lambda o: o["title"])]
readme = open("README.md").read()
a, b = readme.index("<!-- cities -->"), readme.index("<!-- /cities -->")
open("README.md", "w").write(readme[:a] + "<!-- cities -->\n" + "\n".join(rows) + "\n" + readme[b:])
print(len(out), "maps ->", "cities.json")
