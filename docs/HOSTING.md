# Hosting

Zwei mögliche Orte, Entscheidung offen (Frage A0): **Plesk-Webspace** (unten) oder
der **Firmenserver**.

## Möglichkeit: Firmenserver (Stand 12.10.2026)

| | |
|---|---|
| Gerät | Minisforum Mini-PC, Leistung reicht weit |
| System | AlmaLinux, **FreeIPA Domain Controller** für die Mint-PCs |
| Drucker | Citizen CL-S521 kann **direkt per USB** angeschlossen werden |
| DNS | FreeIPA-DNS: `ipa dnsrecord-add <zone> tosto --a-rec <IP>`. Tablets/Handys fragen meist den Router, also den Router per DHCP auf FreeIPA als DNS zeigen lassen oder den Namen dort zusätzlich eintragen |
| Zertifikat | Unteradresse der echten Domain + Let's Encrypt (DNS-Challenge), sonst FreeIPA-CA (dann CA auf allen Geräten installieren) |
| Python | AlmaLinux 9 hat 3.9, labels braucht ≥ 3.11 → `dnf install python3.12` oder im Container |
| Von außen | nur per VPN (z. B. WireGuard am Router) |

**Abschottung, weil der Server Domain Controller ist:** jede App als Podman-Container
unter einem eigenen Benutzer ohne Rechte, nur der eigene Datenordner eingebunden
(labels zusätzlich das USB-Gerät `/dev/usb/lp0`). Davor ein Webserver (Caddy oder
nginx) für HTTPS und Anmeldung. Alternative: eine kleine VM (Cockpit/KVM).

## Möglichkeit: Plesk-Webspace

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
