# Entscheidungen & offene Punkte

Grundlage: [`initial_prompt.md`](../initial_prompt.md) und
[`fragen/01-portal.md`](../fragen/01-portal.md) (noch nicht beantwortet).

## Vorgaben (aus dem Auftrag, 07.10.2026)

| # | Thema | Entscheidung |
|---|-------|--------------|
| V1 | Name | Die Website heißt **tosto**. |
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

*(noch nichts, wartet auf den Fragenkatalog)*

## Offene Punkte

- Mit welchem System die Website des Chefs läuft (blockiert nichts, die Einbindung
  muss aber auch in WordPress funktionieren).
- Alles in `fragen/01-portal.md`.
