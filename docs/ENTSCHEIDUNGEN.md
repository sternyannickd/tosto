# Entscheidungen & offene Punkte

Grundlage: [`initial_prompt.md`](../initial_prompt.md) und
[`fragen/01-portal.md`](../fragen/01-portal.md) (teilweise beantwortet).

## Vorgaben (aus dem Auftrag, 07.10.2026)

| # | Thema | Entscheidung |
|---|-------|--------------|
| V1 | Name | **TOSTO** – *Tools Of Specialty Tasting & rOasting*. In Code, Pfaden und Adressen klein: `tosto`. |
| V2 | Zweck | Ein Portal mit Login und einer Kachel pro App. Die Apps bleiben in eigenen Repos. Weitere Apps kommen dazu. |
| V3 | Server | PHP auf dem Plesk-Webspace. Kein Node.js, kein Python auf dem Server, kein Build-Schritt. |
| V4 | Daten | JSON-Dateien statt Datenbank, atomar und mit `flock` geschrieben, außerhalb des Webverzeichnisses, Pfad konfigurierbar. |
| V5 | Apps | Web Component + JSON-API, API-Adresse per Attribut, Design über CSS-Variablen. Vertrag in `KONVENTIONEN.md`. |
| V6 | Anmeldung | Erledigt die einbindende Seite, die App-APIs prüfen über eine austauschbare Schnittstelle. |
| V7 | Sicherheit | Keine Selbstregistrierung, Argon2id, TOTP-2FA optional (Admin kann sie erzwingen) mit Wiederherstellungscodes, sichere Cookies, CSRF-Schutz, Sperre nach Fehlversuchen, nur HTTPS, Sicherheits-Header, Login-Protokoll. |
| V8 | Abhängigkeiten | Composer nur für Sicherheit (z. B. TOTP), nur bewährte Pakete. |
| V9 | Milestone 1 | Etikettendruck (mit Druckagent und Statusanzeige) und Cupping einbinden. |
| V10 | Vorgehen | Erst Plan, dann Code. Doku auf Deutsch, schlicht. |

## Entschieden

| # | Thema | Entscheidung |
|---|-------|--------------|
| P1 | Rolle des Projekts | tosto platziert die Apps auf der Website. Die App-Repos werden von hier aus **nur gelesen**, nie geändert (08.10.2026). Ob tosto später die App-Projekte mitsteuert, ist offen. |
| A5 | Bedeutung des Namens | siehe V1 |
| C2 | PHP-Version | Ok: in Plesk nach 8.3/8.4 für die Subdomain schauen. |
| F2 | Alte Druckaufträge | Aufträge **verfallen nach 30 Minuten** und müssen neu ausgelöst werden. |
| F4 | Vorschau | **Die Web-App bekommt eine Vorschau.** Idee: Der Server erzeugt ZPL nur für die Vorschau, gedruckt wird weiter das ZPL des Agenten. Wie genau, entscheidet das labels-Projekt (siehe `docs/FUER-APPS.md`). |

## Offene Punkte

- **G2** Wie die Röstungen (`.alog`) ins Portal kommen: wird später überlegt.
- **Subdomain in Plesk anlegen:** Anleitung Schritt für Schritt, wenn es so weit
  ist (gewünscht am 08.10.2026, siehe `docs/HOSTING.md`).
- Mit welchem System die Website des Chefs läuft (blockiert nichts, die Einbindung
  muss aber auch in WordPress funktionieren).
- Alles in `fragen/01-portal.md`.
