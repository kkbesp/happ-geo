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

## Обновление

`.github/workflows/update.yml` раз в сутки перекачивает исходные базы, режет и коммитит.
Вручную — `python3 cut.py <исходник> <результат> <тег> [тег...]`.

Набор тегов задан в workflow. Добавляешь тег туда — он появляется в базе на следующем прогоне.
Если запрошенного тега в исходнике нет, `cut.py` завершается с ошибкой, и битая база не коммитится.
