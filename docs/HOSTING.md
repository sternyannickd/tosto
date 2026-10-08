# Hosting

Stand: Abfrage per SSH am 07.10.2026 (Rohausgabe liegt lokal in
`ausgabe_ssh.txt`, nicht im Git).

## Server

| | |
|---|---|
| System | Ubuntu 22.04.5 LTS, Plesk |
| Zugang | SSH vorhanden, SSL-Zertifikate vorhanden |
| PHP (Kommandozeile) | **8.1.2** (Ubuntu-Paket, mit OPcache), über `~/.phpenv` |
| Argon2id | verfügbar (`PASSWORD_ARGON2ID` ist definiert) |
| Erweiterungen | `json`, `mbstring`, `openssl`, `sodium` |
| Composer | 2.10.3 |
| Node.js | nicht aktiv (Versionen 20/21 installiert, aber nicht ausgewählt), wird nicht genutzt |
| Python | 3.10.12 vorhanden, wird auf dem Server nicht genutzt |
| Home | `/var/www/vhosts/<webspace>/` |

Im Home-Verzeichnis liegen bereits weitere Seiten (`httpdocs`, zwei Subdomains)
und ein `git`-Ordner von Plesk. Das Portal bekommt eine **eigene Subdomain** mit
eigenem Webverzeichnis (Frage C1).

## Auffälligkeiten

- **PHP 8.1** bekommt vom PHP-Projekt seit 31.12.2025 keine Sicherheitsupdates mehr.
  Ubuntu pflegt das Paket in 22.04 noch selbst, trotzdem lieber in Plesk für die
  Subdomain eine aktuelle Version (8.3 oder 8.4) wählen, falls angeboten (Frage C2).
  Der Code wird so geschrieben, dass er ab 8.1 läuft.
- Die PHP-Version im Panel (Web) kann von der auf der Kommandozeile abweichen.
  Nach dem Einrichten der Subdomain mit einer kleinen Prüfseite kontrollieren.

## Noch zu tun

- [ ] **Subdomain anlegen** – gemeinsam, Schritt für Schritt (Claude erklärt).
      Dabei: PHP 8.3/8.4 wählen, Webverzeichnis `tosto/public`, SSL-Zertifikat.

## Geplante Ordner auf dem Server (Vorschlag)

```
/var/www/vhosts/<webspace>/
  tosto/                 Code (Git-Stand), nicht öffentlich
    public/              ← Webverzeichnis der Subdomain zeigt hierher
  tosto-daten/           Daten + Konfiguration, nicht öffentlich, nicht im Git
    config.php
    benutzer.json
    apps/<id>/…
    protokoll/
    backup/
```
