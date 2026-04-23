# Reflektion — Personalhanteringssystem

## Arbetsprocess

Jag började projektet med att tänka igenom vad som faktiskt behövde lagras i databasen. Det var viktigt att förstå domänen ordentligt innan jag satte igång med SQL. Jag valde personalhantering som domän för att det är ett konkret problem som ett riktigt företag kan ha — det handlar om att strukturera information som finns i verkligheten.

Det första steget var att rita upp entiteterna och fundera på hur de hänger ihop. Jag identifierade snabbt att relationen mellan anställda och roller är ett tydligt exempel på en många-till-många-relation — en person kan ha flera roller och en roll kan innehas av flera personer. Det löste jag med kopplingstabellen `employee_roles`. Samma mönster upprepades för roll–uppgift och roll–kompetens.

## Designval

Jag valde MySQL framför MongoDB eftersom datan är relationell och välstrukturerad. Alla entiteter har tydliga kopplingar och det är viktigt att FK-integritet upprätthålls automatiskt av databasen. Det är en styrka hos MySQL som MongoDB saknar inbyggt.

Jag valde att lägga till `salary` i `employees` och `budget` i `departments` för att ha numeriska attribut. Jag lade också till `start_date` och `end_date` i kopplingstabellen `employee_roles` för att kunna spåra när en anställd fick eller slutade med en roll — det är information som faktiskt är värdefull i verkligheten.

För säkerheten valde jag att använda `dotenv` och en `.env`-fil för alla databasuppgifter. Jag ser till att `.env` aldrig committeras till git. All SQL körs med prepared statements via `mysql2`, vilket skyddar mot SQL injection.

## Vad jag lärde mig

Jag lärde mig att det viktigaste i databasdesign är att tänka rätt från början. Om jag hade börjat koda utan att rita ett ER-diagram hade jag troligtvis missat några M:N-relationer och fått problem med duplicerad data.

Jag lärde mig också konkret vad 3NF innebär i praktiken. Det handlar om att varje kolumn ska bero direkt på primärnyckeln — inte via en annan kolumn. Till exempel lagrar jag `department_id` som FK i `employees`, inte `department_name` direkt. Det gör att om avdelningens namn ändras räcker det att uppdatera en rad i `departments`, inte alla rader i `employees`.

Arbetet med MongoDB visade mig att det finns ett annat sätt att tänka på data. I MongoDB kan man "embeda" relaterade dokument direkt, vilket kan ge snabbare läsning men också skapa problem om data dupliceras. Det var värdefullt att jämföra de två systemen praktiskt.

## Vad som var svårt

Det svåraste momentet var att bestämma vad som skulle vara en separat tabell och vad som kunde vara ett attribut. Till exempel funderade jag på om `seniority_level` i `roles` behövde vara en egen tabell. Jag valde att göra det till ett ENUM-attribut istället för en egen tabell, eftersom det bara är ett begränsat antal fasta värden och det inte finns någon annan information kopplad till senioritetsnivån.

## Slutord

Projektet gav mig en tydlig bild av hela processen — från problemformulering och ER-diagram, via SQL-design och testdata, till säkerhetslösningar och dokumentation. Jag är nöjd med strukturen på databasen och anser att den uppfyller alla krav från uppgiften.
