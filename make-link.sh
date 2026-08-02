#!/bin/sh
# Собирает happ://routing/onadd/... из routing.json и рисует QR.
# ponytail: LastUpdated ставится текущим временем — иначе Happ не перекачает geo-базы.
set -e
cd "$(dirname "$0")"
JSON=$(python3 -c "
import json,time,sys
p=json.load(open('routing.json')); p['LastUpdated']=str(int(time.time()))
sys.stdout.write(json.dumps(p,ensure_ascii=False,separators=(',',':')))")
LINK="happ://routing/onadd/$(printf %s "$JSON" | base64 | tr -d '\n')"
printf '%s\n' "$LINK" > link.txt
echo "$LINK" | wc -c | xargs echo "длина ссылки, байт:"
command -v qrencode >/dev/null && qrencode -t ANSIUTF8 -o - "$LINK" || echo "qrencode не установлен: brew install qrencode"
