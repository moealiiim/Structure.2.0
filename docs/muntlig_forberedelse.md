# Muntlig förberedelse — Personalhanteringssystem

## Miniguide för muntlig presentation

### Hur du strukturerar presentationen (5–10 minuter)

1. **Introduktion (1 min)** — Vad handlar projektet om?
   > "Jag har byggt en databas för ett personalhanteringssystem. Domänen är kompetensbaserad personalorganisation — alltså hur ett företag håller koll på sina anställda, roller, avdelningar, uppgifter och kompetenser."

2. **ER-diagrammet (2–3 min)** — Visa diagrammet och förklara strukturen
   > "Här är mina 5 huvudentiteter och hur de är kopplade. Jag har tre många-till-många-relationer som jag löst med kopplingstabeller."

3. **SQL-demonstration (2–3 min)** — Kör ett par frågor live om möjligt
   > "Nu ska jag visa hur databasen svarar på frågan 'vem kan utföra kodgranskningar?' och 'vad är genomsnittslönen per avdelning?'"

4. **Säkerhet (1 min)** — Förklara .env och prepared statements
   > "Jag har använt .env för att aldrig lagra lösenord i kod, och prepared statements för att skydda mot SQL injection."

5. **MongoDB (1–2 min)** — Jämför med MySQL
   > "Jag har också översatt delar till MongoDB och kan berätta om skillnaderna."

6. **Reflektion (1 min)**
   > "Det svåraste var att bestämma vilka M:N-relationer som behövdes och hur man normaliserar korrekt till 3NF."

---

## Möjliga frågor från läraren — med bra svar

---

### Fråga 1: Vad är en primärnyckel (PK) och varför behöver vi den?

**Svar:**
> En primärnyckel är en kolumn (eller kombination av kolumner) som unikt identifierar varje rad i en tabell. Utan primärnyckel kan vi inte skilja på olika rader. I min databas har till exempel `employees` kolumnen `employee_id` som PK — det är ett heltal som räknas upp automatiskt för varje ny anställd. Det gör att vi alltid kan hitta exakt rätt person.

---

### Fråga 2: Vad är en främmande nyckel (FK) och hur använder du den?

**Svar:**
> En främmande nyckel är en kolumn i en tabell som pekar på primärnyckeln i en annan tabell. Den skapar en koppling mellan tabellerna. I min databas har `employees` en kolumn `department_id` som är FK mot `departments.department_id`. Det betyder att vi aldrig kan lägga in en anställd med en avdelning som inte finns — MySQL blockerar det automatiskt. Det kallas referensintegritet.

---

### Fråga 3: Vad är en många-till-många-relation och hur löser du den?

**Svar:**
> En många-till-många-relation uppstår när en post i tabell A kan kopplas till flera poster i tabell B, och tvärtom. Till exempel: en anställd kan ha flera roller, och en roll kan innehas av flera anställda. Det kan vi inte lösa med en enkel FK. Lösningen är en kopplingstabellen `employee_roles` med FK till båda tabellerna. Composite PK (employee_id + role_id) förhindrar att samma kombination läggs in två gånger.

---

### Fråga 4: Vad är 3NF och uppfyller din databas det?

**Svar:**
> 3NF — tredje normalformen — innebär tre saker:
> 1. Atomära värden i varje cell (1NF)
> 2. Alla icke-nyckel-attribut beror på hela primärnyckeln (2NF)
> 3. Inga transitiva beroenden — varje attribut beror direkt på PK, inte via ett annat attribut (3NF)
>
> Min databas uppfyller 3NF. Till exempel lagrar jag inte `department_name` direkt i `employees`-tabellen, utan bara `department_id` som FK. Om avdelningens namn ändras räcker det att uppdatera en rad i `departments`. Om jag hade lagrat namnet direkt hade jag brutit mot 3NF.

---

### Fråga 5: Varför valde du MySQL och inte MongoDB?

