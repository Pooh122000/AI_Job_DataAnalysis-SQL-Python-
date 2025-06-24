Use ai_jobs;
Select * from ai_job_dataset;

-- QUERY 1: Basic salary statistics
-- Purpose: Get overall salary information
SELECT COUNT(*) as total_jobs, 
       AVG(salary_usd) as average_salary, 
       MIN(salary_usd) as minimum_salary, 
       MAX(salary_usd) as maximum_salary
FROM ai_job_dataset 
WHERE salary_usd IS NOT NULL;

-- What this shows: Overall job market statistics
-- Why useful: Gives context for individual salaries

-- QUERY 2: Salary by experience level
-- Purpose: Compare pay across different experience levels
SELECT 
    experience_level,
    COUNT(*) as job_count,
    AVG(salary_usd) as avg_salary,
    MIN(salary_usd) as min_salary,
    MAX(salary_usd) as max_salary
FROM ai_job_dataset
WHERE salary_usd IS NOT NULL 
  AND experience_level IS NOT NULL
GROUP BY experience_level
ORDER BY avg_salary DESC;

-- What this shows: How experience affects salary
-- Why useful: Helps job seekers understand career progression

-- QUERY 3: Remote work analysis
-- Purpose: Understand remote work trends
SELECT 
    CASE 
        WHEN remote_ratio = 0 THEN 'On-site'
        WHEN remote_ratio = 100 THEN 'Fully Remote'
        ELSE 'Hybrid'
    END as work_type,
    COUNT(*) as job_count,
    AVG(salary_usd) as avg_salary,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ai_job_dataset), 2) as percentage
FROM ai_job_dataset
WHERE remote_ratio IS NOT NULL
GROUP BY 
    CASE 
        WHEN remote_ratio = 0 THEN 'On-site'
        WHEN remote_ratio = 100 THEN 'Fully Remote'
        ELSE 'Hybrid'
    END
ORDER BY job_count DESC;

-- What this shows: Remote work distribution and pay impact
-- Why useful: Shows if remote work affects salary

-- QUERY 4: Top paying locations
-- Purpose: Find best locations for AI jobs
SELECT 
    company_location,
    COUNT(*) as job_count,
    AVG(salary_usd) as avg_salary,
    MIN(salary_usd) as min_salary,
    MAX(salary_usd) as max_salary
FROM ai_job_dataset
WHERE salary_usd IS NOT NULL 
  AND company_location IS NOT NULL
GROUP BY company_location
HAVING COUNT(*) >= 5  -- Only locations with at least 5 jobs
ORDER BY avg_salary DESC
LIMIT 10;

-- What this shows: Which locations pay the most
-- Why useful: Helps with job search and relocation decisions

-- QUERY 5: Skills analysis (if skills are in separate table)
-- Purpose: Find most valuable skills
-- Note: This assumes skills are split into separate rows
SELECT 
    aj.required_skills,
    COUNT(*) as frequency,
    AVG(aj.salary_usd) as avg_salary_for_skill
FROM ai_job_dataset aj
JOIN ai_job_dataset js ON aj.job_id = js.job_id
WHERE aj.salary_usd IS NOT NULL
GROUP BY aj.required_skills
HAVING COUNT(*) >= 10  -- Skills mentioned in at least 10 jobs
ORDER BY avg_salary_for_skill DESC
LIMIT 15;

-- What this shows: Which skills pay the most
-- Why useful: Guides learning and skill development

-- QUERY 6: Company size impact
-- Purpose: See how company size affects salary and remote work
SELECT 
    company_size,
    COUNT(*) as job_count,
    AVG(salary_usd) as avg_salary,
    AVG(remote_ratio) as avg_remote_ratio,
    COUNT(CASE WHEN remote_ratio = 100 THEN 1 END) as fully_remote_count
FROM ai_job_dataset
WHERE company_size IS NOT NULL
GROUP BY company_size
ORDER BY avg_salary DESC;

-- What this shows: How company size affects pay and remote work
-- Why useful: Helps choose between startup vs large company

-- QUERY 7: Trending over time
-- Purpose: See how the job market is changing
SELECT 
    YEAR(posting_date) as posting_year,
    MONTH(posting_date) as posting_month,
    COUNT(*) as jobs_posted,
    AVG(salary_usd) as avg_salary,
    AVG(remote_ratio) as avg_remote_ratio
FROM ai_job_dataset
WHERE posting_date >= '2022-01-01'  -- Last few years
GROUP BY YEAR(posting_date), MONTH(posting_date)
ORDER BY posting_year, posting_month;

-- What this shows: Job market trends over time
-- Why useful: Shows if market is growing and salary trends

-- QUERY 8: Education requirements vs salary
-- Purpose: See if education affects pay
SELECT 
    education_required,
    COUNT(*) as job_count,
    AVG(salary_usd) as avg_salary,
    AVG(years_experience) as avg_experience_required
FROM ai_job_dataset
WHERE education_required IS NOT NULL
  AND salary_usd IS NOT NULL
GROUP BY education_required
ORDER BY avg_salary DESC;

-- What this shows: How education level affects salary
-- Why useful: Helps understand if advanced degrees are worth it