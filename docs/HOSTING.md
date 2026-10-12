# Hosting

**Entschieden (12.10.2026): Firmenserver**, nur im Netz der Rösterei.
Adresse: `https://tosto.internal.stern-kaffee.de` (Schreibweise wird in Frage A2
bestätigt).

Genaue Werte (IP-Adressen, Rechnernamen) stehen nur in `lokal/` und nie im Git.

## Firmenserver

| | |
|---|---|
| Gerät | Minisforum EliteMini, AMD Ryzen 7 255 (16 Threads), 28 GB RAM, ca. 900 GB frei, Virtualisierung (AMD-V) vorhanden |
| System | **AlmaLinux 10.2** (Support bis 2035) |
| FreeIPA | 4.13, Domäne `server.lan`. FreeIPA ist auch **DNS-Server** des Netzes |
| Python | **3.12** ✔ (bestätigt 12.10.2026) |
| Belegte Ports | 80/443 (FreeIPA-Apache), 22, LDAP, Kerberos, DNS, 8080/8443/8444 (u. a. Zertifizierungsstelle), 9090 (**Cockpit**) |
| Weitere Dienste | **nginx läuft bereits** (Zweck noch unklar, Frage B8) |
| Sicherheit | SELinux *enforcing*, firewalld aktiv |
| Nicht installiert | podman, libvirt, cockpit-machines, lsusb |
| Router | vermutlich FritzBox, Server mit fester Adresse |
| Drucker | Citizen CL-S521 wird **direkt per USB** angeschlossen (noch nicht angeschlossen) |
| Von außen | nicht erreichbar, bei Bedarf später per VPN am Router |

**Cockpit** (Port 9090) ist eine Verwaltungsoberfläche im Browser. Damit gibt es doch
eine Oberfläche für den Server, und mit `cockpit-machines` lassen sich dort VMs
anlegen und ansehen.

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

**Netzwerk der VM:** Damit die VM eine eigene Adresse im Netz hat **und** FreeIPA
erreicht (Anmeldung, DNS), braucht der Server eine **Netzwerkbrücke**. Das ändert
die Netzwerkeinstellung des Domain Controllers. Geht dabei etwas schief, ist der
Server nicht mehr per SSH erreichbar. Deshalb nur, wenn jemand vor Ort an den Server
kann (Bildschirm und Tastatur anstecken).

## Zugang für Claude (Stand 12.10.2026)

- Claude arbeitet per SSH von diesem PC aus: Alias `ipa` in `~/.ssh/config`. Der
  Schlüssel liegt im **Windows-SSH-Agent**, deshalb das Windows-`ssh.exe`
  (`/c/Windows/System32/OpenSSH/ssh.exe`), nicht das von Git Bash.
- **Jeder SSH-Befehl muss vom Nutzer bestätigt werden** (`ask`-Regeln in
  `.claude/settings.json`).
- Skripte laufen per `ssh ipa 'sh -s' < skript`, auf dem Server bleibt nichts liegen.
- `sudo` verlangt ein Passwort, das Claude nicht bekommt. Für Schritte mit root
  siehe Frage B2.1.

## DNS

- FreeIPA betreibt das DNS für das interne Netz. Eintrag für tosto, sobald die VM
  ihre IP-Adresse hat:
  `ipa dnsrecord-add <zone> tosto --a-rec <IP-der-VM>` (Zone je nachdem, ob
  `internal.stern-kaffee.de` als eigene Zone in FreeIPA angelegt wird).
- Tablets und Handys fragen meist den **Router** (FritzBox). Eine FritzBox kann
  Anfragen nicht pro Domain an FreeIPA weiterleiten. Möglichkeiten (Frage C2):
  - **Eintrag im öffentlichen DNS** von `stern-kaffee.de`: `tosto.internal` zeigt
    auf die interne Adresse der VM. Funktioniert auf jedem Gerät ohne Umstellung.
    Die FritzBox braucht dafür eine Ausnahme beim DNS-Rebind-Schutz. Nachteil: Die
    interne Adresse ist öffentlich lesbar (verrät wenig).
  - Die FritzBox verteilt **FreeIPA als DNS-Server** an alle Geräte. Dann hängt das
    Internet aller Geräte am Server: Ist er aus, geht nichts mehr.
- **Nicht** `.local` verwenden (mDNS-Konflikte).

## HTTPS

- Bevorzugt: **Let's Encrypt mit DNS-Challenge.** Funktioniert, ohne dass tosto aus
  dem Internet erreichbar ist, braucht aber eine DNS-API beim Anbieter von
  `stern-kaffee.de` (Frage C1). Caddy erneuert dann automatisch.
- Sonst: Zertifikat von der **FreeIPA-Zertifizierungsstelle**. Dann muss deren
  Stammzertifikat auf jedem Tablet und Handy einmal installiert werden.

## Noch zu tun (gemeinsam, Schritt für Schritt)

- [x] Server-Fakten sammeln: `scripts/server-fakten.sh` → `lokal/server-fakten.txt` (12.10.2026)
- [ ] VM anlegen (nach Antwort auf B1), Drucker per USB durchreichen
- [ ] DNS-Eintrag in FreeIPA, Weiterleitung im Router einrichten
- [ ] HTTPS-Zertifikat einrichten
- [ ] Sicherung des Datenordners einrichten

## Plesk-Webspace (nicht mehr geplant)

Bis 12.10.2026 war ein Plesk-Webspace mit PHP 8.1 vorgesehen (SSH-Abfrage vom
07.10.2026: Ubuntu 22.04, PHP 8.1 mit `sodium`/`openssl`, Composer, kein
Node.js/Python nutzbar). Er bleibt eine Möglichkeit, falls die Apps später in die
öffentliche Website des Chefs sollen.