**Svar:**
> Data i mitt projekt är relationell och välstrukturerad — det är tydliga kopplingar mellan anställda, roller och kompetenser. MySQL passar bra för det eftersom det har inbyggt stöd för foreign keys och JOIN. MongoDB är starkare när datan är ostrukturerad eller ofta ändrar form. Jag använde MongoDB som komplettering i projektet och jämförde de två systemen, men för kärnfunktionaliteten passar MySQL bättre.

---

### Fråga 6: Vad är SQL injection och hur skyddar du dig?

**Svar:**
> SQL injection är ett säkerhetsangrepp där en angripare skickar skadlig SQL-kod som input. Till exempel om man gör `WHERE id = ` + användarinput, kan angriparen skriva `1 OR 1=1` och få ut all data. Jag skyddar mig med **prepared statements** via `mysql2`. Jag skickar SQL-koden och parametrarna separat med `connection.execute(sql, [params])`. Databasen hanterar dem som data, aldrig som kod.

---

### Fråga 7: Vad är fördelen med att ha `created_at` och `updated_at`?

**Svar:**
> Det är metadata som berättar när en rad skapades och senast ändrades. Det är användbart för felsökning, audit-trail och för att kunna sortera eller filtrera på tidpunkt. `created_at` sätts automatiskt när raden skapas (`DEFAULT CURRENT_TIMESTAMP`), och `updated_at` uppdateras automatiskt varje gång raden ändras (`ON UPDATE CURRENT_TIMESTAMP`). Det kräver alltså noll extra kod i applikationen.

---

### Fråga 8: Vad är ENUM och när är det bra att använda?

**Svar:**
> ENUM är en datatyp som begränsar en kolumn till ett fördefinierat antal tillåtna värden. I min databas har `employees.employment_type` ENUM med värdena `'full-time'`, `'part-time'`, `'consultant'`. Fördelarna är att vi garanterar datakvalitet (inget felstavat värde kan läggas in), det är tydligt dokumenterat direkt i schemat, och det sparar lite lagringsutrymme. Nackdelen är att det är lite omständligt att lägga till nya värden senare — det kräver ett `ALTER TABLE`.

---

### Fråga 9: Hur fungerar din `start_date` och `end_date` i employee_roles?

**Svar:**
> `start_date` anger när en anställd fick en roll. `end_date` är NULL om rollen fortfarande är aktiv, och innehåller ett datum om rollen avslutades. Det gör att vi kan se historik — inte bara vilka roller någon har nu, utan även vilka roller de hade förut och under vilken period. I mina queries filtrerar jag på `WHERE end_date IS NULL` för att bara visa aktiva roller.

---

### Fråga 10: Kan du förklara skillnaden mellan MySQL och MongoDB i korthet?

**Svar:**
> MySQL är en **relationsdatabas** — data lagras i tabeller med rader och kolumner, och tabeller kopplas samman med foreign keys och JOIN. Den ger starka garantier för dataintegritet. MongoDB är en **dokumentdatabas** — data lagras som JSON-dokument i collections. Det är mer flexibelt men saknar inbyggda FK-garantier. För mitt projekt med tydliga relationer passar MySQL bättre, men jag har också implementerat en MongoDB-version för jämförelse.

---

## Nyckeltermer att kunna förklara

| Term | Kort förklaring |
|---|---|
| Entitet | Det vi vill lagra information om (t.ex. "anställd", "roll") |
| Attribut | En egenskap hos en entitet (t.ex. "email", "salary") |
| Primärnyckel (PK) | Unikt ID för varje rad |
| Främmande nyckel (FK) | Referens till PK i annan tabell |
| Kardinalitet | Hur många som kan kopplas ihop (1:1, 1:N, M:N) |
| Kopplningstabell | Löser M:N-relation med en extra tabell |
| 3NF | Tredje normalformen — ingen transitiv beroende |
| Prepared statement | SQL-fråga med separata parametrar — skyddar mot injection |
| ENUM | Kolumntyp med fördefinierade tillåtna värden |
| JOIN | Kombinerar rader från flera tabeller baserat på FK |
| Aggregering | Beräkningar på grupper (COUNT, AVG, SUM, MIN, MAX) |
| Embedded document | MongoDB: inbäddat objekt/array i ett dokument |
| Collection | MongoDB: samling av dokument (motsvarar tabell) |
