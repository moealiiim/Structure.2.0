const pool = require('../config/db');

// Hämta alla anställda med avdelningsnamn
async function getAllEmployees() {
  const sql = `
    SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS full_name,
           e.email, e.employment_type, e.salary, e.hire_date, d.name AS department
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id
    ORDER BY e.last_name
  `;
  const [rows] = await pool.execute(sql);
  return rows;
}

// Hämta en anställd via ID — prepared statement skyddar mot SQL injection
async function getEmployeeById(id) {
  const sql = `
    SELECT e.*, d.name AS department_name
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id
    WHERE e.employee_id = ?
  `;
  const [rows] = await pool.execute(sql, [id]);
  return rows[0] || null;
}

// Hämta alla roller för en anställd
async function getEmployeeRoles(employeeId) {
  const sql = `
    SELECT r.title, r.seniority_level, er.start_date, er.end_date,
           CASE WHEN er.end_date IS NULL THEN 'Aktiv' ELSE 'Avslutad' END AS status
    FROM employee_roles er
    INNER JOIN roles r ON er.role_id = r.role_id
    WHERE er.employee_id = ?
    ORDER BY er.start_date DESC
  `;
  const [rows] = await pool.execute(sql, [employeeId]);
  return rows;
}

// Skapa ny anställd — prepared statement med alla parametrar
async function createEmployee({ departmentId, firstName, lastName, email, phone, employmentType, salary, hireDate }) {
  // Validering: e-post måste innehålla @
  if (!email || !email.includes('@')) {
    throw new Error('Ogiltig e-postadress');
  }
  // Validering: lön måste vara ett positivt tal
  if (typeof salary !== 'number' || salary < 0) {
    throw new Error('Lönen måste vara ett positivt tal');
  }

  const sql = `
    INSERT INTO employees (department_id, first_name, last_name, email, phone, employment_type, salary, hire_date)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `;
  const [result] = await pool.execute(sql, [
    departmentId, firstName, lastName, email, phone, employmentType, salary, hireDate
  ]);
  return result.insertId;
}

module.exports = { getAllEmployees, getEmployeeById, getEmployeeRoles, createEmployee };
