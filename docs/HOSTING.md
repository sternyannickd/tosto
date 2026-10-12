# Hosting

**Entschieden (12.10.2026): Firmenserver**, nur im Netz der Rösterei.
Adresse: `https://tosto.internal.stern-kaffee.de` (Schreibweise wird in Frage A2
bestätigt).

Genaue Werte (IP-Adressen, Rechnernamen) stehen nur in `lokal/` und nie im Git.

## Firmenserver

| | |
|---|---|
| Gerät | Minisforum Mini-PC, Leistung reicht weit |
| System | AlmaLinux, **FreeIPA-Domain-Controller** für die Mint-PCs |
| Python | 3.12 laut Nutzer installiert, wird mit `scripts/server-fakten.sh` bestätigt |
| Drucker | Citizen CL-S521 wird **direkt per USB** angeschlossen |
| Webserver | FreeIPA belegt mit seinem eigenen Apache die Ports **80 und 443** |
| Von außen | nicht erreichbar, bei Bedarf später per VPN am Router |

## Geplanter Aufbau (Vorschlag, Fragen B1 und E1)

```
Firmenserver (FreeIPA, unverändert)
└── VM „tosto“ (AlmaLinux, eigene IP-Adresse, Drucker per USB durchgereicht)
    ├── Caddy         HTTPS auf 443, fragt tosto vor jeder Anfrage nach der Anmeldung
    ├── tosto         Anmeldung (FreeIPA-Konten), Übersicht, Design
    ├── labels        Python-Dienst auf 127.0.0.1
    └── roast-archive Python-Dienst auf 127.0.0.1
```

**Warum eine VM:** Der Server ist Domain Controller. Eine Lücke in einer Web-App
darf nicht zu FreeIPA führen. Die VM trennt das vollständig, bekommt eine eigene
IP-Adresse (kein Konflikt mit FreeIPAs Ports 80/443) und lässt sich getrennt
sichern und aktualisieren.

**Rollen:** Befehle mit root (VM, Pakete, Firewall, DNS in FreeIPA) führt der Nutzer
aus, Claude bereitet sie vor. Claude bekommt nie Zugang zum Domain Controller,
höchstens per SSH-Schlüssel einen Benutzer `tosto` ohne root in der VM (Frage B2).

## DNS

- FreeIPA betreibt das DNS für das interne Netz. Eintrag für tosto, sobald die VM
  ihre IP-Adresse hat:
  `ipa dnsrecord-add <zone> tosto --a-rec <IP-der-VM>` (Zone je nachdem, ob
  `internal.stern-kaffee.de` als eigene Zone in FreeIPA angelegt wird).
- Tablets und Handys fragen meist den **Router**. Der muss Anfragen für
  `internal.stern-kaffee.de` an FreeIPA weiterleiten (oder FreeIPA wird per DHCP als
  DNS-Server verteilt). Hängt vom Router ab (Frage C2).
- **Nicht** `.local` verwenden (mDNS-Konflikte).

## HTTPS

- Bevorzugt: **Let's Encrypt mit DNS-Challenge.** Funktioniert, ohne dass tosto aus
  dem Internet erreichbar ist, braucht aber eine DNS-API beim Anbieter von
  `stern-kaffee.de` (Frage C1). Caddy erneuert dann automatisch.
- Sonst: Zertifikat von der **FreeIPA-Zertifizierungsstelle**. Dann muss deren
  Stammzertifikat auf jedem Tablet und Handy einmal installiert werden.

## Noch zu tun (gemeinsam, Schritt für Schritt)

- [ ] Server-Fakten sammeln: `scripts/server-fakten.sh` → `lokal/server-fakten.txt`
- [ ] VM anlegen (nach Antwort auf B1), Drucker per USB durchreichen
- [ ] DNS-Eintrag in FreeIPA, Weiterleitung im Router einrichten
- [ ] HTTPS-Zertifikat einrichten
- [ ] Sicherung des Datenordners einrichten

## Plesk-Webspace (nicht mehr geplant)

Bis 12.10.2026 war ein Plesk-Webspace mit PHP 8.1 vorgesehen (SSH-Abfrage vom
07.10.2026: Ubuntu 22.04, PHP 8.1 mit `sodium`/`openssl`, Composer, kein
Node.js/Python nutzbar). Er bleibt eine Möglichkeit, falls die Apps später in die
öffentliche Website des Chefs sollen.
