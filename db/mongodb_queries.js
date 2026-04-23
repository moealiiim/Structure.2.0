// MongoDB-version av personalhanteringssystemet
// Roller embedas direkt i employee-dokumentet
// Kör: node db/mongodb_queries.js
// Behöver: npm install mongodb

require('dotenv').config();
const { MongoClient } = require('mongodb');

// Lägg till MONGO_URI i .env-filen
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017';
const DB_NAME   = 'company_db_mongo';

const departmentsData = [
  { name: 'IT & Utveckling',  description: 'Systemutveckling och infrastruktur', budget: 2500000 },
  { name: 'Human Resources',  description: 'Rekrytering och personalvård',         budget: 800000  },
  { name: 'Ekonomi & Finans', description: 'Redovisning och finansiell planering', budget: 1200000 },
  { name: 'Marknad & Sälj',   description: 'Marknadsföring och kundrelationer',     budget: 1750000 },
  { name: 'Projektledning',   description: 'Koordinering av projekt',               budget: 950000  },
];

const skillsData = [
  { name: 'Python',             category: 'Programmering' },
  { name: 'JavaScript',         category: 'Programmering' },
  { name: 'MySQL',              category: 'Databaser'     },
  { name: 'Projektplanering',   category: 'Ledarskap'     },
  { name: 'Rekrytering',        category: 'HR'            },
  { name: 'Ekonomiredovisning', category: 'Ekonomi'       },
  { name: 'Git',                category: 'Verktyg'       },
  { name: 'Figma',              category: 'Design'        },
];

const employeesData = [
  {
    first_name: 'Amira', last_name: 'Lindqvist',
    email: 'amira.lindqvist@company.se',
    employment_type: 'full-time', salary: 42000,
    hire_date: new Date('2021-03-15'),
    department: 'IT & Utveckling',
    roles: [
      { title: 'Systemutvecklare', seniority_level: 'mid',  start_date: new Date('2021-03-15'), end_date: null },
      { title: 'Teamledare',       seniority_level: 'lead', start_date: new Date('2023-01-01'), end_date: null },
    ],
  },
  {
    first_name: 'Carlos', last_name: 'Bergström',
    email: 'carlos.bergstrom@company.se',
    employment_type: 'full-time', salary: 38000,
    hire_date: new Date('2022-08-01'),
    department: 'IT & Utveckling',
    roles: [
      { title: 'Systemutvecklare', seniority_level: 'mid',    start_date: new Date('2022-08-01'), end_date: null },
      { title: 'UX-designer',      seniority_level: 'junior', start_date: new Date('2023-06-01'), end_date: null },
    ],
  },
  {
    first_name: 'Fatima', last_name: 'Johansson',
    email: 'fatima.johansson@company.se',
    employment_type: 'full-time', salary: 36000,
    hire_date: new Date('2020-06-10'),
    department: 'Human Resources',
    roles: [
      { title: 'HR-specialist', seniority_level: 'mid', start_date: new Date('2020-06-10'), end_date: null },
    ],
  },
  {
    first_name: 'Erik', last_name: 'Sundqvist',
    email: 'erik.sundqvist@company.se',
    employment_type: 'full-time', salary: 44000,
    hire_date: new Date('2019-01-20'),
    department: 'Ekonomi & Finans',
    roles: [
      { title: 'Ekonomianalytiker', seniority_level: 'mid', start_date: new Date('2019-01-20'), end_date: null },
    ],
  },
  {
    first_name: 'Marcus', last_name: 'Nilsson',
    email: 'marcus.nilsson@company.se',
    employment_type: 'full-time', salary: 48000,
    hire_date: new Date('2018-09-05'),
    department: 'Projektledning',
    roles: [
      { title: 'Projektledare', seniority_level: 'senior', start_date: new Date('2018-09-05'), end_date: null },
      { title: 'Teamledare',    seniority_level: 'lead',   start_date: new Date('2020-01-01'), end_date: null },
    ],
  },
  {
    first_name: 'Sofia', last_name: 'Abdi',
    email: 'sofia.abdi@company.se',
    employment_type: 'consultant', salary: 55000,
    hire_date: new Date('2024-01-10'),
    department: 'IT & Utveckling',
    roles: [
      { title: 'Systemutvecklare', seniority_level: 'senior', start_date: new Date('2024-01-10'), end_date: null },
    ],
  },
];

