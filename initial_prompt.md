Angepasster Prompt

Geändert habe ich Folgendes: Die Technik steht jetzt fest (PHP, kein Node.js oder Python auf dem Server), die Statusanzeige ist eine Anforderung, der Datenordner ist genauer beschrieben, und die Plesk-Fakten sind eingetragen.

# Projekt: Rösterei-Portal

Ich arbeite in einer Kaffeerösterei und entwickle kleine Web-Apps für den Betrieb.
Dieses Projekt ist das **Portal**: eine Website auf einer Subdomain meines Plesk-Webspace
(z. B. apps.<domain>), über die alle Apps einheitlich und nur für Mitarbeitende
erreichbar sind. Die Apps selbst leben in **eigenen Projekten/Repos** und bleiben dort.

## Ziele
1. **Ein Ort für alle Apps**: Login, danach eine Übersicht mit Kacheln für jede App.
2. **Modular**: Jede App muss sich später auch in die Website meines Chefs einbinden
   lassen (System noch unbekannt, möglicherweise WordPress). Das
   dass das funktioniert.
3. **Design der Website übernehmen**: Die Apps übernehmen Farben/Schriften der
   einbindenden Seite.
4. **Sicherheit hat Vorrang**: Nur Leute aus der Rösterei kommen hinein.

## Hosting (geklärt)
- Plesk-Webspace, Subdomain für das Portal. **SSL-Zertifikate**
  **SSH-Zugang** sind vorhanden.
- **Server-Seite: PHP.** Node.js und Python sind im Panel nicht en.
  PHP-Version und Erweiterungen: <AUSGABE VON php -v / php -m / composer --version EINFÜGEN>
- Kein Build-Schritt auf dem Server. Was ausgeliefert wird, lieg
- Daten und Konfiguration liegen in einem eigenen Ordner **außerhalb des Webverzeichnisses**
  (z. B. `/var/www/vhosts/<domain>/daten/`), keine Datenbank. Der Pfad wird konfiguriert, nicht fest
  eingetragen.
- Bereitstellung bevorzugt über Plesk-Git oder ein einfaches Skript per SSH. Schlage vor,
  was robuster ist.

## Architektur-Leitlinien (Vorschlag, bitte kritisch prüfen)
- Jede App liefert **ein Web Component** (Custom Element, z. B. `<etiketten-app>`)
  plus eine **JSON-API in PHP**. Kein Build-Schritt, reines Java
- Die Adresse der API wird per Attribut übergeben (`<etiketten-app api="…">`), die App
  setzt keinen Server voraus.
- Das Design kommt über **CSS-Variablen** (`--farbe-primaer`, `--schrift`, `--radius` …),
  die das Portal in einer `theme.css` setzt. Apps haben sinnvoll
- Die **Anmeldung erledigt die einbindende Seite**, nicht die App. Die App-APIs
  prüfen die Sitzung über eine kleine, austauschbare Schnittstelle, damit sie später
  hinter der Anmeldung einer anderen Website laufen können.
- Diese Regeln bilden den Vertrag für alle Apps und gehören in eine **`KONVENTIONEN.md`**
  in diesem Repo. Die App-Projekte verweisen in ihrer CLAUDE.md darauf.
- Wenige Abhängigkeiten. Composer-Pakete nur, wo es um Sicherheit geht (z. B. TOTP),
  und nur bewährte, gepflegte Pakete.

