const pool = require('../config/db');

async function getAllTasks() {
  const sql = 'SELECT * FROM tasks ORDER BY priority DESC, title';
  const [rows] = await pool.execute(sql);
  return rows;
}

async function findPersonForTask(taskTitle) {
  const sql = `
    SELECT DISTINCT CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
           e.email, r.title AS role, d.name AS department
    FROM tasks t
    INNER JOIN role_tasks rt     ON t.task_id = rt.task_id
    INNER JOIN roles r           ON rt.role_id = r.role_id
    INNER JOIN employee_roles er ON r.role_id = er.role_id AND er.end_date IS NULL
    INNER JOIN employees e       ON er.employee_id = e.employee_id
    INNER JOIN departments d     ON e.department_id = d.department_id
    WHERE t.title = ?
  `;
  const [rows] = await pool.execute(sql, [taskTitle]);
  return rows;
}

module.exports = { getAllTasks, findPersonForTask };
