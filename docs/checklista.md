# Projektkrav-checklista — Personalhanteringssystem

## Arbetsordning (bocka av under projektets gång)

### Fas 1 — Planering och design
- [ ] Kunskapsdomän vald och formulerad
- [ ] Problemformulering skriven
- [ ] Syfte och mål definierade
- [ ] Entiteter identifierade (~5 st)
- [ ] Relationer och kardinalitet dokumenterade
- [ ] ER-diagram skapat i textformat (`docs/er_diagram.md`)
- [ ] ER-diagram skapat i dbdiagram.io och exporterat som PNG
- [ ] ER-diagram exporterat och sparat i `docs/er_diagram.png`
- [ ] FigJam-board skapad med alla 6 sektioner
- [ ] FigJam exporterad som PDF

### Fas 2 — MySQL-databas
- [ ] `db/schema.sql` skriven och testad
- [ ] Alla 8 tabeller skapas utan fel
- [ ] FK-relationer fungerar korrekt
- [ ] ENUM, NOT NULL, UNIQUE används korrekt
- [ ] `created_at` och `updated_at` finns på alla huvudtabeller
- [ ] Numeriskt attribut: `salary` i employees, `budget` i departments
- [ ] Datum-attribut: `hire_date` i employees, `start_date`/`end_date` i employee_roles
- [ ] `db/seed.sql` skriven och testad (data laddas in utan fel)
- [ ] `db/queries.sql` med minst 8 frågor som alla returnerar data
- [ ] JOIN-frågor fungerar korrekt
- [ ] Aggregeringsfrågor (COUNT, AVG, MIN, MAX) fungerar

### Fas 3 — Säkerhet
- [ ] `.env` skapad (kopierad från `.env.example`)
- [ ] `.env` innehåller: DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT
- [ ] `.gitignore` skapad med `.env` inkluderad
- [ ] `.env` syns INTE i `git status` (bekräfta!)
- [ ] Node.js-kod använder `process.env.DB_*` — inga hårdkodade lösenord
- [ ] `mysql2` med `connection.execute()` används (prepared statements)
- [ ] Ingen `connection.query()` med direkt string-interpolation

### Fas 4 — Node.js
- [ ] `package.json` skapad
- [ ] `npm install` kör utan fel
- [ ] `src/config/db.js` ansluter till databasen
- [ ] `node src/index.js` skriver "Ansluten till databasen!"
- [ ] Minst ett model-fil med prepared statements fungerar

### Fas 5 — MongoDB (krävs av uppgiften)
- [ ] MongoDB installerat (lokalt eller MongoDB Atlas)
- [ ] `db/mongodb_schema.js` skapad
- [ ] Minst 2 collections definierade
- [ ] `db/mongodb_seed.js` med testdata
- [ ] `db/mongodb_queries.js` med minst 4 frågor
- [ ] Reflektioner om skillnader MySQL vs MongoDB skrivna

### Fas 6 — Dokumentation
- [ ] `docs/projektdokument.md` skriven med alla rubriker
- [ ] ER-diagram inkluderat i dokumentet (Mermaid eller bild)
- [ ] 3NF-analys inkluderad i dokumentet
- [ ] `docs/reflektion.md` skriven
- [ ] `docs/muntlig_forberedelse.md` skriven
- [ ] Alla filer namngivna korrekt
- [ ] Dokument länkat in i "Slutprojekt Databaser F25"

### Fas 7 — Inlämning och presentation
- [ ] Alla filer samlade i projektmappen
- [ ] Inlämnat i rätt kanal/länk ("Slutprojekt Databaser F25")
- [ ] Förberedd på muntliga frågor (se `docs/muntlig_forberedelse.md`)
- [ ] Kan förklara varje designbeslut

---

## Krav från uppgiftsbeskrivningen — snabbkoll

| Krav | Var det finns |
|---|---|
| Minst 3 entiteter sammankopplade | 5 huvud + 3 kopplingstabeller |
| Minst 3 tabeller med kopplingar | Alla 8 tabeller har FK eller composite PK |
| Datum-attribut | `hire_date`, `start_date`, `end_date` i `employee_roles` |
| Numeriskt attribut | `salary` (employees), `budget` (departments) |
| 3NF uppfyllt | Dokumenterat i `schema.sql` och `projektdokument.md` |
| MySQL | `db/schema.sql`, `db/seed.sql`, `db/queries.sql` |
| MongoDB | `db/mongodb_queries.js` |
| Unik kunskapsdomän | "Kompetensbaserad personalorganisation" |
| ER-diagram | `docs/er_diagram.md` (3 format) |
| Reflektion | `docs/reflektion.md` |
| Muntlig presentation | `docs/muntlig_forberedelse.md` |

---

## Vanliga misstag — undvik dessa!

| Misstag | Hur du undviker det |
|---|---|
| `.env` committad till git | Kolla `git status` innan du committar — `.env` ska inte synas |
| Lösenord hårdkodat i db.js | Använd alltid `process.env.DB_PASSWORD` |
| M:N utan kopplningstabell | Skapa alltid en separat kopplningstabell (employee_roles etc.) |
| `connection.query()` med string concat | Använd alltid `connection.execute(sql, [params])` |
| Saknar created_at/updated_at | Lägg till på ALLA huvudtabeller |
| Kör seed.sql innan schema.sql | Alltid schema.sql FÖRST |
| TRUNCATE utan FOREIGN_KEY_CHECKS=0 | Seed-filen hanterar detta automatiskt |
