const pool = require('../config/db');

async function getAllDepartments() {
  const sql = `
    SELECT d.department_id, d.name, d.description, d.budget,
           COUNT(e.employee_id) AS antal_anstallda
    FROM departments d
    LEFT JOIN employees e ON d.department_id = e.department_id
    GROUP BY d.department_id, d.name, d.description, d.budget
    ORDER BY d.name
  `;
  const [rows] = await pool.execute(sql);
  return rows;
}

async function getDepartmentById(id) {
  const sql = 'SELECT * FROM departments WHERE department_id = ?';
  const [rows] = await pool.execute(sql, [id]);
  return rows[0] || null;
}

async function getEmployeesByDepartment(departmentName) {
  const sql = `
    SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS full_name,
           e.email, e.employment_type, e.salary
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id
    WHERE d.name = ?
    ORDER BY e.last_name
  `;
  const [rows] = await pool.execute(sql, [departmentName]);
  return rows;
}

module.exports = { getAllDepartments, getDepartmentById, getEmployeesByDepartment };
