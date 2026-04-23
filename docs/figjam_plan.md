# FigJam-plan — Personalhanteringssystem

## Steg 7 — Komplett FigJam-guide

FigJam är ett digitalt whiteboard-verktyg från Figma. Du når det på **figjam.com** eller via din Figma-app. Alla element nedan kan du copy-paste direkt in i dina sticky notes och frames.

---

## Hur FigJam-boarden ska se ut — Översikt

Din board ska ha **6 sektioner (frames/areas)** placerade från vänster till höger:

```
[1. Projekttitel]  [2. Kunskapsdomän]  [3. Entiteter]  [4. ER-diagram]  [5. Tekniska val]  [6. Checklista]
```

Du skapar en frame (rektangel) för varje sektion. Använd Frame-verktyget (F) i FigJam.

---

## Sektion 1 — Projekttitel och översikt

**Rubrik (stor text, centrerad):**
```
Personalhanteringssystem
Databasdesign – Skolprojekt 2026
```

**Sticky note (gul):**
```
Projektets syfte:
Hjälpa ett företag att hålla ordning
på anställda, roller, avdelningar,
arbetsuppgifter och kompetenser.
```

**Sticky note (gul):**
```
Tekniker som används:
• MySQL (databas)
• Node.js (backend)
• mysql2 + dotenv (npm-paket)
• .env för säkerhet
```

**Sticky note (blå):**
```
Skapat av: [Ditt namn]
Kurs: [Kursnamn]
Datum: 2026-04-23
```

---

## Sektion 2 — Kunskapsdomän och problemformulering

**Rubrik:**
```
Kunskapsdomän & Problemformulering
```

**Sticky note (lila, stor):**
```
KUNSKAPSDOMÄN:
Kompetensbaserad personalorganisation

Ett system för att strukturera vem som
jobbar var, i vilken roll, med vilka
uppgifter och med vilka kompetenser.
```

**Sticky note (röd):**
```
PROBLEMET:
Företaget har ingen struktur för sin
personal. Det är oklart vem som gör
vad, vilka kompetenser som finns och
hur man hittar rätt person för rätt jobb.
```

**Sticky note (grön):**
```
LÖSNINGEN:
En relationsdatabas med tabeller för
anställda, avdelningar, roller, uppgifter
och kompetenser. Kopplade med FK och
kopplingstabeller.
```

**Sticky note (orange):**
```
MÅL:
• Vilka jobbar på avdelning X?
• Vilka roller har person Y?
• Vilka uppgifter hör till roll Z?
• Vilka kompetenser krävs?
• Vem passar bäst för uppgift X?
```

---

## Sektion 3 — Entiteter (de 5 huvudtabellerna)

**Rubrik:**
```
5 Huvudentiteter + 3 Kopplingstabeller
```

Gör **5 kort (cards)** i FigJam — ett per entitet. Varje kort ska se ut så här:

**Kort 1 (grön):**
```
EMPLOYEES (Anställda)
──────────────────────
PK employee_id
   first_name
   last_name
   email
   phone
   employment_type (ENUM)
   hire_date
FK department_id
   created_at
   updated_at
```

**Kort 2 (blå):**
```
DEPARTMENTS (Avdelningar)
──────────────────────────
PK department_id
   name (UNIQUE)
   description
   created_at
   updated_at
```

**Kort 3 (gul):**
```
ROLES (Roller)
──────────────
PK role_id
   title (UNIQUE)
   description
   seniority_level (ENUM)
   created_at
   updated_at
```

**Kort 4 (orange):**
```
TASKS (Arbetsuppgifter)
────────────────────────
PK task_id
   title
   description
   priority (ENUM)
   created_at
   updated_at
```

**Kort 5 (lila):**
```
SKILLS (Kompetenser)
────────────────────
PK skill_id
   name (UNIQUE)
   category
   description
   created_at
   updated_at
```

**Kopplingstabeller (grå):**
```
EMPLOYEE_ROLES         ROLE_TASKS          ROLE_SKILLS
──────────────         ──────────          ───────────
FK employee_id         FK role_id          FK role_id
FK role_id             FK task_id          FK skill_id
   assigned_at                                required_level
```

---

## Sektion 4 — ER-diagram

**Rubrik:**
```
ER-diagram – Relationer och kardinalitet
```

**Sticky note (blå):**
```
RELATIONSKARTA:

employees ──N:1──► departments
(Varje anställd tillhör EN avdelning)

employees ◄─M:N─► roles
(Via employee_roles-tabellen)

roles ◄─M:N─► tasks
(Via role_tasks-tabellen)

roles ◄─M:N─► skills
(Via role_skills-tabellen)
```

**Sticky note (grön):**
```
KARDINALITET:
1:1  =  En-till-en
1:N  =  En-till-många
N:1  =  Många-till-en
M:N  =  Många-till-många
       (kräver kopplningstabell!)
```

