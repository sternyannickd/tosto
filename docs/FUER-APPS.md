# Notizen für die App-Projekte

tosto ändert die App-Repos nicht. Was dort zu tun ist, wird hier gesammelt und im
jeweiligen Projekt umgesetzt.

## labels (Etikettendruck)

| Stand | Thema | Notiz |
|-------|-------|-------|
| 08.10.2026 | Vorschau | In der Web-App soll es eine Vorschau geben. Idee: Der Server erzeugt ZPL nur für die Vorschau (z. B. über labelary.com), gedruckt wird das ZPL, das der Agent selbst erzeugt. Zu klären: ZPL-Erzeugung in PHP nachbauen oder anders lösen, und wie beide gleich bleiben. |
| 08.10.2026 | Verfall | Aufträge verfallen nach 30 Minuten. Der Agent darf einen verfallenen Auftrag nie drucken. |
| 07.10.2026 | Druckagent | Fragt per HTTPS ab, Geräte-Token, strukturierte Aufträge, kein ZPL vom Server. Siehe `initial_prompt.md`. |

## roast-archive (Cupping)

| Stand | Thema | Notiz |
|-------|-------|-------|
| 08.10.2026 | Röstungen | Wie `.alog`-Daten ins Portal kommen (Frage G2), ist offen. |
| 07.10.2026 | Web Component | Umbau zu `<cupping-app>` nach `KONVENTIONEN.md`. |
