# Apps

Übersicht über alle Apps, die ins Portal kommen. Stand 07.10.2026, nach Lesen der
beiden Projekte.

## Etikettendruck (`../labels`)

**Was sie tut:** Produktetiketten (Titel, EAN-13, MHD) auf einem Citizen CL-S521
(57 × 32 mm) drucken. Das Programm erzeugt ZPL und schickt es unverändert an den
Drucker. Am echten Drucker getestet, Version 0.2.0.

**Technik heute:** Python ≥ 3.11, nur Standardbibliothek, lokal am Linux-Mint-Rechner
mit USB-Drucker. Schichten: `zpl.py` (Layout → ZPL, die einzige Stelle, an der das
Etikett entsteht), `drucker.py` (Druckwege), `dienst.py` (Ablauf), `server.py`
(JSON-API), `static/` (Oberfläche). Produkte in `data/produkte.csv`, Druckprotokoll
als CSV.

**Schon vorbereitet:** `<etiketten-app api="…">` gibt es bereits als Web Component
mit CSS-Variablen und eine Beispiel-Einbindung (`static/beispiel-einbindung.html`).

**API heute:** `GET /api/status`, `GET /api/produkte`, `GET /api/mhd`,
`POST /api/zpl`, `POST /api/vorschau` (PNG über labelary.com), `POST /api/drucken`,
`POST /api/testdruck`.

**Plan (Stand 12.10.2026):** labels läuft auf dem Firmenserver als Python-Dienst
hinter tosto, der Drucker hängt per USB am Server. Gedruckt wird direkt wie heute.
Der ursprünglich geplante Druckagent mit Warteschlange über das Internet entfällt.

**Zu klären** (in labels, siehe `../labels/TOSTO.md`): Vorschau, Pfade und Start
als Dienst, Produktpflege in der Web-App.

## Cupping (`../roast-archive`)

**Was sie tut:** Verkostungen nach dem SCA Coffee Value Assessment
(SCA-102/103/104): ein Cupping = ein Tisch mit mehreren Proben und mehreren
Cuppern, Descriptive (Intensität 0–15 + Flavour Wheel) und Affective (Qualität 1–9 →
Cupping Score), Auswertung, CSV-Export. Daneben ein Röstungskatalog aus
Artisan-`.alog`-Dateien und Listen (Cupper, Sorten).

Das Projekt ist mehr als die Cupping-App: `.alog`-Parser, CLI (`inspect`, `export`,
`compare`, `archive`, `coffee`, `cva`), Archivierung nach Nextcloud.

**Technik heute:** Python (Standardbibliothek), `webapp.py` als lokaler HTTP-Server
(`--lan` für Tablets im WLAN, ohne Anmeldung). Oberfläche als Single-Page-App mit
ES-Modulen ohne Build-Schritt (`web/js/…`, Hash-Router, vier Bereiche). Insgesamt
ca. 9.800 Zeilen Python + JS.

**Daten:** `roast-registry.json` (Röstungen, Sorten, Cupper, Einstellungen) und je
Cupping eine Datei `cupping-sessions/cup-<datum>-<zeit>-<id>.json`
(`format_version: 4`, ca. 60–75 KB). Alte Cuppings bis 14.09.2026 liegen
unverändert in `archive/`. Flavour Wheels als JSON (`wheels/buch.json`, `sca.json`).

**API heute:** `GET /api/state`, `/api/session`, `/api/session/shared`,
`/api/roast`, `/api/export.csv` und ca. 20 POST-Routen (`session/*`, `sample/*`,
`participant/*`, `sheet/patch`, `roast/*`, `cupper/*`, `coffee/*`, `settings`).
Mehrere Geräte gleichen alle 5 s ab, Speichern ohne Knopf mit Wiederholung.

**Plan (Stand 12.10.2026):** Die Web-App läuft auf dem Firmenserver als
Python-Dienst hinter tosto, das JSON-Format 4 bleibt, die vorhandenen Daten werden
übernommen. Die Oberfläche wird zum Web Component `<cupping-app>` (heute globale
Stile, feste Pfade `/css`, `/js`, `/api`, Hash-Router auf der Seiten-URL).

**Zu klären** (in roast-archive, siehe `../roast-archive/TOSTO.md`): woher die
Röstungen (`.alog`) auf dem Server kommen (Frage H2), Aufwand für den Umbau.

## Neue App aufnehmen (Checkliste, Entwurf)

1. App hält `KONVENTIONEN.md` ein (Web Component, `api`-Attribut, CSS-Variablen,
   `GET status`).
2. Manifest `app.json` im App-Repo, App läuft als eigener Dienst.
3. Recht `<id>` an die Benutzer vergeben, die die App sehen sollen.
4. Datenordner `<daten>/apps/<id>/` wird beim ersten Start angelegt.
5. Schnittstelle einrichten: `../<app>/TOSTO.md`, `schnittstelle/<app>.md`, Zeile in
   `.claude/schnittstelle.json` (siehe `schnittstelle/README.md`).
6. Eintrag in dieser Datei und in der Tabelle in `README.md`.