**Sticky note (röd, viktig):**
```
OBS! Vanligt misstag:
Försök ALDRIG lösa M:N utan
kopplningstabell. Det bryter mot
normalformsreglerna och skapar
rörig, duplicerad data.
```

**Infoga bild här:**
```
[Exportera er_diagram.png från dbdiagram.io
 och dra in den i denna sektion]
```

---

## Sektion 5 — Tekniska val och säkerhet

**Rubrik:**
```
Tekniska val och säkerhetslösningar
```

**Sticky note (blå):**
```
DATABASVAL: MySQL
• Strukturerad data ✓
• FK och JOINs ✓
• Prepared statements ✓
• Välkänt i skolmiljö ✓
• Passar relationell data ✓
```

**Sticky note (grön):**
```
DATATYPER:
• INT – ID-kolumner
• VARCHAR(n) – namn, email
• TEXT – längre beskrivningar
• ENUM – begränsade val
• DATE – datum (anställningsdatum)
• TIMESTAMP – created_at, updated_at
```

**Sticky note (röd):**
```
SÄKERHET:
✓ .env för alla lösenord
✓ .gitignore exkluderar .env
✓ Prepared statements (mysql2)
✓ Ingen hårdkodad connection string
✓ Input valideras i Node.js
```

**Sticky note (orange):**
```
PROJEKTSTRUKTUR:
db/
  schema.sql
  seed.sql
  queries.sql
src/
  config/db.js
  models/
  index.js
docs/
.env.example
.gitignore
package.json
```

---

## Sektion 6 — Projektkrav-checklista

**Rubrik:**
```
Checklista – Uppgiftskrav
```

Kopiera dessa sticky notes och bocka av dem när du är klar:

**Sticky note (grön, liten) × 15 st:**
```
☐ Kunskapsdomän definierad
☐ 5 huvudentiteter identifierade
☐ ER-diagram skapat (textformat)
☐ ER-diagram i dbdiagram.io
☐ ER-diagram exporterat som PNG
☐ Relationer dokumenterade (1:N, M:N)
☐ M:N löst med kopplingstabeller
☐ schema.sql skriven och testad
☐ seed.sql med testdata
☐ queries.sql med 10+ frågor
☐ .env-fil skapad (ej committad)
☐ .gitignore med .env
☐ Prepared statements används
☐ Projektdokument skrivet
☐ Reflektion skriven
☐ Muntlig presentation förberedd
```

---

## Färgkodning för FigJam

| Färg | Användning |
|---|---|
| Grön | Klart / OK / Huvud-entiteter |
| Blå | Information / Tekniska detaljer |
| Gul | Grundinformation / Titel-sticky notes |
| Orange | Mål / Struktur |
| Lila | Kunskapsdomän / Kopplingstabeller |
| Röd | Varningar / Problem / Säkerhet |
| Grå | Kopplingstabeller / Sekundärt |

---

## Export från FigJam

### Exportera hela boarden som PDF
1. Klicka på **hamburgarmenyn (☰)** uppe till vänster
2. Välj **"Export"** → **"Export frames to PDF"**
3. Välj alla frames
4. Klicka **"Export"**
5. Spara filen som `figjam_board.pdf` i mappen `docs/`

### Exportera som bild (PNG)
1. Välj alla element (Ctrl+A)
2. Högerklicka → **"Export selection"**
3. Välj **PNG** och **2x** upplösning
4. Spara som `figjam_overview.png` i mappen `docs/`

### Exportera ER-diagram separat
1. Markera bara Sektion 4 (ER-diagrammet)
2. Högerklicka → **"Export selection"**
3. Välj PNG → Spara som `er_diagram_figjam.png` i `docs/`

---

## Snabbguide — Verktyg i FigJam

| Verktyg | Tangent | Används till |
|---|---|---|
| Sticky note | S | Lägga till anteckningar |
| Frame | F | Skapa sektioner |
| Text | T | Rubriker och etiketter |
| Pil/Linje | L | Rita relationer |
| Markör | V | Flytta element |
| Shapes | R | Rita rektanglar för tabeller |
| Zoom in/ut | Ctrl +/- | Navigera |
| Passa allt | Ctrl+Shift+H | Visa hela boarden |

---

## Hur du visar FigJam för läraren vid muntlig presentation

1. Öppna FigJam och gå till din board
2. Klicka **"Present"** (presentationsläge) uppe till höger
3. Flytta igenom sektionerna från vänster till höger
4. Börja med Sektion 1 (titel) → förklara projektet
5. Gå till Sektion 2 → förklara problemet
6. Gå till Sektion 3 → visa entiteterna
7. Gå till Sektion 4 → förklara ER-diagrammet och relationerna
8. Gå till Sektion 5 → förklara tekniska val och säkerhet
9. Gå till Sektion 6 → visa att du bockat av alla krav
