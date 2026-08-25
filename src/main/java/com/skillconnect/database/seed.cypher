MATCH (n)
DETACH DELETE n;

// =========================
// SKILLS
// =========================

CREATE
(:Skill {name:'Java'}),
(:Skill {name:'Spring Boot'}),
(:Skill {name:'SQL'}),
(:Skill {name:'Python'}),
(:Skill {name:'JavaScript'}),
(:Skill {name:'React'}),
(:Skill {name:'Docker'}),
(:Skill {name:'AWS'});

// =========================
// DEVELOPERS
// =========================

CREATE
(:Developer {id:1, name:'Rahul'}),
(:Developer {id:2, name:'Priya'}),
(:Developer {id:3, name:'Kiran'}),
(:Developer {id:4, name:'Sneha'});

// =========================
// PROJECTS
// =========================

CREATE
(:Project {id:1, name:'Banking Platform'}),
(:Project {id:2, name:'E-Commerce Portal'}),
(:Project {id:3, name:'Cloud Analytics'}),
(:Project {id:4, name:'Healthcare App'});

// =========================
// TECHNOLOGIES
// =========================

CREATE
(:Technology {name:'Spring'}),
(:Technology {name:'React'}),
(:Technology {name:'Docker'}),
(:Technology {name:'AWS'}),
(:Technology {name:'Python'}),
(:Technology {name:'PostgreSQL'});

// =========================
// COMPANIES
// =========================

CREATE
(:Company {id:1, name:'ABC Technologies'}),
(:Company {id:2, name:'TechNova'}),
(:Company {id:3, name:'CloudWorks'});

// =========================
// JOBS
// =========================

CREATE
(:Job {
    id:101,
    title:'Java Backend Developer',
    company:'ABC Technologies'
}),
(:Job {
    id:102,
    title:'Full Stack Developer',
    company:'TechNova'
}),
(:Job {
    id:103,
    title:'Cloud Java Engineer',
    company:'CloudWorks'
});

// =========================
// DEVELOPER -> SKILL
// =========================

MATCH
(r:Developer {name:'Rahul'}),
(p:Developer {name:'Priya'}),
(k:Developer {name:'Kiran'}),
(s:Developer {name:'Sneha'}),

(java:Skill {name:'Java'}),
(springBoot:Skill {name:'Spring Boot'}),
(sql:Skill {name:'SQL'}),
(python:Skill {name:'Python'}),
(javascript:Skill {name:'JavaScript'}),
(react:Skill {name:'React'}),
(docker:Skill {name:'Docker'}),
(aws:Skill {name:'AWS'})

CREATE
(r)-[:HAS_SKILL]->(java),
(r)-[:HAS_SKILL]->(springBoot),
(r)-[:HAS_SKILL]->(sql),

(p)-[:HAS_SKILL]->(java),
(p)-[:HAS_SKILL]->(javascript),
(p)-[:HAS_SKILL]->(react),

(k)-[:HAS_SKILL]->(python),
(k)-[:HAS_SKILL]->(sql),
(k)-[:HAS_SKILL]->(aws),

(s)-[:HAS_SKILL]->(java),
(s)-[:HAS_SKILL]->(springBoot),
(s)-[:HAS_SKILL]->(docker),
(s)-[:HAS_SKILL]->(aws);

// =========================
// PROJECT -> TECHNOLOGY
// =========================

MATCH
(bank:Project {name:'Banking Platform'}),
(ecom:Project {name:'E-Commerce Portal'}),
(cloud:Project {name:'Cloud Analytics'}),
(health:Project {name:'Healthcare App'}),

(spring:Technology {name:'Spring'}),
(reactTech:Technology {name:'React'}),
(dockerTech:Technology {name:'Docker'}),
(awsTech:Technology {name:'AWS'}),
(pythonTech:Technology {name:'Python'}),
(postgres:Technology {name:'PostgreSQL'})

CREATE
(bank)-[:USES]->(spring),
(bank)-[:USES]->(postgres),

(ecom)-[:USES]->(spring),
(ecom)-[:USES]->(reactTech),

(cloud)-[:USES]->(pythonTech),
(cloud)-[:USES]->(awsTech),

