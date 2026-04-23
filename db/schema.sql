-- Personalhanteringssystem
-- Skapa databas och alla tabeller

CREATE DATABASE IF NOT EXISTS company_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE company_db;

-- Avdelningar
CREATE TABLE IF NOT EXISTS departments (
    department_id  INT            NOT NULL AUTO_INCREMENT,
    name           VARCHAR(100)   NOT NULL,
    description    TEXT,
    budget         DECIMAL(12,2)  NOT NULL DEFAULT 0.00,
    created_at     TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (department_id),
    UNIQUE KEY uq_department_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Anställda, kopplade till en avdelning via FK
CREATE TABLE IF NOT EXISTS employees (
    employee_id     INT            NOT NULL AUTO_INCREMENT,
    department_id   INT            NOT NULL,
    first_name      VARCHAR(50)    NOT NULL,
    last_name       VARCHAR(50)    NOT NULL,
    email           VARCHAR(100)   NOT NULL,
    phone           VARCHAR(20),
    employment_type ENUM('full-time','part-time','consultant') NOT NULL DEFAULT 'full-time',
    salary          DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    hire_date       DATE           NOT NULL,
    created_at      TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (employee_id),
    UNIQUE KEY uq_employee_email (email),
    CONSTRAINT fk_employees_department
        FOREIGN KEY (department_id)
        REFERENCES departments (department_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Roller / jobbtitlar
CREATE TABLE IF NOT EXISTS roles (
    role_id         INT          NOT NULL AUTO_INCREMENT,
    title           VARCHAR(100) NOT NULL,
    description     TEXT,
    seniority_level ENUM('junior','mid','senior','lead') NOT NULL DEFAULT 'mid',
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (role_id),
    UNIQUE KEY uq_role_title (title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Arbetsuppgifter
CREATE TABLE IF NOT EXISTS tasks (
    task_id     INT          NOT NULL AUTO_INCREMENT,
    title       VARCHAR(150) NOT NULL,
    description TEXT,
    priority    ENUM('low','medium','high') NOT NULL DEFAULT 'medium',
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (task_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Kompetenser
CREATE TABLE IF NOT EXISTS skills (
    skill_id    INT          NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    category    VARCHAR(50),
    description TEXT,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (skill_id),
    UNIQUE KEY uq_skill_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Koppling anställd <-> roll (M:N)
-- start_date och end_date visar när rollen var aktiv
-- end_date = NULL betyder att rollen är aktiv just nu
CREATE TABLE IF NOT EXISTS employee_roles (
    employee_id INT       NOT NULL,
    role_id     INT       NOT NULL,
    start_date  DATE      NOT NULL,
    end_date    DATE      NULL,
    assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (employee_id, role_id),
    CONSTRAINT chk_dates CHECK (end_date IS NULL OR end_date >= start_date),
    CONSTRAINT fk_er_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees (employee_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_er_role
        FOREIGN KEY (role_id)
        REFERENCES roles (role_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Koppling roll <-> uppgift (M:N)
CREATE TABLE IF NOT EXISTS role_tasks (
    role_id INT NOT NULL,
    task_id INT NOT NULL,

    PRIMARY KEY (role_id, task_id),
    CONSTRAINT fk_rt_role
        FOREIGN KEY (role_id)
        REFERENCES roles (role_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_rt_task
        FOREIGN KEY (task_id)
        REFERENCES tasks (task_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Koppling roll <-> kompetens (M:N)
-- required_level visar vilken nivå som krävs
CREATE TABLE IF NOT EXISTS role_skills (
    role_id        INT  NOT NULL,
    skill_id       INT  NOT NULL,
    required_level ENUM('basic','intermediate','advanced') NOT NULL DEFAULT 'intermediate',

    PRIMARY KEY (role_id, skill_id),
    CONSTRAINT fk_rs_role
        FOREIGN KEY (role_id)
        REFERENCES roles (role_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_rs_skill
        FOREIGN KEY (skill_id)
        REFERENCES skills (skill_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
