# Fragenkatalog 2 – Nachfragen zu Katalog 1

**Stand 12.10.2026.** Entstanden aus den Antworten in `01-portal.md`. Wie gehabt:
Empfehlung, Antwortzeile, ⚠️ blockiert. Bitte direkt hier in der Datei antworten,
**nicht über ChatGPT umformatieren lassen** (die Formatierung ging dabei kaputt).

---

**N1. ⚠️ Podman ohne VM: Wie bekommt tosto den Port 443?**
FreeIPA belegt mit seinem Webserver die Ports 80 und 443 auf der Adresse des
Servers. tosto kann sie dort nicht auch benutzen.
- (a) **Eigene Adresse für den tosto-Container** (Podman „macvlan“). Der Container
  bekommt eine eigene Adresse im Netz der Rösterei, z. B. `…178.210`. An FreeIPA und
  an der Netzwerkeinstellung des Servers ändert sich **nichts**. Adresse ohne
  Portnummer: `https://tosto.internal.stern-kaffee.de`. Nachteil: Der Server selbst
  kann den Container über diese Adresse nicht erreichen (für uns egal), und die
  Container laufen unter root-Verwaltung (abgesichert durch SELinux und einen
  Benutzer ohne Rechte im Container).
- (b) **Anderer Port**, z. B. `https://tosto.internal.stern-kaffee.de:8445`. Am
  einfachsten, nichts wird umgebaut (so macht es auch dein anderes Projekt mit 8444).
  Nachteil: Die Portnummer gehört zur Adresse. Als Lesezeichen oder Startbildschirm-
  Symbol auf Tablets fällt das kaum auf.
- (c) FreeIPAs Webserver leitet tosto weiter. Ändert die Konfiguration des Domain
  Controllers, nicht empfohlen.

Empfehlung: **(a)**, saubere Adresse ohne Eingriff in FreeIPA. Wenn es schnell gehen
soll: (b), später auf (a) umstellbar.
→ Antwort:

**N2. ⚠️ Nur bei N1 (a): Welche Adresse ist im Netz frei?**
Die Adresse muss **außerhalb des Bereichs liegen, den die FritzBox automatisch
vergibt** (FritzBox → Heimnetz → Netzwerk → Netzwerkeinstellungen → IPv4-Einstellungen,
dort steht z. B. „DHCP von .20 bis .200“). Bitte den Bereich nennen. Ich schlage dann
eine Adresse vor und prüfe, dass sie unbenutzt ist.
→ Antwort:

**N3. HTTPS-Zertifikat bei STRATO: was das bedeutet**
Ein Zertifikat, dem alle Geräte ohne Warnung vertrauen, kommt von Let's Encrypt.
Let's Encrypt prüft dafür alle 60–90 Tage einen Eintrag im DNS der Domain. Damit das
automatisch geht, braucht der Server eine Schnittstelle (API) zum DNS-Anbieter.
**STRATO bietet nach meinem Kenntnisstand keine solche API an.** Möglichkeiten:
- (a) **Prüf-Eintrag umleiten:** Bei STRATO einmalig einen CNAME-Eintrag
  `_acme-challenge.tosto.internal` anlegen, der auf einen kostenlosen DNS-Dienst
  mit API zeigt (z. B. deSEC.io, Berlin). Danach erneuert der Server das Zertifikat
  automatisch. Muss geprüft werden, ob STRATO diesen Eintrag (mit Unterstrich)
  zulässt.
- (b) **Zertifikat von der FreeIPA-Zertifizierungsstelle.** Kein Internet nötig,
  aber auf jedem Gerät (ca. 10 Personen, PCs, Tablets, Handys) muss einmal das
  Stammzertifikat installiert werden. Neue Geräte jedes Mal wieder.
- (c) Let's Encrypt **von Hand** alle 60–90 Tage verlängern. Nicht empfohlen, wird
  vergessen.

Empfehlung: **(a)**, wenn STRATO den Eintrag zulässt, sonst (b). Ich zeige dir in
der Einrichtungssitzung, wo du bei STRATO nachschaust.
→ Antwort:

**N4. Zweite Etiketten-App (Verpackungsetiketten): eigenes Projekt oder in labels?**
Die großen Verpackungsetiketten brauchen dieselben Produkte, GTINs und MHD-Regeln und
denselben ZPL-Weg wie labels. Nur Layout, Drucker und Inhalt unterscheiden sich.
Empfehlung: **In labels als zweite Etikettenart**, nicht als eigenes Projekt. Sonst
gibt es zwei Produktlisten, die auseinanderlaufen. In tosto darf das trotzdem als
eigene Kachel erscheinen.
→ Antwort:

**N5. Wie kommt ein Druckauftrag an den Drucker am Client-PC?**
Ein Browser kann nicht selbst an einen USB-Drucker schicken. Auf dem Client-PC muss
deshalb ein kleines Programm laufen (labels kann das heute schon). Zwei Wege:
- (a) **Der Client-PC holt seine Aufträge beim Server ab** (der ursprünglich
  geplante Druckagent): Drucken geht dann von **jedem** Gerät aus, Druckerstatus und
  Protokoll stehen zentral in tosto, die 30-Minuten-Regel greift.
- (b) Der Browser schickt direkt an das Programm auf demselben PC: Drucken geht dann
  **nur an diesem einen PC**.

Empfehlung: **(a)**. Details entscheidet labels, das hier ist nur die Richtung.
→ Antwort:
