# Entscheidungen & offene Punkte

Grundlage: [`initial_prompt.md`](../initial_prompt.md),
[`fragen/01-portal.md`](../fragen/01-portal.md) (beantwortet am 12.10.2026) und
[`fragen/02-nachfragen.md`](../fragen/02-nachfragen.md).

## Vorgaben (aus dem Auftrag, 07.10.2026)

| # | Thema | Entscheidung |
|---|-------|--------------|
| V1 | Name | **TOSTO** – *Tools Of Specialty Tasting & rOasting*. In Code, Pfaden und Adressen klein: `tosto`. |
| V2 | Zweck | Ein Portal mit Login und einer Kachel pro App. Die Apps bleiben in eigenen Repos. Weitere Apps kommen dazu. |
| V3 | Server | ~~PHP auf dem Plesk-Webspace.~~ Ersetzt durch A1. Weiter gilt: kein Build-Schritt. |
| V4 | Daten | JSON-Dateien statt Datenbank, atomar und mit `flock` geschrieben, außerhalb des Webverzeichnisses, Pfad konfigurierbar. |
| V5 | Apps | Web Component + JSON-API, API-Adresse per Attribut, Design über CSS-Variablen. Vertrag in `KONVENTIONEN.md`. |
| V6 | Anmeldung | Erledigt tosto, nicht die App. |
| V7 | Sicherheit | Keine Selbstregistrierung, sichere Passwörter, sichere Cookies, CSRF-Schutz, Sperre nach Fehlversuchen, nur HTTPS, Sicherheits-Header, Login-Protokoll. 2FA erst später (D2). |
| V8 | Abhängigkeiten | Fremde Pakete nur für Sicherheit, nur bewährte. |
| V9 | Milestone 1 | Etikettendruck und Cupping einbinden. |
| V10 | Vorgehen | Erst Plan, dann Code. Doku auf Deutsch, schlicht. |

## Projekt und Arbeitsweise

| # | Thema | Entscheidung |
|---|-------|--------------|
| P1 | Rolle | tosto platziert die Apps auf dem Server. Die Apps werden in ihren eigenen Repos entwickelt (08.10.2026). |
| P2 | Arbeitsweise | Fragen werden in der Datei beantwortet. Nach jedem Schritt committen und pushen. Ein Thema je Sitzung (08.10.2026). |
| P3 | Schnittstelle | tosto schreibt `../<app>/TOSTO.md`, die App schreibt `schnittstelle/<app>.md`. Jede Datei hat einen Schreiber, der Empfänger committet. Ein Hook sperrt alles andere (12.10.2026). |
| P4 | Sensible Daten | Server-Ausgaben, IP-Adressen und Rechnernamen nur in `lokal/` (nie im Git). Claude bekommt keine Passwörter und keine privaten Schlüssel (12.10.2026). |
| P5 | Entwicklermodus | tosto **und** jede App lassen sich lokal starten und testen und sehen dabei **genauso aus und verhalten sich genauso** wie die gehostete Version. Siehe `KONVENTIONEN.md` Abschnitt 9 (12.10.2026). |

## Fragenkatalog 1 (beantwortet 12.10.2026)

| # | Thema | Entscheidung |
|---|-------|--------------|
| A1 | Hosting | **Firmenserver** (Minisforum, AlmaLinux 10.2, FreeIPA), nur im Netz der Rösterei. Apps bleiben Python. Drucker 1 per USB am Server. |
| A2 | Adresse | `https://tosto.internal.stern-kaffee.de` |
| A4 | Nutzer | ca. 10 Personen, Handys, Tablets **und PCs**. Oberfläche muss auf allen gut funktionieren. |
| A5 | Konten | Persönliche Konten, Anmeldung so einfach wie möglich. |
| A6 | Von außen | Vorerst kein Zugriff von außerhalb. |
| A7 | Repos | Alle GitHub-Repos privat. |
| B1 | Trennung vom DC | **Podman-Container direkt auf dem Server, keine VM.** Wie der Port-Konflikt mit FreeIPA (80/443) gelöst wird: Nachfrage N1. |
| B2 | Server-Zugang | Claude per SSH von diesem PC aus, **jeder SSH-Befehl wird bestätigt**. |
| B2.1 | root | Befristete sudo-Regel `/etc/sudoers.d/90-tosto-einrichtung` (eingerichtet 12.10.2026), **nach der Einrichtung wieder entfernen**. |
| B3 | Bereitstellung | `scripts/bereitstellen.sh`, feste Git-Tags, je Repo ein Schlüssel nur zum Lesen, Rollback über vorherigen Stand. |
| B4 | Betrieb | Server läuft rund um die Uhr. Keine USV, Stromausfall ist akzeptabel. |
| B5 | Sicherung | Täglich, 30 Tage aufheben. Ziel (Nextcloud oder NAS) später. |
| B6 | Internet | Server darf ins Internet (Updates, Let's Encrypt, Labelary). |
| B8 | nginx | Gehört zu einem anderen Projekt (`/srv/company-client-config`, Port 8444). Kein Konflikt mit tosto. |
| B9 | Vor Ort | Bildschirm und Tastatur sind am Server. |
| C1 | Domain | `stern-kaffee.de` liegt bei **STRATO**. DNS-API unklar, Folgen siehe N3. |
| C2 | Namensauflösung | Einfachste zuverlässige Lösung. Vorschlag: Eintrag im öffentlichen DNS bei STRATO (N2). |
| D1 | Konten | **Eigene tosto-Konten** mit Benutzername und Passwort, nicht FreeIPA. |
| D2 | 2FA | Vorerst nicht. |
| D3 | Admins | Du; der Chef hat ebenfalls alle Zugänge. |
| D4 | Sitzung | Abmeldung nach 60 Minuten ohne Aktivität. |
| D5 | Rechte | Im MVP keine Rechte: alle dürfen alles. Aufbau so, dass Rechte später ergänzt werden können. |
| D6 | Protokolle | Login-Protokoll 90 Tage, Druckprotokoll unbegrenzt. |
| E1 | Aufbau | Webserver vorne, tosto prüft zentral die Anmeldung, jede App als eigener Dienst. |
| E2 | Manifest | Liegt im App-Repo. |
| E3 | Status | Einheitliches Statusmuster für alle Apps. |
| E4 | Weitere Apps | Zweite Etiketten-App (Verpackungsetiketten), evtl. Kassenprotokolle. |
| E5 | Ohne tosto | Lokal im Entwicklermodus ja, im Betrieb nur über tosto (siehe P5). |
| E6 | Sprache | Alles auf Deutsch. roast-archive soll später Deutsch und Englisch können. |
| F1 | Design | **Eigenständiges Design**, nicht von der Rösterei-Website. Hochwertig, wird über eigene Vorgaben festgelegt. |
| F2 | Dunkles Design | Automatisch nach Geräteeinstellung. |
| F3 | Übersicht | Wie vorgeschlagen (Kopfzeile, Kacheln, „← Übersicht“). |
| G1 | Alte Druckaufträge | Verfallen nach 30 Minuten, falls es eine Warteschlange gibt. |
| G2 | Vorschau | Die Web-App bekommt eine Vorschau, Umsetzung entscheidet labels. |
| G3 | Produkte | Werden in der Web-App gepflegt. |
| G4 | Drucker | Für labels einer. Für die zweite Etiketten-App: Drucker am Client-PC, ZPL von dort (N4). |
| H1 | Cupping | Die ganze Web-App kommt in tosto. Wie Artisan künftig angebunden wird, wird neu überlegt. |
| H3 | Cupping-Daten | Server ist nach der Übernahme der einzige Speicherort, Dateien unverändert übernehmen. |
| H4 | Cupper | Zunächst keine Verknüpfung mit Konten, später optional. |
| I1 | Reihenfolge | Wie vorgeschlagen, mit Entwicklermodus für alle Teile (P5). |

## Offene Punkte

- **N1–N5** in [`fragen/02-nachfragen.md`](../fragen/02-nachfragen.md), vor allem N1
  (Port-Konflikt) und N2 (freie IP-Adresse).
- **H2** Woher die Röstungen (`.alog`) kommen und wie Artisan angebunden wird.
- **H5** Name der Cupping-Kachel.
- **B5** Ziel der Sicherung.
- Mit welchem System die Website des Chefs läuft (blockiert nichts).
