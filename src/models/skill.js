const pool = require('../config/db');

async function getAllSkills() {
  const sql = 'SELECT * FROM skills ORDER BY category, name';
  const [rows] = await pool.execute(sql);
  return rows;
}

async function findEmployeesBySkill(skillName) {
  const sql = `
    SELECT DISTINCT CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
           e.email, r.title AS role, rs.required_level, d.name AS department
    FROM skills s
    INNER JOIN role_skills rs    ON s.skill_id = rs.skill_id
    INNER JOIN roles r           ON rs.role_id = r.role_id
    INNER JOIN employee_roles er ON r.role_id = er.role_id AND er.end_date IS NULL
    INNER JOIN employees e       ON er.employee_id = e.employee_id
    INNER JOIN departments d     ON e.department_id = d.department_id
    WHERE s.name = ?
    ORDER BY e.last_name
  `;
  const [rows] = await pool.execute(sql, [skillName]);
  return rows;
}

module.exports = { getAllSkills, findEmployeesBySkill };
