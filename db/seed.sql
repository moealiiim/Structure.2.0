-- Testdata för personalhanteringssystemet
-- Kör schema.sql först, sedan denna fil

USE company_db;

-- Rensa befintlig data (i rätt ordning pga FK)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE role_skills;
TRUNCATE TABLE role_tasks;
TRUNCATE TABLE employee_roles;
TRUNCATE TABLE skills;
TRUNCATE TABLE tasks;
TRUNCATE TABLE roles;
TRUNCATE TABLE employees;
TRUNCATE TABLE departments;
SET FOREIGN_KEY_CHECKS = 1;

-- Avdelningar
INSERT INTO departments (name, description, budget) VALUES
('IT & Utveckling',     'Ansvarar för systemutveckling och teknisk infrastruktur.',    2500000.00),
('Human Resources',     'Hanterar rekrytering, personalvård och kompetensutveckling.', 800000.00),
('Ekonomi & Finans',    'Sköter redovisning, budget och finansiell planering.',         1200000.00),
('Marknad & Sälj',      'Driver marknadsföring, leads och kundrelationer.',             1750000.00),
('Projektledning',      'Koordinerar projekt och säkerställer leveranser i tid.',       950000.00);

-- Roller
INSERT INTO roles (title, description, seniority_level) VALUES
('Systemutvecklare',    'Designar, kodar och testar mjukvarusystem.',                  'mid'),
('Projektledare',       'Planerar och koordinerar projekt från start till leverans.',  'senior'),
('HR-specialist',       'Hanterar rekrytering, onboarding och medarbetarfrågor.',      'mid'),
('Ekonomianalytiker',   'Analyserar finansiell data och ger beslutsunderlag.',         'mid'),
('UX-designer',         'Skapar användarvänliga gränssnitt och prototyper.',           'junior'),
('Teamledare',          'Leder ett team, håller 1-on-1 och driver teamutveckling.',    'lead');

-- Kompetenser
INSERT INTO skills (name, category, description) VALUES
('Python',              'Programmering',    'Programmeringsspråk för backend och dataanalys.'),
('JavaScript',          'Programmering',    'Frontend- och backend-utveckling med JS/Node.js.'),
('MySQL',               'Databaser',        'Relationsdatabas — design, queries och optimering.'),
('Projektplanering',    'Ledarskap',        'Förmåga att planera och följa upp projekt.'),
('Rekrytering',         'HR',               'Hitta, attrahera och välja rätt kandidater.'),
('Ekonomiredovisning',  'Ekonomi',          'Bokföring, årsredovisning och finansiell rapportering.'),
('Git',                 'Verktyg',          'Versionshantering med Git och GitHub.'),
('Figma',               'Design',           'Prototyping och UI-design i Figma/FigJam.');

-- Arbetsuppgifter
INSERT INTO tasks (title, description, priority) VALUES
('Skriva teknisk dokumentation',     'Dokumentera API:er, arkitektur och kodstruktur.',             'medium'),
('Hålla statusmöten',                'Veckovisa möten med team och intressenter.',                   'high'),
('Genomföra kodgranskningar',        'Review:a kollegors kod för kvalitet och säkerhet.',            'high'),
('Rekrytera ny personal',            'Annonsera, intervjua och onboarda nya medarbetare.',           'medium'),
('Analysera ekonomisk data',         'Sammanställa och tolka månads- och kvartalssiffror.',          'high'),
('Designa användargränssnitt',       'Skapa wireframes och klickbara prototyper i Figma.',           'medium'),
('Planera sprint',                   'Definiera user stories och prioritera backlog för sprinten.',  'high'),
('Kompetenskartläggning',            'Inventera och analysera teamets kompetenser och gaps.',        'low');

-- Anställda
INSERT INTO employees (department_id, first_name, last_name, email, phone, employment_type, salary, hire_date) VALUES
(1, 'Amira',    'Lindqvist',  'amira.lindqvist@company.se',  '070-111 22 33', 'full-time',   42000.00, '2021-03-15'),
(1, 'Carlos',   'Bergström',  'carlos.bergstrom@company.se', '070-222 33 44', 'full-time',   38000.00, '2022-08-01'),
(2, 'Fatima',   'Johansson',  'fatima.johansson@company.se', '073-333 44 55', 'full-time',   36000.00, '2020-06-10'),
(3, 'Erik',     'Sundqvist',  'erik.sundqvist@company.se',   '076-444 55 66', 'full-time',   44000.00, '2019-01-20'),
(4, 'Lena',     'Hakala',     'lena.hakala@company.se',      '070-555 66 77', 'part-time',   25000.00, '2023-02-28'),
(5, 'Marcus',   'Nilsson',    'marcus.nilsson@company.se',   '070-666 77 88', 'full-time',   48000.00, '2018-09-05'),
(1, 'Sofia',    'Abdi',       'sofia.abdi@company.se',       '073-777 88 99', 'consultant',  55000.00, '2024-01-10'),
(2, 'Johan',    'Patel',      'johan.patel@company.se',      '076-888 99 00', 'full-time',   37000.00, '2022-11-14');

-- Koppling anställd <-> roll
-- end_date = NULL betyder att rollen är aktiv just nu
INSERT INTO employee_roles (employee_id, role_id, start_date, end_date) VALUES
(1, 1, '2021-03-15', NULL),
(1, 6, '2023-01-01', NULL),
(2, 1, '2022-08-01', NULL),
(2, 5, '2023-06-01', NULL),
(3, 3, '2020-06-10', NULL),
(4, 4, '2019-01-20', NULL),
(5, 4, '2023-02-28', '2024-12-31'),
(6, 2, '2018-09-05', NULL),
(6, 6, '2020-01-01', NULL),
(7, 1, '2024-01-10', NULL),
(8, 3, '2022-11-14', '2024-06-30');

-- Koppling roll <-> uppgift
INSERT INTO role_tasks (role_id, task_id) VALUES
(1, 1), (1, 3),
(2, 2), (2, 7), (2, 8),
(3, 4), (3, 8),
(4, 5),
(5, 6), (5, 1),
(6, 2), (6, 8);

-- Koppling roll <-> kompetens
INSERT INTO role_skills (role_id, skill_id, required_level) VALUES
(1, 1, 'advanced'),
(1, 2, 'advanced'),
(1, 3, 'intermediate'),
(1, 7, 'intermediate'),
(2, 4, 'advanced'),
(2, 3, 'basic'),
(3, 5, 'advanced'),
(4, 6, 'advanced'),
(4, 1, 'basic'),
(5, 8, 'advanced'),
(5, 2, 'intermediate'),
(6, 4, 'advanced'),
(6, 5, 'intermediate');