async function runDemo() {
  const client = new MongoClient(MONGO_URI);

  try {
    await client.connect();
    console.log('Ansluten till MongoDB!');

    const db = client.db(DB_NAME);

    await db.collection('departments').deleteMany({});
    await db.collection('skills').deleteMany({});
    await db.collection('employees').deleteMany({});

    await db.collection('departments').insertMany(departmentsData);
    await db.collection('skills').insertMany(skillsData);
    await db.collection('employees').insertMany(employeesData);
    console.log('Testdata inlagd.\n');

    // 1. Anställda på IT & Utveckling
    console.log('=== Anställda på IT & Utveckling ===');
    const itStaff = await db.collection('employees')
      .find({ department: 'IT & Utveckling' })
      .project({ first_name: 1, last_name: 1, email: 1, salary: 1 })
      .toArray();
    itStaff.forEach(e => console.log(`  ${e.first_name} ${e.last_name} — ${e.salary} kr`));

    // 2. Alla aktiva Systemutvecklare ($elemMatch på inbäddad array)
    console.log('\n=== Alla aktiva Systemutvecklare ===');
    const devs = await db.collection('employees')
      .find({ roles: { $elemMatch: { title: 'Systemutvecklare', end_date: null } } })
      .project({ first_name: 1, last_name: 1, email: 1, department: 1 })
      .toArray();
    devs.forEach(e => console.log(`  ${e.first_name} ${e.last_name} — ${e.department}`));

    // 3. Genomsnittslön per avdelning (aggregation pipeline)
    console.log('\n=== Genomsnittslön per avdelning ===');
    const avgSalary = await db.collection('employees').aggregate([
      {
        $group: {
          _id: '$department',
          genomsnittslön: { $avg: '$salary' },
          antal:          { $sum: 1 },
        },
      },
      { $sort: { genomsnittslön: -1 } },
    ]).toArray();
    avgSalary.forEach(d => {
      console.log(`  ${d._id}: snitt ${Math.round(d.genomsnittslön)} kr (${d.antal} anställda)`);
    });

    // 4. Anställda med mer än en aktiv roll
    console.log('\n=== Anställda med mer än en aktiv roll ===');
    const multiRole = await db.collection('employees').aggregate([
      {
        $addFields: {
          aktiva_roller: {
            $filter: {
              input: '$roles',
              as: 'r',
              cond: { $eq: ['$$r.end_date', null] },
            },
          },
        },
      },
      { $match: { $expr: { $gt: [{ $size: '$aktiva_roller' }, 1] } } },
      { $project: { first_name: 1, last_name: 1, antal_roller: { $size: '$aktiva_roller' } } },
    ]).toArray();
    multiRole.forEach(e => {
      console.log(`  ${e.first_name} ${e.last_name} — ${e.antal_roller} aktiva roller`);
    });

    // 5. Anställda sorterade efter anställningsdatum
    console.log('\n=== Sorterat efter anställningsdatum ===');
    const byHireDate = await db.collection('employees')
      .find({})
      .sort({ hire_date: 1 })
      .project({ first_name: 1, last_name: 1, hire_date: 1, salary: 1 })
      .toArray();
    byHireDate.forEach(e => {
      const date = e.hire_date.toISOString().split('T')[0];
      console.log(`  ${e.first_name} ${e.last_name} — anställd: ${date} — ${e.salary} kr`);
    });

  } catch (err) {
    console.error('MongoDB-fel:', err.message);
  } finally {
    await client.close();
  }
}

runDemo();
