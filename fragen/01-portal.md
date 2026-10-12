# Fragenkatalog 1 – tosto auf dem Firmenserver

**Stand 12.10.2026.** Ersetzt die Fassung vom 07.10. (Plesk/PHP). Grundlage: Hosting
auf dem Firmenserver ist entschieden.

Jede Frage hat eine **Empfehlung**. Wo du zustimmst, reicht ein „ok“ in der
Antwortzeile. Fragen mit ⚠️ blockieren den Bau, die zuerst klären. Fragen mit ✅
sind schon beantwortet und stehen nur zur Übersicht da.

---

## A. Grundsätzliches

**A1. ✅ Wo wird gehostet?**
→ Antwort: Firmenserver (Minisforum, AlmaLinux, FreeIPA). Drucker per USB am Server.

**A2. ⚠️ Adresse: Du hast `tosto.interal.stern-kaffee.de` geschrieben. Gemeint ist
vermutlich `tosto.internal.stern-kaffee.de`?**
Empfehlung: **`tosto.internal.stern-kaffee.de`**. Diesen Namen kennt nur das DNS in
der Rösterei, im Internet zeigt er nirgendwohin.
→ Antwort:

**A3. ✅ Was bedeutet „tosto“?**
→ Antwort: TOSTO = Tools Of Specialty Tasting & rOasting

**A4. Wer benutzt tosto, und mit welchen Geräten?**
Ungefähre Zahl der Personen, und ob vor allem Tablets, eigene Handys im WLAN,
Mint-PCs …
Empfehlung: Oberfläche zuerst für **Tablet und Handy** bauen, am PC geht es dann auch.
→ Antwort:

**A5. Gibt es Geräte, an denen mehrere Leute nacheinander arbeiten?**
Beispiel: Ein Tablet liegt am Cuppingtisch. Wenn Anna sich morgens anmeldet und
angemeldet bleibt, druckt oder bewertet Ben später unter Annas Namen. Je nach
Antwort meldet tosto auf solchen Geräten schneller ab, oder es gibt ein Konto
„Tablet Cuppingtisch“.
Empfehlung: **Persönliche Konten**, und auf gemeinsamen Geräten Abmeldung nach
kurzer Pause (siehe D4).
→ Antwort:

**A6. Muss jemand von außerhalb der Rösterei zugreifen (von zu Hause, unterwegs)?**
Empfehlung: **Vorerst nein.** Falls doch, später ein VPN am Router (z. B.
WireGuard), tosto bleibt trotzdem nur intern erreichbar.
→ Antwort:

**A7. Sind die GitHub-Repos privat (tosto, labels, roast-archive)?**
Empfehlung: **Ja, alle privat.** Der Server holt den Code später von dort.
→ Antwort:

## B. Server und Betrieb

**B1. ⚠️ Wie werden die Apps auf dem Server vom Domain Controller getrennt?**
Der Server ist euer FreeIPA-Domain-Controller. Wer eine Lücke in einer Web-App
findet, soll trotzdem nicht an FreeIPA herankommen. Außerdem belegt FreeIPA mit
seinem eigenen Webserver bereits die Ports 80 und 443.
- (a) **Eine kleine VM** (AlmaLinux, 2 CPU, 2–4 GB RAM) mit **eigener IP-Adresse**.
  Komplett getrennt, keine Port-Konflikte, eigene Updates und Sicherungen. Den
  Drucker reicht man per USB-Durchleitung in die VM.
- (b) **Podman-Container direkt auf dem Server**, unter einem Benutzer ohne Rechte.
  Etwas weniger Aufwand, aber dieselbe Maschine wie FreeIPA, und für HTTPS braucht
  es eine zweite IP-Adresse oder FreeIPAs Webserver als Vermittler.

Ergebnis der Server-Fakten: Ports 80/443 sind tatsächlich belegt. Für (a) braucht
der Server eine **Netzwerkbrücke**, damit die VM eine eigene Adresse hat und trotzdem
FreeIPA erreicht. Das ist eine Änderung am Netz des Domain Controllers und sollte
passieren, **wenn jemand vor Ort ist**, falls die Verbindung abbricht (B9).
Empfehlung: **(a) VM.** Sicherheit hat Vorrang, und die eigene Adresse löst das
Port-Problem sauber. Die Leistung reicht locker (28 GB RAM, 16 Threads).
→ Antwort:

**B2. ✅ Wer führt die Befehle auf dem Server aus?**
→ Antwort: Claude per SSH von diesem PC aus, jeden Befehl bestätige ich.

**B2.1. ⚠️ Wie bekommt Claude root-Rechte für die Einrichtung?**
`sudo` fragt nach dem Passwort von `serveradmin`, und das bekommt Claude nicht.
- (a) **Befristete Regel:** Du führst einmal in deinem eigenen Terminal einen Befehl
  aus, der `serveradmin` für die Einrichtung `sudo` ohne Passwort erlaubt (Datei
  `/etc/sudoers.d/90-tosto-einrichtung`). Danach wird sie wieder gelöscht. Jeder
  Befehl bleibt bestätigungspflichtig.
- (b) **Du führst jeden root-Befehl selbst aus** und gibst das Passwort ein. Sicherer,
  aber genau das, was du vermeiden willst.

Empfehlung: **(a)**, befristet auf die Einrichtung am Domain Controller (VM, Brücke).
In der VM bekommt Claude später einen eigenen Benutzer, da ist das weniger heikel,
weil die VM vom Domain Controller getrennt ist.
→ Antwort:

**B3. Wie kommt neuer Code auf den Server?**
Empfehlung: Ein Skript `scripts/bereitstellen.sh`. Es meldet sich per SSH als
`tosto` in der VM an, holt dort einen **festen Stand** (Git-Tag) jeder App von
GitHub (je Repo ein Schlüssel nur zum Lesen) und startet die Dienste neu.
Zurückrollen = vorherigen Stand holen.
→ Antwort:

**B4. Läuft der Server rund um die Uhr? Gibt es eine USV (Notstrom)?**
→ Antwort:

**B5. Wie wird der Server heute gesichert, und wohin könnte eine tägliche Kopie der
tosto-Daten gehen (NAS, Nextcloud, externe Platte)?**
Empfehlung: Täglich eine Kopie des Datenordners, 30 Tage aufheben, mindestens eine
Kopie nicht auf dem Server selbst.
→ Antwort:

**B6. Darf der Server ins Internet (Updates, Let's Encrypt, Vorschau über
labelary.com)?**
→ Antwort:

**B7. ✅ Fakten zum Server**
→ Erledigt am 12.10.2026, Zusammenfassung in `docs/HOSTING.md`. Python 3.12 ✔.

**B8. Auf dem Server läuft bereits nginx (und es gibt eine Gruppe `ccc-release`).
Wofür? Gehört das zu deinem anderen Projekt?**
Wozu: Damit tosto nichts in die Quere kommt.
→ Antwort:

**B9. Kommt jemand an den Server heran, falls bei der Einrichtung die
Netzwerkverbindung abbricht (Bildschirm und Tastatur anstecken)?**
→ Antwort:

## C. DNS und HTTPS

**C1. ⚠️ Wo wird die Domain `stern-kaffee.de` verwaltet (Anbieter), und bietet er
eine DNS-API an?**
Wozu: Damit Tablets keine Zertifikatswarnung zeigen, braucht tosto ein echtes
Zertifikat. Let's Encrypt prüft dafür einen Eintrag im öffentlichen DNS der
Domain. tosto muss dafür **nicht** aus dem Internet erreichbar sein.
Empfehlung: Wenn der Anbieter eine API hat: Let's Encrypt, Erneuerung automatisch.
Sonst: Zertifikat von der FreeIPA-Zertifizierungsstelle, das dann auf jedem Gerät
einmal installiert werden muss.
→ Antwort:

**C2. ⚠️ Wie finden Tablets und Handys die Adresse?**
Die Adressen im Netz sehen nach einer **FritzBox** aus. Tablets und Handys fragen
die FritzBox nach Namen, die Mint-PCs vermutlich FreeIPA. Eine FritzBox kann
Anfragen nicht gezielt an FreeIPA weiterreichen.
- (a) **Eintrag im öffentlichen DNS** von `stern-kaffee.de`: `tosto.internal` zeigt
  auf die interne Adresse. Geht auf jedem Gerät sofort, die FritzBox braucht nur
  eine Ausnahme beim „DNS-Rebind-Schutz“. Die interne Adresse ist dann öffentlich
  lesbar, verrät aber wenig.
- (b) Die FritzBox verteilt **FreeIPA als DNS-Server** an alle Geräte. Dann hängt
  das Internet aller Geräte am Server.

Empfehlung: **(a)**, einfach und robust. Bitte bestätigen: Ist es eine FritzBox, und
kommst du an die Verwaltung der Domain (siehe C1)?
→ Antwort:

## D. Anmeldung und Sicherheit

**D1. ⚠️ Mit welchen Konten meldet man sich an?**
- (a) **FreeIPA-Konten**: Alle haben schon eins (vom Mint-PC). Ein Passwort für
  alles. Konten, Sperren und Passwortregeln verwaltest du an einer Stelle. Rechte
  für Apps über FreeIPA-Gruppen (z. B. `tosto-etiketten`). FreeIPA kann auch 2FA.
- (b) **Eigene tosto-Konten**: unabhängig von FreeIPA, aber eine zweite Stelle zum
  Pflegen.

Empfehlung: **(a)**. Wer nur am Tablet arbeitet und noch kein Konto hat, bekommt
ein FreeIPA-Konto (muss sich nie an einem PC anmelden). Bitte prüfen: Haben alle,
die tosto nutzen sollen, ein FreeIPA-Konto?
→ Antwort:

**D2. 2FA (Code aus einer Authenticator-App)?**
Empfehlung: **Pflicht für Admins**, für alle anderen optional. tosto ist nur intern
erreichbar, das senkt das Risiko.
→ Antwort:

**D3. Wer ist Admin?**
Empfehlung: Du, und höchstens eine Person als Vertretung.
→ Antwort:

**D4. Wie lange gilt eine Anmeldung?**
Empfehlung: Abmeldung nach **60 Minuten ohne Aktivität**, spätestens nach **12
Stunden**. Auf gemeinsamen Geräten (A5) kürzer, z. B. 15 Minuten.
→ Antwort:

**D5. Rechte pro App?**
Empfehlung: Je App zwei Stufen, **benutzen** und **verwalten** (z. B. Produkte und
Haltbarkeiten ändern, Cupper-Listen pflegen). Mehr erst, wenn jemand es braucht.
→ Antwort:

**D6. Wie lange werden Login-Protokoll und Druckprotokoll aufgehoben?**
Empfehlung: **Login-Protokoll 90 Tage** (personenbezogen). **Druckprotokoll
unbegrenzt** (Nachweis für Chargen und MHD).
→ Antwort:

## E. Aufbau mit mehreren Apps

**E1. ⚠️ Ist dieser Aufbau ok?**

```
Browser ──HTTPS──► Webserver (Caddy) ──► tosto: Anmeldung, Übersicht, Design
                          │  fragt bei jeder Anfrage: angemeldet? darf er das?
                          ├──► labels        (Python-Dienst, nur lokal erreichbar)
                          └──► roast-archive (Python-Dienst, nur lokal erreichbar)
```

Jede App läuft als eigener Dienst und ist nur über den Webserver erreichbar. Die
Anmeldung prüft tosto **einmal zentral**, die Apps brauchen keine eigene. Eine neue
App = ein neuer Dienst und ein Eintrag, kein Umbau an tosto.
Empfehlung: **Ja.**
→ Antwort:

**E2. Steht das Manifest einer App (Name, Kachel, Symbol, Start, Status) im
App-Repo?**
Empfehlung: **Ja.** tosto braucht dann für eine neue App nur „diese App mit diesem
Stand einbinden“.
→ Antwort:

**E3. Statussymbol auf der Kachel (z. B. „Drucker bereit“) für alle Apps nach
demselben Muster?**
Empfehlung: **Ja.** Jede App kann `GET status` anbieten, grün oder rot mit kurzer
Meldung.
→ Antwort:

**E4. Welche weiteren Apps sind schon absehbar?**
Nur Stichworte, damit die Konventionen nichts übersehen.
→ Antwort:

**E5. Sollen die Apps weiter auch ohne tosto laufen?**
Empfehlung: **Zum Entwickeln ja** (lokal wie heute), **im Betrieb nur über tosto**.
So gibt es keine zweiten Datenbestände.
→ Antwort:

**E6. Sprache im Code: Deutsch (wie labels) oder Englisch (wie roast-archive)?**
Empfehlung: tosto **Deutsch**, jede App bleibt bei ihrer Sprache.
→ Antwort:

## F. Design

**F1. ⚠️ Woher kommt das Design?**
Gibt es eine Website oder ein Corporate Design der Rösterei (Farben, Schriften,
Logo)? Bitte Link oder Dateien.
Empfehlung: Farben und Schrift von der Rösterei-Website übernehmen.
→ Antwort:

**F2. Dunkles Design?**
Empfehlung: **Automatisch nach Geräteeinstellung.**
→ Antwort:

**F3. Übersicht:** Kopfzeile mit „tosto“, Name und Abmelden, darunter Kacheln
(Symbol, Name, eine Zeile Beschreibung, Statuspunkt). Eine geöffnete App läuft
unter einer Kopfzeile mit „← Übersicht“. Ok?
→ Antwort:

## G. Etikettendruck (labels)

**G1. ✅ Alte Druckaufträge**
→ Antwort: Verfallen nach 30 Minuten (gilt, falls es eine Warteschlange gibt).

**G2. ✅ Vorschau**
→ Antwort: Die Web-App bekommt eine Vorschau. Umsetzung entscheidet labels.

**G3. Wo werden Produkte gepflegt?**
Empfehlung: **In der Web-App** (Recht *verwalten*), statt in der CSV-Datei auf dem
Server.
→ Antwort:

**G4. Mehr als ein Drucker absehbar?**
→ Antwort:

## H. Cupping (roast-archive)

**H1. ⚠️ Was kommt in tosto?**
Empfehlung: **Die ganze Web-App** (Cuppings, Röstungen, Auswertung, Cupper &
Sorten). Die Kommandozeile bleibt lokal an Artisan.
→ Antwort:

**H2. Woher kommen die Röstungen? (später entscheiden)**
Nur eine Info vorab: Wo liegt der Archivordner mit den `.alog`-Dateien
(Nextcloud auf welchem Rechner)? Kann der Server ihn erreichen?
→ Antwort:

**H3. Nach dem Umzug ist der Server der einzige Ort für Cupping-Daten?**
Empfehlung: **Ja.** Die vorhandenen Dateien werden einmal übernommen, unverändert.
→ Antwort:

**H4. Cupper mit Konten verbinden?**
In der Cupping-App gibt es eine Liste von Cuppern (Livia, Julius, Maria …), mit tosto
kommen Anmelde-Konten dazu. Verbunden hieße: Maria meldet sich an und ist
automatisch Cupperin „Maria“. Nicht verbunden hieße: Man wählt den Cupper wie heute
von Hand. Das braucht man für Gäste ohne Konto und wenn sich zwei ein Tablet teilen.
Empfehlung: **Verbinden möglich, aber keine Pflicht.**
→ Antwort:

**H5. Name der Kachel: „Cupping“, „Röstarchiv“ oder anders?**
→ Antwort:

## I. Vorgehen

**I1. Reihenfolge:**
1. Server-Fakten (B7), VM anlegen, DNS und HTTPS einrichten.
2. tosto-Grundgerüst: Anmeldung, Übersicht, Design.
3. labels einbinden (kleiner, Drucker am Server).
4. roast-archive einbinden (Web Component, Datenübernahme).
5. Sicherung, Protokolle, Feinschliff.

Empfehlung: **So.**
→ Antwort:
