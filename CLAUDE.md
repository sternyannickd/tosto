# TOSTO – Portal für die Apps der Rösterei

**TOSTO** steht für **T**ools **O**f **S**pecialty **T**asting & r**O**asting.
Im Code, in Pfaden und Adressen klein: `tosto`.

`tosto` ist die Website (Subdomain auf dem Plesk-Webspace), über die alle kleinen
Web-Apps der Rösterei mit **einem Login** erreichbar sind: Anmeldung, danach eine
Übersicht mit Kacheln, eine Kachel pro App. Die Apps leben in **eigenen Repos** und
bleiben dort. Das Portal liefert Anmeldung, Design, Datenablage und die Server-Seite.

Ausgangspunkt: [`initial_prompt.md`](initial_prompt.md).

## Stand

**Planungsphase.** Es gibt noch keinen Code. Erst wenn der Plan freigegeben ist,
wird gebaut. Offene Fragen stehen in [`fragen/01-portal.md`](fragen/01-portal.md),
Entscheidungen in [`docs/ENTSCHEIDUNGEN.md`](docs/ENTSCHEIDUNGEN.md).

## Wichtige Dateien

| Datei | Inhalt |
|-------|--------|
| [`KONVENTIONEN.md`](KONVENTIONEN.md) | Der Vertrag für alle Apps (Web Component, API, Design, Anmeldung). Die App-Repos verweisen darauf. |
| [`docs/APPS.md`](docs/APPS.md) | Welche Apps es gibt, wo sie liegen, was beim Einbinden zu tun ist |
| [`docs/HOSTING.md`](docs/HOSTING.md) | Fakten zum Server (PHP-Version, Erweiterungen, Pfade) |
| [`docs/ENTSCHEIDUNGEN.md`](docs/ENTSCHEIDUNGEN.md) | Was entschieden ist und warum, offene Punkte |
| [`fragen/`](fragen/) | Fragenkataloge mit Empfehlung und Antwortzeile |

## Zugehörige Projekte

| App | Pfad | Kurz |
|-----|------|------|
| Etikettendruck | `../labels` | Python, ZPL an Citizen CL-S521, hat schon `<etiketten-app>` |
| Cupping / Röstarchiv | `../roast-archive` | Python, SCA Coffee Value Assessment, JSON-Dateien, lokale Web-App |

Weitere Apps kommen dazu. Alles, was eine App braucht, um ins Portal zu kommen,
muss in `KONVENTIONEN.md` und einem App-Manifest stehen, nicht im Portal-Code
verstreut. Eine neue App darf keine Änderung am Portal-Kern erfordern.

## Feste Rahmenbedingungen

- **Server: nur PHP** (8.1 auf der Kommandozeile, siehe `docs/HOSTING.md`). Kein
  Node.js, kein Python auf dem Server. Kein Build-Schritt: was im Repo liegt, wird
  so ausgeliefert.
- **Keine Datenbank.** JSON-Dateien, atomar geschrieben (temporäre Datei + `rename`)
  und mit `flock` gesperrt.
- **Daten, Konfiguration und Geheimnisse liegen außerhalb des Webverzeichnisses**,
  Pfad konfigurierbar. Geheimnisse kommen nie ins Git.
- **Sicherheit hat Vorrang.** Nur Mitarbeitende der Rösterei. Keine
  Selbstregistrierung. Argon2id, optionale TOTP-2FA, CSRF-Schutz, Sperre nach
  Fehlversuchen, Sicherheits-Header, Login-Protokoll.
- **Wenige Abhängigkeiten.** Composer-Pakete nur, wo es um Sicherheit geht (z. B.
  TOTP), und nur bewährte, gepflegte Pakete.
- **Frontend:** reines JavaScript als Web Components (Custom Elements), Design über
  CSS-Variablen.

## Arbeitsweise

- **Dokumentation und Oberfläche auf Deutsch**, schlicht und wartbar. Die Leute,
  die das benutzen, arbeiten in einer Rösterei, nicht in der IT.
- Stil der Dokumente wie im Etiketten-Projekt: kurze Sätze, Tabellen, Begründung
  zu jeder Entscheidung.
- Fragen an den Nutzer als Fragenkatalog in `fragen/NN-thema.md`: jede Frage mit
  **Empfehlung** und `→ Antwort:`-Zeile, blockierende Fragen mit ⚠️.
- Jede Entscheidung landet in `docs/ENTSCHEIDUNGEN.md` (Nummer aus dem
  Fragenkatalog, Entscheidung, ggf. Begründung).
- **Die App-Repos (`../labels`, `../roast-archive`) sind von hier aus nur zum
  Lesen da.** Dieses Projekt platziert die Apps auf der Website, mehr nicht.
  Änderungen an den Apps (Web Component, Druckagent, Vorschau, Sync) passieren in
  den App-Projekten. `.claude/settings.json` sperrt Schreibzugriffe dorthin.
  Fragen, die eine App betreffen, werden hier nur notiert (`docs/FUER-APPS.md`).
- Vor einer Bereitstellung auf den Server immer nachfragen.
