# Konventionen für Apps im Portal

> **Entwurf vom 07.10.2026, noch nicht freigegeben.** Grundlage: `initial_prompt.md`
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
| **Server-Seite** | JSON-API in PHP | Vorschlag: `apps/<id>/` im Portal-Repo (Frage B2) |
| **Manifest** | `app.json`: Name, Kachel, Element, API, Statusabfrage | `apps/<id>/app.json` |

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
  Hash oder internen Zustand, nie über die Seiten-URL der einbindenden Seite (Frage G4).
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
- Die PHP-API der App fragt die Anmeldung über eine kleine Schnittstelle ab,
  z. B. `Auth::aktuellerBenutzer(): ?Benutzer` und `Auth::darf(string $recht): bool`.
  Das Portal liefert eine Umsetzung, eine andere Website später ihre eigene.
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
  Daraus macht das Portal das Symbol auf der Kachel (Frage B6).

## 6. Daten

- Ablage in **JSON-Dateien** im Datenordner außerhalb des Webverzeichnisses,
  pro App ein Unterordner: `<daten>/apps/<id>/`.
- Lesen und Schreiben nur über die Ablage-Klasse des Portals: **atomar**
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

Eine neue App = ein neuer Ordner unter `apps/` plus ihre Oberflächendateien. Am
Portal-Kern ändert sich dafür nichts.
