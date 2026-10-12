# Entscheidungen & offene Punkte

Grundlage: [`initial_prompt.md`](../initial_prompt.md) und
[`fragen/01-portal.md`](../fragen/01-portal.md) (Fassung vom 12.10.2026, teilweise
beantwortet).

## Vorgaben (aus dem Auftrag, 07.10.2026)

| # | Thema | Entscheidung |
|---|-------|--------------|
| V1 | Name | **TOSTO** – *Tools Of Specialty Tasting & rOasting*. In Code, Pfaden und Adressen klein: `tosto`. |
| V2 | Zweck | Ein Portal mit Login und einer Kachel pro App. Die Apps bleiben in eigenen Repos. Weitere Apps kommen dazu. |
| V3 | Server | ~~PHP auf dem Plesk-Webspace.~~ Ersetzt durch A1. Weiter gilt: kein Build-Schritt. |
| V4 | Daten | JSON-Dateien statt Datenbank, atomar und mit `flock` geschrieben, außerhalb des Webverzeichnisses, Pfad konfigurierbar. |
| V5 | Apps | Web Component + JSON-API, API-Adresse per Attribut, Design über CSS-Variablen. Vertrag in `KONVENTIONEN.md`. |
| V6 | Anmeldung | Erledigt tosto, nicht die App. |
| V7 | Sicherheit | Keine Selbstregistrierung, sichere Passwörter, 2FA möglich, sichere Cookies, CSRF-Schutz, Sperre nach Fehlversuchen, nur HTTPS, Sicherheits-Header, Login-Protokoll. |
| V8 | Abhängigkeiten | Fremde Pakete nur für Sicherheit, nur bewährte. |
| V9 | Milestone 1 | Etikettendruck und Cupping einbinden. |
| V10 | Vorgehen | Erst Plan, dann Code. Doku auf Deutsch, schlicht. |

## Entschieden

| # | Thema | Entscheidung |
|---|-------|--------------|
| A1 | Hosting | **Firmenserver** (Minisforum, AlmaLinux, FreeIPA), nur im Netz der Rösterei. Apps bleiben Python, **Drucker per USB am Server**. Damit entfallen PHP-Neubau, Druckagent und Warteschlange über das Internet (12.10.2026). |
| A3 | Name | siehe V1 |
| P1 | Rolle des Projekts | tosto platziert die Apps auf dem Server. Die Apps werden in ihren eigenen Repos entwickelt (08.10.2026). |
| P2 | Arbeitsweise | Fragen werden **in der Datei** beantwortet. Nach jedem Schritt committen und pushen. Ein Thema je Sitzung (08.10.2026). |
| P3 | Schnittstelle | Die Projekte sprechen über Schnittstellen-Dateien: tosto schreibt `../<app>/TOSTO.md`, die App schreibt `schnittstelle/<app>.md`. Jede Datei hat einen Schreiber, der Empfänger committet. Ein Hook sperrt alles andere (12.10.2026). |
| P4 | Sensible Daten | Server-Ausgaben, IP-Adressen und Rechnernamen nur in `lokal/` (nie im Git). Claude bekommt keine Passwörter, keine privaten Schlüssel und keinen Zugang zum Domain Controller (12.10.2026). |
| G1 | Alte Druckaufträge | Verfallen nach **30 Minuten**, falls es eine Warteschlange gibt (08.10.2026). |
| G2 | Vorschau | **Die Web-App bekommt eine Vorschau.** Umsetzung entscheidet labels (T2 in `../labels/TOSTO.md`). |

## Offene Punkte

- Alles in `fragen/01-portal.md`, zuerst die mit ⚠️: A2, B1, B2, C1, D1, E1, F1, H1.
- **H2** Woher die Röstungen (`.alog`) auf dem Server kommen: wird später entschieden.
- Mit welchem System die Website des Chefs läuft (blockiert nichts).
