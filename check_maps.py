#!/usr/bin/env python3
"""check_maps.py FILE.map...: Mapsforge header check (same rules as Cyclone OfflineMaps.header) + sha256."""
import hashlib, struct, sys, os, datetime
for p in sys.argv[1:]:
    b = open(p, 'rb').read(200)
    ok = b[:20] == b'mapsforge binary OSM'
    hsize, ver, fsize, date = struct.unpack('>iiqq', b[20:44])
    box = [v / 1e6 for v in struct.unpack('>iiii', b[44:60])]
    real = os.path.getsize(p)
    h = hashlib.sha256(open(p, 'rb').read()).hexdigest()
    print(f"{os.path.basename(p):18} {'OK ' if ok and fsize == real else 'BAD'} v{ver} {real/1e6:7.1f} MB "
          f"{datetime.datetime.utcfromtimestamp(date/1000):%Y-%m-%d} box={box} {h[:12]}")
