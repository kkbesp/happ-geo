#!/bin/sh
# Собирает happ://routing/onadd/... из routing.json, рисует QR и кладёт его в routing-qr.png.
# ponytail: LastUpdated ставится текущим временем — иначе Happ не перекачает geo-базы.
set -e
cd "$(dirname "$0")"

JSON=$(python3 -c "
import json, time, sys
p = json.load(open('routing.json'))
p = {k: v for k, v in p.items() if v != []}   # пустые массивы валят парсер Happ
p['LastUpdated'] = int(time.time())
sys.stdout.write(json.dumps(p, ensure_ascii=False, separators=(',', ':')))")

# base64url без padding: '=' и '+/' в пути ссылки ломают разбор
B64=$(printf %s "$JSON" | python3 -c "
import base64, sys
sys.stdout.write(base64.urlsafe_b64encode(sys.stdin.buffer.read()).decode().rstrip('='))")

LINK="happ://routing/onadd/$B64"
printf '%s\n' "$LINK" > link.txt
echo "длина ссылки: $(printf %s "$LINK" | wc -c | tr -d ' ') байт"

# вписываем ссылку в README между маркерами, чтобы она не устаревала
python3 - "$LINK" <<'PY'
import re, sys
link = sys.argv[1]
r = open('README.md').read()
r = re.sub(r'(<!-- link -->\n).*?(\n<!-- /link -->)',
           lambda m: m.group(1) + '```\n' + link + '\n```' + m.group(2), r, flags=re.S)
open('README.md', 'w').write(r)
PY

if command -v qrencode >/dev/null; then
  qrencode -o routing-qr.png -s 8 -m 2 "$LINK"
  qrencode -t ANSIUTF8 -o - "$LINK"
else
  echo "qrencode не установлен: brew install qrencode"
fi
