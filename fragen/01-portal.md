# Fragenkatalog 1 – Portal „tosto“ und Milestone 1

Ziel: alles klären, was wir brauchen, um den Plan festzulegen und danach das Portal
mit Etikettendruck und Cupping zu bauen.

Jede Frage hat eine **Empfehlung**. Wo du zustimmst, reicht ein „ok“ in der
Antwortzeile. Fragen mit ⚠️ blockieren den Bau – die zuerst klären.

---

## A. Grundsätzliches

**A1. ⚠️ Unter welcher Adresse soll tosto laufen?**
Der Webspace heißt laut SSH-Ausgabe nach dem Plesk-Server. Soll das Portal dort als
Subdomain laufen (z. B. `tosto.<webspace>`) oder unter einer Domain der Rösterei
(z. B. `tosto.stern-kaffee.de`, per DNS auf den Webspace)?
Empfehlung: **Subdomain einer Domain der Rösterei**, damit die Adresse für die
Mitarbeitenden vertrauenswürdig aussieht. Technisch ist beides gleich.
→ Antwort:

**A2. Wer benutzt tosto, und mit welchen Geräten?**
Ungefähre Zahl der Personen, und ob vor allem Tablets in der Rösterei, eigene
Handys, der PC im Büro …
Empfehlung: Oberfläche zuerst für **Tablet und Handy** bauen, am PC funktioniert es
dann auch.
→ Antwort:

**A3. Gibt es gemeinsam genutzte Geräte (z. B. ein Tablet am Cuppingtisch, den
Rechner am Drucker), an denen mehrere Leute nacheinander arbeiten?**
Das entscheidet, wie lange eine Anmeldung gilt und ob es Geräte-Konten braucht.
Empfehlung: **Jede Person hat ein eigenes Konto.** An gemeinsamen Geräten ist die
Sitzung kurz (siehe D4). Beim Cupping wählt man wie heute in der App, *wer* cuppt,
das ist unabhängig davon, *wer angemeldet* ist.
→ Antwort:

**A4. Ist das GitHub-Repo privat?**
Empfehlung: **Privat.** Die Doku enthält Betriebsinterna (Server, Abläufe, EANs).
Geheimnisse kommen so oder so nicht ins Git.
→ Antwort:

**A5. Was bedeutet „tosto“, und soll es ein Logo / einen Schriftzug geben?**
Empfehlung: Fürs Erste nur der Schriftzug „tosto“ in der Hausschrift, Logo später.
→ Antwort:

## B. Mehrere Apps – der Aufbau

**B1. Ist der Aufbau „jede App = Web Component + PHP-API + Manifest“ ok?**
Siehe [`KONVENTIONEN.md`](../KONVENTIONEN.md). Die Etiketten-App erfüllt den
Oberflächenteil schon. Die Cupping-App ist eine eigenständige Single-Page-App mit
globalen Stilen und festen Pfaden und muss umgebaut werden (siehe G4).
Empfehlung: **Ja.** Das ist die Grundlage dafür, dass die Apps später auch in die
Website des Chefs passen.
→ Antwort:

**B2. ⚠️ Wo liegt der PHP-Code einer App?**
- (a) **Im Portal-Repo** unter `apps/<id>/`. Einfach, alles an einer Stelle, ein
  Bereitstellungsweg. Nachteil: Oberfläche (App-Repo) und API (Portal-Repo) liegen
  getrennt.
- (b) **Im App-Repo** (z. B. `labels/portal-php/`), das Portal holt ihn bei der
  Bereitstellung. Jede App ist komplett in einem Repo, auch für eine spätere
  WordPress-Einbindung. Nachteil: Bereitstellung wird aufwendiger.

Empfehlung: **(a) für Milestone 1**, so wie im Auftrag vorgesehen. Der App-Code
hängt aber nur an zwei kleinen Schnittstellen des Portals (Anmeldung, Ablage) und
lässt sich später ohne Umbau herauslösen.
→ Antwort:

**B3. Wie kommen die Oberflächendateien der Apps (JS/CSS) aufs Portal?**
- (a) Bereitstellungs-Skript holt pro App einen **festgelegten Stand** (Git-Tag)
  aus dem App-Repo.
- (b) Git-Submodule im Portal-Repo.
- (c) Von Hand kopieren.

