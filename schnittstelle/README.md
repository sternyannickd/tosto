# Schnittstelle zwischen den Projekten

tosto, labels und roast-archive werden jeweils in ihrem eigenen Ordner
entwickelt. Sie sprechen über **Schnittstellen-Dateien** miteinander. Alle anderen
Dateien eines fremden Projekts werden nur gelesen.

```
tosto         ──schreibt──►  ../labels/TOSTO.md              ──liest──  labels
tosto         ──schreibt──►  ../roast-archive/TOSTO.md       ──liest──  roast-archive
labels        ──schreibt──►  tosto/schnittstelle/labels.md          ──liest──  tosto
roast-archive ──schreibt──►  tosto/schnittstelle/roast-archive.md   ──liest──  tosto
```

## Regeln

1. **Jede Datei hat genau einen Schreiber**, nämlich das Projekt, von dem die
   Nachricht kommt. Der Empfänger liest nur.
2. **Sonst nichts im fremden Projekt ändern.** Ein Hook
   (`.claude/hooks/schnittstelle.py`) sperrt jeden anderen Schreibzugriff, die
   erlaubten Dateien stehen in `.claude/schnittstelle.json`.
3. **Der Empfänger committet.** Wer in ein fremdes Projekt schreibt, committet dort
   nicht. Eine geänderte Schnittstellen-Datei in `git status` heißt also: Es gibt
   Neues. Der Empfänger liest es, setzt es um oder antwortet und committet die
   Datei mit.
4. **Antworten gehen in die eigene Ausgangsdatei**, nicht in die Datei des anderen:
   „zu T3: erledigt in Version 0.3“.
5. Neue App = neue Zeile in `.claude/schnittstelle.json`, eine `TOSTO.md` im
   App-Repo und eine `schnittstelle/<app>.md` hier.

## Aufbau einer Schnittstellen-Datei

```markdown
# <Absender> → <Empfänger>

## Gilt dauerhaft
Was der Empfänger immer beachten muss (Verweise, Festlegungen).

## Nachrichten
| Nr | Datum | Thema | Inhalt | Status |
```

- **Nummern:** tosto schreibt `T1, T2, …`, labels `L1, …`, roast-archive `R1, …`.
- **Status:** `offen` (der Empfänger soll etwas tun), `info` (nur zur Kenntnis),
  `erledigt` (der Absender hat die Antwort gesehen). Erledigte Zeilen dürfen nach
  einiger Zeit gelöscht werden, Git hat die Geschichte.

## Einrichten im App-Projekt (einmalig, dort zu tun)

1. Den Abschnitt aus `TOSTO.md` → „Einrichten“ in die eigene `CLAUDE.md` übernehmen.
2. `.claude/hooks/schnittstelle.py` von hier unverändert kopieren.
3. `.claude/schnittstelle.json` anlegen:
   `{"fremde_projekte": {"../tosto": ["schnittstelle/<app>.md"]}}`
4. In `.claude/settings.json` den Ordner `../tosto` freigeben und den Hook
   eintragen (Vorlage: `.claude/settings.json` hier).
