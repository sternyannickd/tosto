# TOSTO

**T**ools **O**f **S**pecialty **T**asting & r**O**asting

Das Portal für die Web-Apps der Rösterei: ein Login, danach eine Kachel pro App.
Nur für Mitarbeitende, nur im Netz der Rösterei:
`https://tosto.internal.stern-kaffee.de`.

> **Stand 12.10.2026:** Planungsphase, noch kein Code. Hosting auf dem
> Firmenserver ist entschieden. Offene Fragen:
> [`fragen/01-portal.md`](fragen/01-portal.md).

## Apps

| App | Repo | Status |
|-----|------|--------|
| Etikettendruck | `labels` | läuft lokal am Drucker, Einbindung geplant |
| Cupping | `roast-archive` | läuft lokal, Einbindung geplant |

Weitere Apps folgen. Wie eine App ins Portal kommt, regelt
[`KONVENTIONEN.md`](KONVENTIONEN.md). Wie die Projekte miteinander reden:
[`schnittstelle/README.md`](schnittstelle/README.md).

## Technik in einem Satz

Firmenserver (AlmaLinux) im Netz der Rösterei, Webserver mit HTTPS davor, tosto
übernimmt die Anmeldung, jede App läuft als eigener Python-Dienst, JSON-Dateien
statt Datenbank, Oberflächen als Web Components ohne Build-Schritt.

## Ordner

```
docs/          Hosting, Entscheidungen, App-Übersicht
fragen/        Fragenkataloge
schnittstelle/ Nachrichten der Apps an tosto
scripts/       Skripte, z. B. server-fakten.sh
lokal/         sensible Ausgaben (Server-Fakten), nie im Git
```

Die Ordner für den Code kommen mit dem Plan.
