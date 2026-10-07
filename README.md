# tosto

Das Portal für die Web-Apps der Rösterei: ein Login, danach eine Kachel pro App.
Nur für Mitarbeitende.

> **Stand 07.10.2026:** Planungsphase, noch kein Code.
> Offene Fragen: [`fragen/01-portal.md`](fragen/01-portal.md).

## Apps

| App | Repo | Status |
|-----|------|--------|
| Etikettendruck | `labels` | läuft lokal am Drucker, Einbindung geplant (Milestone 1) |
| Cupping | `roast-archive` | läuft lokal, Einbindung geplant (Milestone 1) |

Weitere Apps folgen. Wie eine App ins Portal kommt, regelt
[`KONVENTIONEN.md`](KONVENTIONEN.md).

## Technik in einem Satz

PHP auf einem Plesk-Webspace, JSON-Dateien statt Datenbank, Apps als Web
Components ohne Build-Schritt, Design über CSS-Variablen.

## Projektstruktur (Vorschlag, siehe Fragenkatalog C)

```
public/      Webverzeichnis: nur Einstiegspunkt, CSS, JS, Bilder
src/         PHP-Logik des Portals (Anmeldung, Sitzung, Ablage, Router)
apps/        ein Ordner pro App: Manifest und PHP-API der App
config/      Beispielkonfiguration (die echte liegt außerhalb des Webverzeichnisses)
scripts/     Kommandozeile: Konten anlegen, Bereitstellung, Backup
docs/        Architektur, Hosting, Entscheidungen, App-Übersicht
fragen/      Fragenkataloge
```

Auf dem Server liegen **Daten und Konfiguration außerhalb** des Webverzeichnisses,
z. B. `/var/www/vhosts/<domain>/tosto-daten/`.
