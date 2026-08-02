# happ-geo

Урезанные geo-базы для Happ / Xray. Нужны потому, что iOS ограничивает память сетевого
расширения 50 МБ, а полные базы весят ~90 МБ и роняют ядро на старте.

Исходник — [runetfreedom/russia-v2ray-rules-dat](https://github.com/runetfreedom/russia-v2ray-rules-dat),
из него оставлены только теги, которые реально используются в правилах маршрутизации.

| файл | размер | теги |
|---|---|---|
| `geoip.dat` | 388 КБ | `ru`, `private` |

Рекламу режет не маршрутизация, а DNS (AdGuard в удалённом резолвере): тег
`category-ads-all` — это 156686 доменов, в памяти Xray они не влезают в лимит iOS.
| `geosite.dat` | 6 КБ | `private`, `ru-available-only-inside` |

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

Ссылка текстом — для macOS, где сканировать нечем. Скопировать и вставить в Happ:

<!-- link -->
```
happ://routing/onadd/eyJOYW1lIjoia2tiZXNwIHJ1LWRpcmVjdCIsIkdsb2JhbFByb3h5IjoidHJ1ZSIsIkRvbWFpblN0cmF0ZWd5IjoiSVBJZk5vbk1hdGNoIiwiRmFrZUROUyI6ImZhbHNlIiwiVXNlQ2h1bmtGaWxlcyI6ImZhbHNlIiwiUmVtb3RlRE5TVHlwZSI6IkRvSCIsIlJlbW90ZUROU0RvbWFpbiI6Imh0dHBzOi8vZG5zLmFkZ3VhcmQtZG5zLmNvbS9kbnMtcXVlcnkiLCJSZW1vdGVETlNJUCI6Ijk0LjE0MC4xNC4xNCIsIkRvbWVzdGljRE5TVHlwZSI6IkRvSCIsIkRvbWVzdGljRE5TRG9tYWluIjoiaHR0cHM6Ly9kbnMxMS5xdWFkOS5uZXQvZG5zLXF1ZXJ5IiwiRG9tZXN0aWNETlNJUCI6IjkuOS45LjExIiwiR2VvaXB1cmwiOiJodHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20va2tiZXNwL2hhcHAtZ2VvL21haW4vZ2VvaXAuZGF0IiwiR2Vvc2l0ZXVybCI6Imh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9ra2Jlc3AvaGFwcC1nZW8vbWFpbi9nZW9zaXRlLmRhdCIsIkRpcmVjdFNpdGVzIjpbImdlb3NpdGU6cHJpdmF0ZSIsImdlb3NpdGU6cnUtYXZhaWxhYmxlLW9ubHktaW5zaWRlIiwiZG9tYWluOnNlbGVjdGVsLnJ1Il0sIkRpcmVjdElwIjpbImdlb2lwOnByaXZhdGUiLCJnZW9pcDpydSJdLCJMYXN0VXBkYXRlZCI6MTc4NTY5MzY5Mn0
```
<!-- /link -->

Или из терминала: `cat ~/happ-geo/link.txt | pbcopy`

Поменял правила в `routing.json` — перезапусти `make-link.sh` и отсканируй новый QR.
Скрипт каждый раз подставляет свежий `LastUpdated`, иначе Happ не перекачает geo-базы.

## Обновление

`.github/workflows/update.yml` раз в сутки перекачивает исходные базы, режет и коммитит.
Вручную — `python3 cut.py <исходник> <результат> <тег> [тег...]`.

Набор тегов задан в workflow. Добавляешь тег туда — он появляется в базе на следующем прогоне.
Если запрошенного тега в исходнике нет, `cut.py` завершается с ошибкой, и битая база не коммитится.