## Sicherheitsanforderungen
- Login-Seite mit Benutzername + Passwort. **Keine Selbstregistrierung**. Konten legt ein
  Admin an (Admin-Oberfläche oder PHP-Kommandozeilenskript per S
- Passwörter mit `password_hash()` und **Argon2id** (Ausweichlösung: bcrypt).
- **2FA per TOTP** (Authenticator-App), **pro Benutzer optional** einschaltbar, dazu
  **Wiederherstellungscodes**. Ein Admin kann 2FA für alle verpf
- Sitzungs-Cookies: `HttpOnly`, `Secure`, `SameSite=Lax/Strict`, `session_regenerate_id()`
  nach dem Login, Ablauf nach Inaktivität.
- **CSRF-Schutz** für alle schreibenden Anfragen.
- **Schutz gegen Durchprobieren**: Anfragebegrenzung und zeitweise Sperre nach Fehlversuchen.
- Nur HTTPS. Sicherheits-Header: HSTS, Content-Security-Policy,
  Referrer-Policy.
- Im Webverzeichnis liegt nur, was öffentlich sein darf (Einstie
  Logik, Daten und Geheimnisse liegen außerhalb. Geheimnisse nicht ins Git.
- Protokoll über Logins und fehlgeschlagene Versuche.

## Datenablage (JSON-Dateien)
- Kleine Datenmengen, deshalb JSON-Dateien statt Datenbank.
- Schreiben **atomar** (temporäre Datei + `rename`) und mit **`flock`**-Sperre.
- Eine Backup-Lösung vorsehen (Plesk-Backup und/oder tägliche Kopie per Cron).

## Milestone 1: Etiketten und Cupping integrieren

### App 1: Etikettendruck
Pfad: `C:\Users\yannickdengler\Documents\claude projects\labels`
(README.md, docs/ARCHITEKTUR.md und docs/ENTSCHEIDUNGEN.md lesen)
- Bisher Python ≥ 3.11 (nur Standardbibliothek), lokal betrieben
  Citizen CL-S521 (57 × 32 mm, Titel + EAN-13 + MHD). Oberfläche in `etiketten/static/`
  ohne Build-Schritt, JSON-API in `server.py`, Ablauf in `dienst
  `drucker.py`. Produkte in `data/produkte.csv`, Druckprotokoll als CSV.
- **Besonderheit:** Der Drucker hängt per USB an einem Rechner in der Rösterei
  (Linux Mint, später vermutlich ein Raspberry Pi). Der Webserve
- **Geplanter Aufbau:**
  - Im Portal (PHP): Oberfläche, Produktliste, MHD-Berechnung, EAN-Prüfung,
    **Druckwarteschlange** und Druckprotokoll.
  - Ein **Druckagent** (Python, im Etiketten-Projekt) läuft am Drucker. Er fragt per
    ausgehendem HTTPS alle paar Sekunden nach Aufträgen. Anmeldung mit **Geräte-Token**,
    das im Portal sperrbar ist (kein Benutzerkonto).
  - Der Server schickt **strukturierte Aufträge** (Produkt, Name, GTIN, MHD, Menge),
    **keinen ZPL-Text**. Der Agent prüft sie und erzeugt den ZPL-Text selbst mit `zpl.py`.
  - Aufträge, die eingehen, während der Agent offline ist, bleib
    werden später gedruckt. Jeder Auftrag hat einen Status: wartet / wird gedruckt /
    gedruckt / Fehler (mit Meldung). Ein Auftrag darf nie doppelt gedruckt werden.
  - **Statusanzeige auf der Website:** Jede Nachfrage des Agente
    (Zeitpunkt speichern), dazu meldet er den Druckerzustand (`drucker.pruefen()`).
    Die Oberfläche zeigt sichtbar an, ob der **Agent erreichbar*
    letzte Lebenszeichen < ca. 30 s alt ist, sonst rot mit „zuletzt gesehen vor …“) und
    ob der **Drucker bereit** ist. Die Anzeige soll im Etiketten
    kleines Symbol auf der Portal-Kachel erscheinen.
- In **diesem** Projekt: Warteschlange, API-Endpunkte (auch für
  Einbindung planen und bauen, außerdem die API für den Agenten in `KONVENTIONEN.md`
  bzw. einer eigenen Doku festschreiben. Der Agent selbst und das Umbauen zum Web
  Component passieren im Etiketten-Projekt.

### App 2: Cupping
Pfad: `<PFAD ZUR CUPPING-APP>`
- Bewertung neuer Kaffeesorten. Läuft bisher lokal, Daten liegen in **JSON-Dateien**
  (sehr kleine Datenmengen). Bitte das Projekt untersuchen (Technik, Datenformat).
- Ziel: inklusive Daten im Portal hosten. Die Server-Seite wird
  bestehende JSON-Format möglichst beibehalten und die vorhandenen Daten übernehmen.

## Noch offen
- Mit welchem System die Website meines Chefs läuft (sollte die Entscheidungen nicht
  blockieren, aber die Einbindung muss auch in einem CMS wie Wor

## Vorgehen
1. Die beiden App-Projekte lesen und zusammenfassen, was du verstanden hast.
2. Einen Plan vorschlagen: Ordnerstruktur (was liegt im Webverze
   Entwurf der `KONVENTIONEN.md`, Sicherheitskonzept, API für den Druckagenten,
   Bereitstellung, Reihenfolge der Schritte. **Noch keinen Code, bevor ich den
   Plan freigegeben habe.**
3. Entscheidungen in `docs/ENTSCHEIDUNGEN.md` festhalten (wie im Etiketten-Projekt).

Bitte dokumentiere auf Deutsch, halte es schlicht und wartbar, i
der Arbeit in der Rösterei.

Vor dem Start musst du nur noch die beiden Platzhalter ausfüllen und den Pfad zur Cupping-App.