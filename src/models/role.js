const pool = require('../config/db');

async function getAllRoles() {
  const sql = `
    SELECT r.role_id, r.title, r.seniority_level,
           COUNT(DISTINCT er.employee_id) AS antal_anstallda,
           COUNT(DISTINCT rs.skill_id)    AS antal_kompetenser
    FROM roles r
    LEFT JOIN employee_roles er ON r.role_id = er.role_id AND er.end_date IS NULL
    LEFT JOIN role_skills rs    ON r.role_id = rs.role_id
    GROUP BY r.role_id, r.title, r.seniority_level
    ORDER BY r.title
  `;
  const [rows] = await pool.execute(sql);
  return rows;
}

async function getRoleWithSkills(roleId) {
  const sql = `
    SELECT r.title, r.description, r.seniority_level,
           s.name AS skill, s.category, rs.required_level
    FROM roles r
    INNER JOIN role_skills rs ON r.role_id = rs.role_id
    INNER JOIN skills s       ON rs.skill_id = s.skill_id
    WHERE r.role_id = ?
    ORDER BY rs.required_level DESC
  `;
  const [rows] = await pool.execute(sql, [roleId]);
  return rows;
}

async function getRoleWithTasks(roleId) {
  const sql = `
    SELECT r.title, t.title AS task, t.description, t.priority
    FROM roles r
    INNER JOIN role_tasks rt ON r.role_id = rt.role_id
    INNER JOIN tasks t       ON rt.task_id = t.task_id
    WHERE r.role_id = ?
    ORDER BY t.priority DESC
  `;
  const [rows] = await pool.execute(sql, [roleId]);
  return rows;
}

module.exports = { getAllRoles, getRoleWithSkills, getRoleWithTasks };
