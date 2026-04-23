require('dotenv').config();
const pool = require('./config/db');
const { getAllEmployees, getEmployeeRoles } = require('./models/employee');
const { getAllDepartments, getEmployeesByDepartment } = require('./models/department');
const { getAllRoles, getRoleWithSkills } = require('./models/role');
const { findPersonForTask } = require('./models/task');
const { findEmployeesBySkill } = require('./models/skill');

async function main() {
  try {
    const conn = await pool.getConnection();
    console.log('Ansluten till databasen!');
    conn.release();

    console.log('\n=== ALLA ANSTÄLLDA ===');
    const employees = await getAllEmployees();
    employees.forEach(e => {
      console.log(`${e.full_name} | ${e.department} | ${e.employment_type} | ${e.salary} kr`);
    });

    console.log('\n=== IT & Utveckling ===');
    const itStaff = await getEmployeesByDepartment('IT & Utveckling');
    itStaff.forEach(e => console.log(`  ${e.full_name} — ${e.email}`));

    console.log('\n=== ROLLER FÖR ANSTÄLLD #1 ===');
    const roles = await getEmployeeRoles(1);
    roles.forEach(r => console.log(`  ${r.title} (${r.seniority_level}) — ${r.status}`));

    console.log('\n=== KOMPETENSER FÖR SYSTEMUTVECKLARE ===');
    const skills = await getRoleWithSkills(1);
    skills.forEach(s => console.log(`  ${s.skill} [${s.category}] — nivå: ${s.required_level}`));

    console.log('\n=== VEM KAN GENOMFÖRA KODGRANSKNINGAR? ===');
    const people = await findPersonForTask('Genomföra kodgranskningar');
    people.forEach(p => console.log(`  ${p.employee_name} (${p.role}) — ${p.department}`));

    console.log('\n=== VEM HAR PYTHON-KOMPETENS? ===');
    const pythonPeople = await findEmployeesBySkill('Python');
    pythonPeople.forEach(p => console.log(`  ${p.employee_name} — ${p.role} — ${p.required_level}`));

  } catch (err) {
    console.error('Fel:', err.message);
  } finally {
    await pool.end();
  }
}

main();