(health)-[:USES]->(spring),
(health)-[:USES]->(dockerTech),
(health)-[:USES]->(awsTech);

// =========================
// DEVELOPER -> PROJECT
// =========================

MATCH
(r:Developer {name:'Rahul'}),
(p:Developer {name:'Priya'}),
(k:Developer {name:'Kiran'}),
(s:Developer {name:'Sneha'}),

(bank:Project {name:'Banking Platform'}),
(ecom:Project {name:'E-Commerce Portal'}),
(cloud:Project {name:'Cloud Analytics'}),
(health:Project {name:'Healthcare App'})

CREATE
(r)-[:WORKED_ON]->(bank),
(r)-[:WORKED_ON]->(health),

(p)-[:WORKED_ON]->(ecom),
(p)-[:WORKED_ON]->(bank),

(k)-[:WORKED_ON]->(cloud),
(k)-[:WORKED_ON]->(health),

(s)-[:WORKED_ON]->(health),
(s)-[:WORKED_ON]->(bank);

// =========================
// PROJECT -> COMPANY
// =========================

MATCH
(bank:Project {name:'Banking Platform'}),
(ecom:Project {name:'E-Commerce Portal'}),
(cloud:Project {name:'Cloud Analytics'}),
(health:Project {name:'Healthcare App'}),

(abc:Company {name:'ABC Technologies'}),
(techNova:Company {name:'TechNova'}),
(cloudWorks:Company {name:'CloudWorks'})

CREATE
(bank)-[:FOR_COMPANY]->(abc),
(ecom)-[:FOR_COMPANY]->(techNova),
(cloud)-[:FOR_COMPANY]->(cloudWorks),
(health)-[:FOR_COMPANY]->(abc);

// =========================
// COMPANY -> JOB
// =========================

MATCH
(abc:Company {name:'ABC Technologies'}),
(techNova:Company {name:'TechNova'}),
(cloudWorks:Company {name:'CloudWorks'}),

(job1:Job {id:101}),
(job2:Job {id:102}),
(job3:Job {id:103})

CREATE
(abc)-[:POSTS]->(job1),
(techNova)-[:POSTS]->(job2),
(cloudWorks)-[:POSTS]->(job3);

// =========================
// JOB -> REQUIRED SKILLS
// =========================

MATCH
(job1:Job {id:101}),
(job2:Job {id:102}),
(job3:Job {id:103}),

(java:Skill {name:'Java'}),
(springBoot:Skill {name:'Spring Boot'}),
(sql:Skill {name:'SQL'}),
(javascript:Skill {name:'JavaScript'}),
(react:Skill {name:'React'}),
(docker:Skill {name:'Docker'}),
(aws:Skill {name:'AWS'})

CREATE
(job1)-[:REQUIRES]->(java),
(job1)-[:REQUIRES]->(springBoot),
(job1)-[:REQUIRES]->(sql),

(job2)-[:REQUIRES]->(javascript),
(job2)-[:REQUIRES]->(react),
(job2)-[:REQUIRES]->(sql),

(job3)-[:REQUIRES]->(java),
(job3)-[:REQUIRES]->(docker),
(job3)-[:REQUIRES]->(aws);

// =========================
// RELATED SKILLS
// =========================

MATCH
(java:Skill {name:'Java'}),
(springBoot:Skill {name:'Spring Boot'}),
(sql:Skill {name:'SQL'}),
(python:Skill {name:'Python'}),
(javascript:Skill {name:'JavaScript'}),
(react:Skill {name:'React'}),
(docker:Skill {name:'Docker'}),
(aws:Skill {name:'AWS'})

CREATE
(java)-[:RELATED_TO]->(springBoot),
(springBoot)-[:RELATED_TO]->(java),

(java)-[:RELATED_TO]->(sql),
(sql)-[:RELATED_TO]->(java),

(javascript)-[:RELATED_TO]->(react),
(react)-[:RELATED_TO]->(javascript),

(docker)-[:RELATED_TO]->(aws),
(aws)-[:RELATED_TO]->(docker),

(python)-[:RELATED_TO]->(sql),
(sql)-[:RELATED_TO]->(python);