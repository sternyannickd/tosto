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

**Plan fürs Portal (aus `initial_prompt.md`):**

```
Browser ──► Portal (PHP): Produkte, MHD, EAN-Prüfung, Warteschlange, Protokoll
                 ▲
                 │  ausgehend per HTTPS, alle paar Sekunden, Geräte-Token
                 │
            Druckagent (Python, im labels-Repo) ──► zpl.py ──► Drucker (USB)
```

- Der Server schickt **strukturierte Aufträge**, keinen ZPL-Text.
- Auftragsstatus: wartet / wird gedruckt / gedruckt / Fehler. Nie doppelt drucken.
- Statusanzeige: Agent erreichbar (Lebenszeichen < ca. 30 s), Drucker bereit.
  In der App und als Symbol auf der Kachel.

**Was in PHP neu entsteht:** Produktliste lesen, EAN-13-Prüfziffer, MHD-Berechnung,
Warteschlange, Protokoll, API für Oberfläche und Agent. **Nicht** in PHP: ZPL
(bleibt beim Agenten).

**Zu klären:** Vorschau (braucht ZPL, das der Server bewusst nicht hat), Verfall
alter Aufträge, Produktpflege, Notbetrieb ohne Internet. Siehe Fragenkatalog F.

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

**Was fürs Portal nötig ist:**

- Server-Seite in PHP neu schreiben, **JSON-Format 4 beibehalten**, vorhandene
  Daten übernehmen. Score-Berechnung (SCA-104 §5.5) und Prüfregeln aus Python nach
  PHP übertragen, gegen dieselben Testfälle prüfen.
- Oberfläche zum Web Component `<cupping-app>` umbauen (heute globale Stile,
  feste Pfade `/css`, `/js`, `/api`, Hash-Router auf der Seiten-URL).
- **Röstungskatalog:** Heute liest die App `.alog`-Dateien aus einem Ordner. Auf dem
  Server gibt es diese Dateien nicht, und PHP müsste das Python-Format erst lesen
  lernen. Siehe Fragenkatalog G2.

## Neue App aufnehmen (Checkliste, Entwurf)

1. App hält `KONVENTIONEN.md` ein (Web Component, `api`-Attribut, CSS-Variablen,
   `GET status`).
2. `apps/<id>/app.json` anlegen, PHP-API unter `apps/<id>/`.
3. Recht `<id>` an die Benutzer vergeben, die die App sehen sollen.
4. Datenordner `<daten>/apps/<id>/` wird beim ersten Start angelegt.
5. Eintrag in dieser Datei und in der Tabelle in `README.md`.
