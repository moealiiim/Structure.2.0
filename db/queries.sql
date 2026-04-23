-- Exempelfrågor för personalhanteringssystemet
-- Kör i MySQL efter schema.sql och seed.sql

USE company_db;

-- 1. Vilka anställda jobbar på en viss avdelning?
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.email,
    e.employment_type,
    e.salary,
    d.name AS department
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE d.name = 'IT & Utveckling'
ORDER BY e.last_name;


-- 2. Vilka roller har en specifik anställd?
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    r.title                                AS role,
    r.seniority_level,
    er.start_date,
    er.end_date,
    CASE WHEN er.end_date IS NULL THEN 'Aktiv' ELSE 'Avslutad' END AS status
FROM employees e
INNER JOIN employee_roles er ON e.employee_id = er.employee_id
INNER JOIN roles r           ON er.role_id = r.role_id
WHERE e.email = 'amira.lindqvist@company.se'
ORDER BY er.start_date;


-- 3. Vilka arbetsuppgifter hör till en viss roll?
SELECT
    r.title          AS role,
    t.title          AS task,
    t.description,
    t.priority
FROM roles r
INNER JOIN role_tasks rt ON r.role_id = rt.role_id
INNER JOIN tasks t       ON rt.task_id = t.task_id
WHERE r.title = 'Projektledare'
ORDER BY t.priority DESC;


-- 4. Vilka kompetenser krävs för en viss roll?
SELECT
    r.title              AS role,
    s.name               AS skill,
    s.category,
    rs.required_level
FROM roles r
INNER JOIN role_skills rs ON r.role_id = rs.role_id
INNER JOIN skills s       ON rs.skill_id = s.skill_id
WHERE r.title = 'Systemutvecklare'
ORDER BY rs.required_level DESC;


-- 5. Vem kan utföra en specifik uppgift? (aktiva roller)
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.email,
    r.title                                AS role,
    t.title                                AS task,
    d.name                                 AS department
FROM tasks t
INNER JOIN role_tasks rt     ON t.task_id = rt.task_id
INNER JOIN roles r           ON rt.role_id = r.role_id
INNER JOIN employee_roles er ON r.role_id = er.role_id AND er.end_date IS NULL
INNER JOIN employees e       ON er.employee_id = e.employee_id
INNER JOIN departments d     ON e.department_id = d.department_id
WHERE t.title = 'Genomföra kodgranskningar'
ORDER BY e.last_name;


-- 6. Genomsnittslön per avdelning
SELECT
    d.name                              AS department,
    COUNT(e.employee_id)                AS antal_anstallda,
    ROUND(AVG(e.salary), 2)             AS genomsnittslön,
    MIN(e.salary)                       AS lägsta_lön,
    MAX(e.salary)                       AS högsta_lön,
    d.budget                            AS avdelningsbudget
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.name, d.budget
ORDER BY genomsnittslön DESC;


-- 7. Alla aktiva anställningar med roller
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS anställd,
    d.name                                  AS avdelning,
    r.title                                 AS roll,
    r.seniority_level,
    er.start_date,
    e.salary
FROM employees e
INNER JOIN departments d     ON e.department_id = d.department_id
INNER JOIN employee_roles er ON e.employee_id = er.employee_id
INNER JOIN roles r           ON er.role_id = r.role_id
WHERE er.end_date IS NULL
ORDER BY d.name, e.last_name;


-- 8. Vilka anställda har mer än en aktiv roll?
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS anställd,
    e.email,
    COUNT(er.role_id)                       AS antal_aktiva_roller
FROM employees e
INNER JOIN employee_roles er ON e.employee_id = er.employee_id
WHERE er.end_date IS NULL
GROUP BY e.employee_id, e.first_name, e.last_name, e.email
HAVING COUNT(er.role_id) > 1
ORDER BY antal_aktiva_roller DESC;


-- 9. Kompetenser utan kopplad roll
SELECT
    s.name     AS kompetens,
    s.category,
    s.description
FROM skills s
LEFT JOIN role_skills rs ON s.skill_id = rs.skill_id
WHERE rs.role_id IS NULL;


-- 10. Vilka har jobbat längst? (sorterat på hire_date)
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS anställd,
    d.name                                  AS avdelning,
    e.hire_date,
    DATEDIFF(CURDATE(), e.hire_date)         AS dagar_anställd,
    ROUND(DATEDIFF(CURDATE(), e.hire_date) / 365.25, 1) AS år_anställd,
    e.salary
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
ORDER BY e.hire_date ASC;


-- 11. Roller sorterade efter antal kopplade kompetenser
SELECT
    r.title                     AS roll,
    r.seniority_level,
    COUNT(rs.skill_id)          AS antal_kompetenser_krävs
FROM roles r
LEFT JOIN role_skills rs ON r.role_id = rs.role_id
GROUP BY r.role_id, r.title, r.seniority_level
ORDER BY antal_kompetenser_krävs DESC;


-- 12. Hitta anställda med en specifik kompetens (via roll)
SELECT DISTINCT
    CONCAT(e.first_name, ' ', e.last_name) AS anställd,
    e.email,
    d.name                                  AS avdelning
FROM employees e
INNER JOIN departments d     ON e.department_id = d.department_id
INNER JOIN employee_roles er ON e.employee_id = er.employee_id AND er.end_date IS NULL
INNER JOIN roles r           ON er.role_id = r.role_id
INNER JOIN role_skills rs    ON r.role_id = rs.role_id
INNER JOIN skills s          ON rs.skill_id = s.skill_id
WHERE s.name = 'Python'
ORDER BY e.last_name;
