#!/usr/bin/env python3
"""Вырезает из geoip.dat/geosite.dat только указанные теги. ponytail: формат обеих баз одинаков (protobuf: repeated entry=1, первое поле внутри — имя тега)."""
import sys

def varint(b, i):
    r = s = 0
    while True:
        x = b[i]; r |= (x & 0x7f) << s; i += 1; s += 7
        if not x & 0x80: return r, i

def enc_varint(n):
    out = bytearray()
    while True:
        b = n & 0x7f; n >>= 7
        out.append(b | 0x80 if n else b)
        if not n: return bytes(out)

def cut(src, dst, keep):
    d = open(src, 'rb').read()
    keep = {k.upper() for k in keep}
    i, out, found = 0, bytearray(), []
    while i < len(d):
        tag, i = varint(d, i)
        if tag >> 3 != 1 or tag & 7 != 2: break
        ln, i = varint(d, i)
        ent = d[i:i+ln]; i += ln
        j = 0; t, j = varint(ent, j)
        if t != 0x0a: continue
        sl, j = varint(ent, j)
        name = ent[j:j+sl].decode('utf8', 'replace').upper()
        if name in keep:
            out += b'\x0a' + enc_varint(ln) + ent
            found.append(name)
    open(dst, 'wb').write(out)
    missing = keep - set(found)
    return len(out), found, missing

if __name__ == '__main__':
    src, dst, *tags = sys.argv[1:]
    size, found, missing = cut(src, dst, tags)
    print(f"{dst}: {size/1024:.0f} KB, теги: {', '.join(sorted(found)) or '—'}")
    if missing:
        print(f"  НЕ НАЙДЕНЫ: {', '.join(sorted(missing))}", file=sys.stderr)
        sys.exit(1)  # ponytail: падаем, чтобы CI не закоммитил базу без нужного тега