Empfehlung: **(a).** Im Manifest steht, welcher Stand verwendet wird. So ändert ein
Commit im App-Repo nie unbemerkt die Website, und ein Update ist eine Zeile.
→ Antwort:

**B4. Sollen alle Angemeldeten alle Apps sehen, oder gibt es Rechte pro App?**
Empfehlung: **Rechte pro App**, ganz einfach: jedes Konto hat eine Liste von Apps,
dazu die Rolle *Admin* (Konten verwalten, Drucker-Token, Einstellungen). Keine
feineren Rollen, bis jemand sie braucht.
→ Antwort:

**B5. Gibt es innerhalb einer App unterschiedliche Rechte?**
Beispiele: Produkte und Haltbarkeiten nur durch bestimmte Personen ändern; Cupper-
und Sortenlisten nur durch Admins pflegen.
Empfehlung: **Nur zwei Stufen pro App:** *benutzen* und *verwalten*.
→ Antwort:

**B6. Statussymbol auf der Kachel: für alle Apps nach demselben Muster?**
Jede App liefert `GET status` → grün/rot mit kurzer Meldung; das Portal fragt beim
Öffnen der Übersicht und dann alle ~15 s.
Empfehlung: **Ja.** Apps ohne sinnvollen Status lassen ihn im Manifest weg.
→ Antwort:

**B7. Welche weiteren Apps sind schon absehbar?**
Nur Stichworte, damit die Konventionen nichts Wichtiges übersehen (z. B. Geräte,
Dateien hochladen, Fotos, Druck, Anbindung an Warenwirtschaft/Shop).
→ Antwort:

**B8. Sollen die Apps auch ohne Portal weiter lokal laufen?**
Die Etiketten-App läuft heute komplett am Drucker. Die Cupping-App lokal mit `--lan`.
Empfehlung: **Etiketten: ja als Notbetrieb** (siehe F6). **Cupping: nein**, nach dem
Umzug ist das Portal der einzige Ort für Cuppings, sonst entstehen zwei
Datenbestände.
→ Antwort:

## C. Hosting und Bereitstellung

**C1. ⚠️ Darf ich in Plesk eine Subdomain anlegen bzw. legst du sie an, und darf
das Webverzeichnis auf einen Unterordner (`tosto/public`) zeigen?**
Empfehlung: Subdomain mit Webverzeichnis `tosto/public`, alles andere (Code-Rest,
Daten) liegt daneben und ist nicht öffentlich. Siehe [`docs/HOSTING.md`](../docs/HOSTING.md).
→ Antwort:

**C2. Welche PHP-Versionen bietet Plesk für die Subdomain an?**
Auf der Kommandozeile läuft PHP 8.1. Das bekommt vom PHP-Projekt keine
Sicherheitsupdates mehr (Ubuntu pflegt es noch).
Empfehlung: In Plesk **8.3 oder 8.4** wählen, falls vorhanden. Der Code läuft ab 8.1.
→ Antwort:

**C3. Datenordner: ist `/var/www/vhosts/<webspace>/tosto-daten/` ok?**
Empfehlung: **Ja**, neben dem Code, außerhalb jedes Webverzeichnisses.
→ Antwort:

**C4. ⚠️ Wie soll bereitgestellt werden?**
- (a) **Plesk-Git:** Plesk zieht bei jedem Push nach `main` den Stand von GitHub
  ins Webverzeichnis. Bequem, aber: kein sauberes Zurückrollen, Composer und das
  Holen der App-Dateien müssen als „Bereitstellungsaktion“ laufen, eine halb
  aktualisierte Seite ist möglich.
- (b) **Skript per SSH** (`scripts/bereitstellen.sh`): holt einen Stand in einen neuen
  Release-Ordner, installiert, holt die App-Dateien, prüft, und schaltet erst dann
  per Symlink um. Zurückrollen = Symlink zurück.

Empfehlung: **(b)**, robuster. Du startest es bewusst mit einem Befehl. Voraussetzung:
Plesk akzeptiert einen Symlink als Webverzeichnis (prüfe ich vorher).
→ Antwort:

**C5. Darf der Server per Deploy-Key lesend auf die GitHub-Repos (tosto, labels,
roast-archive) zugreifen?**
Empfehlung: **Ja, je Repo ein eigener Lese-Key**, nur Leserechte.
→ Antwort:

**C6. Backup: Ist ein Plesk-Backup eingerichtet? Darf ich einen Cronjob anlegen?**
Empfehlung: **Beides.** Täglich per Cron eine Kopie des Datenordners als
`backup/JJJJ-MM-TT.tar.gz` (30 Tage aufheben), zusätzlich Plesk-Backup. Wenn möglich
eine Kopie außer Haus (z. B. Nextcloud).
→ Antwort:

**C7. Kann der Server E-Mails verschicken, und soll er das?**
Wofür: Warnung bei vielen Fehlversuchen, Drucker lange offline, Backup fehlgeschlagen.
Empfehlung: **Kein „Passwort vergessen“ per Mail** (ein Admin setzt zurück).
Warn-Mails an einen Admin: ja, falls Mailversand geht.
→ Antwort:

**C8. Brauchen wir eine Test-Subdomain (z. B. `tosto-test.…`) mit eigenem
Datenordner?**
Empfehlung: **Ja.** Erst dort bereitstellen, dann auf die echte Seite.
→ Antwort:

**C9. Ist auf deinem Windows-Rechner PHP installiert (für lokales Entwickeln und
Tests)?**
Empfehlung: PHP 8.3 lokal installieren (z. B. per `winget install PHP.PHP.8.3`),
dann läuft die Seite mit `php -S localhost:8080 -t public` und die Tests laufen ohne
Server.
→ Antwort:

## D. Anmeldung und Sicherheit

**D1. Wer ist Admin?**
Empfehlung: Du, und höchstens eine zweite Person als Vertretung.
→ Antwort:

**D2. Konten anlegen: Admin-Oberfläche, Kommandozeile oder beides?**
Empfehlung: **Zuerst Kommandozeile** (`php scripts/konto.php anlegen …` per SSH),
die Admin-Oberfläche danach. Der erste Admin entsteht immer per Kommandozeile.
→ Antwort:

**D3. 2FA: optional für alle, Pflicht für Admins?**
Empfehlung: **Pflicht für Admins**, für alle anderen optional (Admin kann sie für
alle einschalten). 10 Wiederherstellungscodes zum Ausdrucken.
→ Antwort:

**D4. Wie lange gilt eine Anmeldung?**
Empfehlung: Abmeldung nach **60 min ohne Aktivität**, spätestens nach **12 h**.
Optional „auf diesem Gerät angemeldet bleiben“ für persönliche Geräte (30 Tage)?
→ Antwort:

**D5. Sperre nach Fehlversuchen: 5 Fehlversuche → 15 min gesperrt (pro Konto und
pro IP), dazu Bremsen ab dem 3. Versuch?**
Empfehlung: **Ja.** Admin kann eine Sperre sofort aufheben.
→ Antwort:

**D6. Passwortregeln?**
Empfehlung: **Mindestens 12 Zeichen**, keine Pflicht zu Sonderzeichen, Abgleich
gegen eine Liste häufiger Passwörter. Admin vergibt ein Startpasswort, das beim
ersten Login geändert werden muss.
→ Antwort:

**D7. Zugriff zusätzlich auf bestimmte Netze beschränken (z. B. nur aus der
Rösterei)?**
Empfehlung: **Nein**, sonst geht es mobil nicht. Ausnahme: Die Admin-Bereiche
könnte man so beschränken, wenn die Rösterei eine feste IP hat.
→ Antwort:

**D8. Wie lange sollen Login-Protokoll und Druckprotokoll aufgehoben werden?**
(Datenschutz: Login-Protokolle sind personenbezogen.)
Empfehlung: **Login-Protokoll 90 Tage.** Druckprotokoll **unbegrenzt** (es ist ein
Betriebsnachweis, Rückverfolgbarkeit von Chargen/MHD).
→ Antwort:

## E. Design

**E1. ⚠️ Woher kommt das Design?**
Gibt es eine Website / ein Corporate Design der Rösterei, an dem wir uns
orientieren (Farben, Schriften, Logo)? Bitte Link oder Dateien.
Empfehlung: Farben und Schrift von der Rösterei-Website übernehmen, sonst ein
schlichtes, ruhiges Design mit einer Akzentfarbe.
→ Antwort:

**E2. Schriften selbst ausliefern statt von Google Fonts laden?**
Empfehlung: **Ja**, wegen Datenschutz und weil die Content-Security-Policy dann
streng bleiben kann.
→ Antwort:

