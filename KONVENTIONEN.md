# Konventionen für Apps im Portal

> **Entwurf vom 07.10.2026, angepasst am 12.10.2026 an den Firmenserver, noch nicht
> freigegeben.** Grundlage: `initial_prompt.md`
> und die Antworten in [`fragen/01-portal.md`](fragen/01-portal.md). Bis zur Freigabe
> kann sich hier alles ändern.

Diese Regeln sind der Vertrag zwischen dem Portal (`tosto`) und jeder App. Eine App,
die sie einhält, lässt sich ins Portal **und** in eine andere Website (z. B. die
Website des Chefs, evtl. WordPress) einbinden, ohne ihren Code zu ändern.

Die App-Repos verweisen in ihrer `CLAUDE.md` auf diese Datei.

## 1. Eine App besteht aus drei Teilen

| Teil | Technik | Wo |
|------|---------|----|
| **Oberfläche** | ein Web Component (Custom Element), reines JavaScript, kein Build-Schritt | im App-Repo |
| **Server-Seite** | JSON-API, eigener Dienst (heute Python) | im App-Repo |
| **Manifest** | `app.json`: Name, Kachel, Element, API, Start, Statusabfrage | im App-Repo (Frage E2) |

Eine App setzt **keinen bestimmten Server** voraus. Sie kennt nur die Adresse ihrer
API, die ihr per Attribut übergeben wird.

## 2. Oberfläche: Web Component

```html
<script type="module" src="/apps/etiketten/etiketten-app.js"></script>
<etiketten-app api="/api/etiketten"></etiketten-app>
```

- **Name des Elements:** `<id>-app`, z. B. `<etiketten-app>`, `<cupping-app>`.
- **Pflicht-Attribut `api`:** Basisadresse der JSON-API. Weitere Attribute
  beschreibt die App selbst in ihrem Kopfkommentar.
- **Kapselung über Shadow DOM.** Die App bringt ihr eigenes CSS mit und lädt es
  relativ zu ihrer Skriptdatei (`new URL("app.css", import.meta.url)`).
- **Keine globalen Seiteneffekte:** kein Schreiben in `document.title`, keine
  globalen Stile, keine globalen Variablen. Navigation innerhalb der App über den
  Hash oder internen Zustand, nie über die Seiten-URL der einbindenden Seite.
- **Abhängigkeiten:** keine Fremdbibliotheken aus dem Internet (CDN). Wenn eine
  nötig ist, liegt sie im App-Repo.

## 3. Design: CSS-Variablen

Das Portal setzt die Variablen in `theme.css`. Jede App hat für **jede** Variable
einen sinnvollen Standardwert, sieht also auch ohne Portal ordentlich aus.

| Variable | Bedeutung |
|----------|-----------|
| `--farbe-flaeche` | Hintergrund von Karten/Flächen |
| `--farbe-text` | Haupttext |
| `--farbe-text-leise` | Nebentext, Hinweise |
| `--farbe-linie` | Rahmen, Trennlinien |
| `--farbe-akzent` | Hauptfarbe (Knöpfe, Auswahl) |
| `--farbe-akzent-text` | Text auf der Akzentfarbe |
| `--farbe-akzent-hell` | helle Variante (Hintergrund ausgewählter Elemente) |
| `--farbe-gut` / `--farbe-warn` / `--farbe-schlecht` | Status grün / gelb / rot |
| `--schrift` | Schriftfamilie |
| `--radius` | Eckenrundung |

Die Namen stammen aus `<etiketten-app>`, das sie bereits verwendet. Neue Variablen
kommen nur hier hinzu, nicht still in einer App.

## 4. Anmeldung: macht die einbindende Seite

- Die App hat **keine eigene Anmeldung** und keine Login-Maske.
- Auf dem Firmenserver prüft tosto die Anmeldung **zentral vor jeder Anfrage**
  (Frage E1). Die App bekommt Benutzer und Rechte als Kopfzeilen vom Webserver
  (Vorschlag: `X-Tosto-Benutzer`, `X-Tosto-Rechte`) und ist selbst nur über
  `127.0.0.1` erreichbar. Eine andere einbindende Website liefert später dieselben
  Angaben auf ihre Weise.
- **Schreibende Anfragen** (POST/PUT/DELETE) tragen ein CSRF-Token im Kopf
  `X-CSRF-Token`. Die einbindende Seite stellt es bereit (Vorschlag: `<meta
  name="csrf-token">`), die App liest es von dort.
- Ist die Sitzung abgelaufen, antwortet die API mit **401**. Die App zeigt dann
  einen Hinweis „Bitte neu anmelden“ und verliert keine Eingaben.

## 5. JSON-API

- Anfragen und Antworten sind JSON (`Content-Type: application/json`), UTF-8.
- Fehler: `{"ok": false, "fehler": "Text für Menschen"}` mit passendem Status
  (400 falsche Eingabe, 401 nicht angemeldet, 403 keine Berechtigung, 404, 409
  Konflikt, 503 Gerät nicht erreichbar). So macht es die Etiketten-API schon heute.
- **Jede Eingabe wird auf dem Server geprüft**, auch wenn die Oberfläche schon
  prüft.
- Jede App bietet `GET <api>/status` an: `{"ok": true|false, "meldung": "…"}`.
  Daraus macht das Portal das Symbol auf der Kachel (Frage E3).

## 6. Daten

- Ablage in **JSON-Dateien** im Datenordner außerhalb des Webverzeichnisses,
  pro App ein Unterordner: `<daten>/apps/<id>/`.
- Schreiben immer **atomar**
  (temporäre Datei + `rename`) und mit **`flock`**-Sperre.
- Jede Datei trägt ein Feld `format_version`. Ändert sich das Format, gibt es eine
  Übernahme (Migration), die die alte Datei unverändert sichert.

## 7. Geräte (z. B. Druckagent)

Geräte melden sich **nicht** mit einem Benutzerkonto an, sondern mit einem
**Geräte-Token**, das im Portal angelegt und gesperrt werden kann. Ein Gerät
spricht nur ausgehend per HTTPS mit dem Server. Die genaue Schnittstelle für den
Druckagenten kommt in `docs/API-DRUCKAGENT.md`.

## 8. Manifest `app.json` (Entwurf)

```json
{
  "id": "etiketten",
  "name": "Etikettendruck",
  "beschreibung": "Produktetiketten mit EAN und MHD drucken",
  "symbol": "etikett.svg",
  "element": "etiketten-app",
  "skript": "etiketten-app.js",
  "api": "/api/etiketten",
  "status": true,
  "recht": "etiketten"
}
```

Eine neue App = ein neuer Dienst plus ihr Manifest. Am
Portal-Kern ändert sich dafür nichts.

## 9. Entwicklermodus (Entwurf)

Ziel: tosto und jede App lassen sich **lokal** starten und sehen dabei **genauso aus
und verhalten sich genauso** wie auf dem Server.

- **App allein:** Jede App hat einen Startbefehl für die Entwicklung (z. B.
  `python -m etiketten dev`). Er startet die App auf `127.0.0.1` und zeigt sie in
  einer Entwicklerseite **im tosto-Rahmen**: dieselbe `theme.css`, dieselbe
  Kopfzeile, dieselben Schriften. Den Rahmen liest die App aus `../tosto/rahmen/`
  (Pfad einstellbar). Fehlt tosto, läuft sie mit ihren eigenen Standardwerten.
- **tosto lokal:** `python -m tosto dev` startet das Portal mit Testkonten und
  leitet `/apps/<id>/` an die lokal laufenden Apps weiter, nach denselben Manifesten
  und Regeln wie auf dem Server.
- **Gleiche Grundlage:** Python 3.12 wie auf dem Server, Testdaten in einem eigenen
  Datenordner, nie die echten Daten.
- **Drucker:** Im Entwicklermodus druckt eine App standardmäßig in Dateien
  (labels: `transport = "datei"`), ein echter Drucker nur auf ausdrücklichen Wunsch.
- Vor einer Bereitstellung können dieselben Container auch lokal getestet werden
  (optional, später).
