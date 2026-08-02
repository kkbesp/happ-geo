# happ-geo

Урезанные geo-базы для Happ / Xray. Нужны потому, что iOS ограничивает память сетевого
расширения 50 МБ, а полные базы весят ~90 МБ и роняют ядро на старте.

Исходник — [runetfreedom/russia-v2ray-rules-dat](https://github.com/runetfreedom/russia-v2ray-rules-dat),
из него оставлены только теги, которые реально используются в правилах маршрутизации.

| файл | размер | теги |
|---|---|---|
| `geoip.dat` | 388 КБ | `ru`, `private` |
| `geosite.dat` | 3.8 МБ | `private`, `ru-available-only-inside`, `category-ads-all` |

## Ссылки для Happ

```
geoipUrl:   https://raw.githubusercontent.com/kkbesp/happ-geo/main/geoip.dat
geositeUrl: https://raw.githubusercontent.com/kkbesp/happ-geo/main/geosite.dat
```

## Импорт профиля в Happ

`routing.json` — сам профиль маршрутизации. `./make-link.sh` собирает из него ссылку
`happ://routing/onadd/<base64>` (кладёт в `link.txt`) и печатает QR прямо в терминал.
Действие `onadd` означает, что профиль активируется сразу при добавлении.

Сканировать с телефона:

<img src="routing-qr.png" width="320" alt="happ://routing/onadd — профиль маршрутизации">

Ссылка текстом (для macOS, где сканировать нечем) — в `link.txt`, удобнее так:

```sh
cat link.txt | pbcopy
```

Поменял правила в `routing.json` — перезапусти `make-link.sh` и отсканируй новый QR.
Скрипт каждый раз подставляет свежий `LastUpdated`, иначе Happ не перекачает geo-базы.

## Обновление

`.github/workflows/update.yml` раз в сутки перекачивает исходные базы, режет и коммитит.
Вручную — `python3 cut.py <исходник> <результат> <тег> [тег...]`.

Набор тегов задан в workflow. Добавляешь тег туда — он появляется в базе на следующем прогоне.
Если запрошенного тега в исходнике нет, `cut.py` завершается с ошибкой, и битая база не коммитится.
