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

Ссылка текстом — для macOS, где сканировать нечем. Скопировать и вставить в Happ:

<!-- link -->
```
happ://routing/onadd/eyJOYW1lIjoia2tiZXNwIHJ1LWRpcmVjdCIsIkdsb2JhbFByb3h5IjoidHJ1ZSIsIkRvbWFpblN0cmF0ZWd5IjoiSVBJZk5vbk1hdGNoIiwiRmFrZUROUyI6ImZhbHNlIiwiVXNlQ2h1bmtGaWxlcyI6ImZhbHNlIiwiUmVtb3RlRE5TVHlwZSI6IkRvSCIsIlJlbW90ZUROU0RvbWFpbiI6Imh0dHBzOi8vZG5zLnF1YWQ5Lm5ldC9kbnMtcXVlcnkiLCJSZW1vdGVETlNJUCI6IjkuOS45LjkiLCJEb21lc3RpY0ROU1R5cGUiOiJEb0giLCJEb21lc3RpY0ROU0RvbWFpbiI6Imh0dHBzOi8vZG5zMTEucXVhZDkubmV0L2Rucy1xdWVyeSIsIkRvbWVzdGljRE5TSVAiOiI5LjkuOS4xMSIsIkdlb2lwdXJsIjoiaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2trYmVzcC9oYXBwLWdlby9tYWluL2dlb2lwLmRhdCIsIkdlb3NpdGV1cmwiOiJodHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20va2tiZXNwL2hhcHAtZ2VvL21haW4vZ2Vvc2l0ZS5kYXQiLCJEaXJlY3RTaXRlcyI6WyJnZW9zaXRlOnByaXZhdGUiLCJnZW9zaXRlOnJ1LWF2YWlsYWJsZS1vbmx5LWluc2lkZSIsImRvbWFpbjpzZWxlY3RlbC5ydSJdLCJEaXJlY3RJcCI6WyJnZW9pcDpwcml2YXRlIiwiZ2VvaXA6cnUiXSwiQmxvY2tTaXRlcyI6WyJnZW9zaXRlOmNhdGVnb3J5LWFkcy1hbGwiXSwiTGFzdFVwZGF0ZWQiOjE3ODU2OTE5OTB9
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
