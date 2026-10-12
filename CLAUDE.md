# TOSTO – Portal für die Apps der Rösterei

**TOSTO** steht für **T**ools **O**f **S**pecialty **T**asting & r**O**asting.
Im Code, in Pfaden und Adressen klein: `tosto`.

`tosto` ist die Website (`https://tosto.internal.stern-kaffee.de`, nur im Netz der
Rösterei), über die alle kleinen
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
| [`docs/HOSTING.md`](docs/HOSTING.md) | Firmenserver: Fakten, Aufbau, Aufgaben (DNS, VM, HTTPS) |
| [`docs/ENTSCHEIDUNGEN.md`](docs/ENTSCHEIDUNGEN.md) | Was entschieden ist und warum, offene Punkte |
| [`fragen/`](fragen/) | Fragenkataloge mit Empfehlung und Antwortzeile |
| [`schnittstelle/`](schnittstelle/) | Nachrichten der Apps an tosto, Regeln der Schnittstelle |

## Zugehörige Projekte

| App | Pfad | Kurz |
|-----|------|------|
| Etikettendruck | `../labels` | Python, ZPL an Citizen CL-S521, hat schon `<etiketten-app>` |
| Cupping / Röstarchiv | `../roast-archive` | Python, SCA Coffee Value Assessment, JSON-Dateien, lokale Web-App |

Weitere Apps kommen dazu. Alles, was eine App braucht, um ins Portal zu kommen,
muss in `KONVENTIONEN.md` und einem App-Manifest stehen, nicht im Portal-Code
verstreut. Eine neue App darf keine Änderung am Portal-Kern erfordern.

## Feste Rahmenbedingungen

- **Hosting: Firmenserver** (Minisforum, AlmaLinux, FreeIPA-Domain-Controller),
  nur im Netz der Rösterei. Die Apps bleiben **Python**, der Drucker hängt per USB
  am Server. Weil der Server Domain Controller ist, laufen die Apps **abgeschottet**
  (Vorschlag: eigene VM, Frage B1). Siehe `docs/HOSTING.md`.
- **Kein Build-Schritt:** was im Repo liegt, wird so ausgeliefert.
- **Keine Datenbank.** JSON-Dateien, atomar geschrieben (temporäre Datei + `rename`)
  und mit `flock` gesperrt.
- **Daten, Konfiguration und Geheimnisse liegen außerhalb des Webverzeichnisses**,
  Pfad konfigurierbar. Geheimnisse kommen nie ins Git.
- **Sicherheit hat Vorrang.** Nur Mitarbeitende der Rösterei. Keine
  Selbstregistrierung. Argon2id, optionale TOTP-2FA, CSRF-Schutz, Sperre nach
  Fehlversuchen, Sicherheits-Header, Login-Protokoll.
- **Wenige Abhängigkeiten.** Fremde Pakete nur, wo es um Sicherheit geht, und nur
  bewährte, gepflegte.
- **Frontend:** reines JavaScript als Web Components (Custom Elements), Design über
  CSS-Variablen.

## Arbeitsweise

- **Dokumentation und Oberfläche auf Deutsch**, schlicht und wartbar. Die Leute,
  die das benutzen, arbeiten in einer Rösterei, nicht in der IT.
- Stil der Dokumente wie im Etiketten-Projekt: kurze Sätze, Tabellen, Begründung
  zu jeder Entscheidung.
- Fragen an den Nutzer als Fragenkatalog in `fragen/NN-thema.md`: jede Frage mit
  **Empfehlung** und `→ Antwort:`-Zeile, blockierende Fragen mit ⚠️.
  **Der Nutzer beantwortet die Fragen direkt in der Datei** und gibt Bescheid;
  Claude überträgt die Antworten dann nach `docs/ENTSCHEIDUNGEN.md`.
- Jede Entscheidung landet in `docs/ENTSCHEIDUNGEN.md` (Nummer aus dem
  Fragenkatalog, Entscheidung, ggf. Begründung).
- **Schnittstelle zu den App-Repos** ([`schnittstelle/README.md`](schnittstelle/README.md)):
  `../labels` und `../roast-archive` werden nur gelesen, mit einer Ausnahme:
  Nachrichten an eine App schreibt tosto in **`../<app>/TOSTO.md`** (dort nicht
  committen). Die Apps antworten in **`schnittstelle/<app>.md`** hier. Ein Hook
  (`.claude/hooks/schnittstelle.py`) sperrt alle anderen Schreibzugriffe.
- **Zu Beginn jeder Sitzung** `git status` prüfen: Ist `schnittstelle/*.md`
  geändert, hat eine App etwas mitgeteilt. Lesen, übernehmen, mitcommitten.
- Änderungen an den Apps selbst (Web Component, Druckweg, Vorschau, Sync)
  passieren in den App-Projekten, nie von hier aus.
- **Git:** nach jedem abgeschlossenen Schritt committen **und** auf GitHub
  (`origin/main`) pushen, ohne nachzufragen. Das berührt den Server nicht.
- **Ein Thema je Sitzung** (Plan, Subdomain, Login, …). Der Stand muss deshalb
  immer in den Dateien stehen, nicht nur im Chat: Entscheidungen in
  `docs/ENTSCHEIDUNGEN.md`, Server-Aufgaben in `docs/HOSTING.md`.
- **Sensible Daten** (IP-Adressen, Rechnernamen, Ausgaben vom Server) liegen nur
  in **`lokal/`** (im `.gitignore`, wird nie committet). Daraus nur allgemeine
  Fakten in committete Dateien übernehmen (z. B. „AlmaLinux 9, Python 3.12“), nie
  Adressen, Benutzernamen oder Schlüssel. Passwörter und private Schlüssel braucht
  Claude nie und fragt nicht danach.
- **Kein Zugang zum Domain Controller für Claude.** Befehle, die root brauchen,
  bereitet Claude vor und erklärt sie, der Nutzer führt sie aus.
- Vor einer Bereitstellung auf den Server immer nachfragen.