**E3. Dunkles Design (Dark Mode)?**
Empfehlung: **Automatisch nach Geräteeinstellung**, die Cupping-App kann das schon.
→ Antwort:

**E4. Wie soll die Übersicht aussehen?**
Empfehlung: Kopfzeile mit „tosto“, Name und Abmelden; darunter Kacheln (Symbol,
Name, eine Zeile Beschreibung, Statuspunkt). Eine geöffnete App läuft in derselben
Seite unter einer Kopfzeile mit „← Übersicht“.
→ Antwort:

## F. App 1: Etikettendruck

**F1. Abfrageintervall des Druckagenten: alle 3 s, „erreichbar“ wenn letztes
Lebenszeichen < 30 s?**
Empfehlung: **Ja.** Das sind ca. 29.000 kleine Anfragen pro Tag, für PHP kein
Problem.
→ Antwort:

**F2. ⚠️ Was passiert mit Aufträgen, die lange warten?**
Beispiel: Abends geht der Druckrechner aus, jemand druckt trotzdem 50 Etiketten. Am
nächsten Morgen würden sie plötzlich herauskommen, mit dem MHD von gestern.
Empfehlung: Aufträge **verfallen nach 30 Minuten** (Status „verfallen“) und müssen
neu ausgelöst werden. Ist der Agent offline, warnt die Oberfläche **vor** dem
Absenden.
→ Antwort:

**F3. Darf man wartende Aufträge abbrechen?**
Empfehlung: **Ja**, solange sie „wartet“ sind. Danach nicht mehr.
→ Antwort:

**F4. ⚠️ Vorschau:** Heute zeigt die App ein Bild vom echten ZPL (über labelary.com).
Im neuen Aufbau erzeugt nur noch der Agent ZPL, der Server nicht.
- (a) Vorschau als **schematisches Bild im Browser** (Titel, Strichcode, MHD),
  nicht pixelgenau.
- (b) ZPL-Erzeugung **zusätzlich in PHP** nachbauen. Doppelter Code, der
  auseinanderlaufen kann.
- (c) Agent liefert die Vorschau (nur wenn er online ist).
- (d) Keine Vorschau im Portal.

Empfehlung: **(a)**. Für die genaue Vorschau gibt es den Testdruck.
→ Antwort:

**F5. Wo werden Produkte gepflegt?**
Empfehlung: **Im Portal** (Liste mit Bearbeiten, nur mit Recht *verwalten*),
gespeichert als JSON. Die bestehende `produkte.csv` wird einmalig übernommen. Der
Agent braucht die Liste nicht, er bekommt alles im Auftrag.
→ Antwort:

**F6. Notbetrieb ohne Internet: Soll die lokale Oberfläche am Druckrechner weiter
funktionieren?**
Empfehlung: **Ja**, wie heute auf `localhost:8077`, mit lokaler Produktliste
(vom Agenten aus dem Portal zwischengespeichert). Ausdrucke im Notbetrieb meldet der
Agent später ans Protokoll.
→ Antwort:

**F7. Testdruck und Druckerprüfung aus dem Portal auslösen?**
Empfehlung: **Ja**, als eigener Auftragstyp „Testetikett“.
→ Antwort:

**F8. Mehr als ein Drucker in absehbarer Zeit?**
Empfehlung: Heute einer, aber jeder Auftrag trägt schon eine Drucker-ID und jeder
Agent hat ein eigenes Token. Dann kostet ein zweiter Drucker keinen Umbau.
→ Antwort:

**F9. Darf der Druckrechner ausgehend per HTTPS ins Internet (Firewall,
Proxy)?**
→ Antwort:

## G. App 2: Cupping (roast-archive)

**G1. ⚠️ Was genau kommt ins Portal?**
Die Web-App hat vier Bereiche: Cuppings, Röstungen, Auswertung, Cupper & Sorten.
Die Kommandozeile (`inspect`, `compare`, `archive`, …) läuft lokal an Artisan.
Empfehlung: **Alle vier Bereiche der Web-App** kommen ins Portal. Die
Kommandozeile bleibt lokal.
→ Antwort:

**G2. ⚠️ Wie kommen die Röstungen (Artisan `.alog`) ins Portal?**
Heute liest die App die `.alog`-Dateien direkt aus dem Nextcloud-Ordner. Auf dem
Server gibt es den Ordner nicht. Das `.alog`-Format ist ein Python-Ausdruck, den
PHP erst lesen lernen müsste.
- (a) **`roast-archive` lädt hoch:** nach dem Archivieren schickt `roast-archive`
  die bereits ausgelesenen Kerndaten (Metadaten, Kennzahlen) als JSON per
  Geräte-Token ans Portal. PHP muss kein `.alog` verstehen.
- (b) `.alog`-Datei im Portal **hochladen**, PHP liest sie.
- (c) Röstungen nur noch **von Hand** im Portal anlegen.

Empfehlung: **(a)**, ein kleiner Befehl `roast-archive sync` (automatisch nach
`archive`). Bis der fertig ist, geht (c).
→ Antwort:

**G3. Nach dem Umzug: Ist das Portal der einzige Ort für Cupping-Daten?**
Empfehlung: **Ja.** Die vorhandenen Dateien (`roast-registry.json`,
`cupping-sessions/*.json`) werden einmalig übernommen, unverändert im Format 4. Die
lokale App wird danach nicht mehr zum Speichern benutzt. Ein Export aus dem Portal
(JSON + CSV) bleibt jederzeit möglich, auch zurück ins lokale Format.
→ Antwort:

**G4. Umbau zum Web Component `<cupping-app>`: einverstanden, dass die Bereiche
innerhalb der App über den Hash (`#/cuppings`) navigieren?**
Im Portal stört das nicht. In einer fremden Website (WordPress) könnte der Hash
kollidieren; dann schaltet ein Attribut auf internen Zustand um.
Empfehlung: **Ja.**
→ Antwort:

**G5. Teilen per Adresse/QR-Code:** Heute zeigt „Teilen“ die LAN-Adresse. Im
Portal zeigt es die Portal-Adresse des Cuppings; wer sie öffnet, muss angemeldet
sein und das Recht für Cupping haben. Ok?
Empfehlung: **Ja.**
→ Antwort:

**G6. Sollen Cupper (die Personen in der Cupping-Liste) mit Portal-Konten
verknüpft werden?**
Vorteil: Nach dem Login ist man automatisch „man selbst“. Nachteil: Gäste ohne
Konto (z. B. Besuch beim Cupping) brauchen weiter freie Einträge.
Empfehlung: **Optional verknüpfen**: Ein Cupper kann zu einem Konto gehören, muss
aber nicht.
→ Antwort:

**G7. Das Archiv der alten Cuppings (bis 14.09.2026) mit übernehmen?**
Empfehlung: **Ja, unverändert als Datei** im Datenordner, nicht in der Oberfläche
angezeigt (so wie heute).
→ Antwort:

**G8. Flavour Wheels und SCA-Formulare im Internet (auch hinter Login): Ist die
Lizenzfrage aus `RESEARCH.md` Punkt 12 für eine interne Website geklärt?**
→ Antwort:

**G9. Name der Kachel: „Cupping“, „Röstarchiv“ oder etwas anderes?**
→ Antwort:

## H. Vorgehen

**H1. Reihenfolge:**
1. Portal-Grundgerüst: Anmeldung, 2FA, Konten per Kommandozeile, Übersicht, Design,
   Ablage, Bereitstellung auf Test-Subdomain.
2. Etikettendruck: API, Warteschlange, Statusanzeige; parallel Druckagent im
   labels-Repo.
3. Cupping: PHP-API, Datenübernahme, Web Component.
4. Admin-Oberfläche, Backup, Warn-Mails.

Empfehlung: **So.** Etiketten zuerst, weil sie kleiner ist und den Druckagenten als
Muster für Geräte-Anbindungen liefert.
→ Antwort:

**H2. Sprache im Code: deutsche Bezeichner (wie im Etiketten-Projekt) oder
englische (wie in roast-archive)?**
Empfehlung: **Deutsch** für Portal-Code und Doku, wie im Etiketten-Projekt. Beim
Übertragen der Cupping-Logik bleiben die Feldnamen des JSON-Formats natürlich
englisch.
→ Antwort:

**H3. Tests: PHPUnit (über Composer, nur zum Entwickeln) oder kleine eigene
Testskripte ohne Abhängigkeit?**
Empfehlung: **PHPUnit**, nur als Entwicklungsabhängigkeit, auf dem Server nicht
installiert.
→ Antwort:
