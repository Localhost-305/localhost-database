-- select * from dim_candidates;
-- select * from dim_jobs;
-- select * from dim_recruiters;
-- select * from dim_recruitment_processes;
-- select * from fact_applications;
-- select * from fact_hirings;
-- select * from users;

-- 1º número de candidatos por vagas com opção de filtrar por data início e data fim;
SELECT 
    j.job_title,  -- Seleciona o título da vaga da tabela de dimensões de vagas
    COUNT(a.candidate_id) AS numero_de_candidatos  -- Conta o número de candidatos para cada vaga e renomeia a coluna para "numero_de_candidatos"
FROM 
    fact_applications a  -- Tabela de fatos com informações sobre candidaturas
INNER JOIN dim_jobs j ON a.job_id = j.job_id  -- Junta com a tabela de dimensões de vagas para obter o título da vaga
INNER JOIN dim_date d ON a.date_id = d.date_id  -- Junta com a tabela de dimensões de datas para obter a data da candidatura
WHERE
    STR_TO_DATE(CONCAT(d.year, '-', d.month, '-', d.day), '%Y-%m-%d') BETWEEN j.opening_date AND j.closing_date  -- Filtra candidaturas com datas dentro do intervalo da vaga
GROUP BY 
    j.job_title;  -- Agrupa os resultados pelo título da vaga

-- 2º tempo médio de contratação, com opção de receber data início e data fim para filtrar;
-- Seleciona a média arredondada do tempo de contratação em dias
SELECT 
    ROUND(AVG(DATEDIFF(j.closing_date, j.opening_date))) AS tempo_medio_contratacao_dias
    -- Calcula a diferença entre a data de fechamento e a data de abertura de cada vaga (DATEDIFF).
    -- Em seguida, calcula a média (AVG) dessa diferença em dias.
    -- O resultado é arredondado (ROUND) para o número inteiro mais próximo.
    -- O alias 'tempo_medio_contratacao_dias' define o nome da coluna de resultado.

FROM 
    dim_jobs j
    -- Tabela 'dim_jobs' (j) contém os dados das vagas (datas de abertura e fechamento).

WHERE 
    j.opening_date BETWEEN '2024-01-01' AND '2024-12-31';
    -- Filtra os resultados para considerar apenas as vagas abertas entre 1º de janeiro e 31 de dezembro de 2024.

-- 3º tempo médio de contratação por vaga e o tempo médio total, com opção de filtrar por data início e data fim;
SELECT 
    j.job_title,  -- Agrupa por título da vaga
    ROUND(AVG(DATEDIFF(j.closing_date, j.opening_date))) AS tempo_medio_contratacao_por_vaga_dias  -- Tempo médio de contratação por vaga
FROM 
    dim_jobs j
WHERE 
    j.opening_date BETWEEN '2024-01-01' AND '2024-12-31'  -- Filtra as vagas pelo intervalo de datas desejado
GROUP BY 
    j.job_title;  -- Agrupa por título da vaga

-- 4º Realizar uma query que traga os dados referente a taxa de retenção de novos funcionários.  
SELECT
    -- Calcula a média arredondada da diferença entre a data de encerramento do contrato e a data de contratação
    ROUND(AVG(DATEDIFF(contract_end_date, hiring_date))) AS retention_days
FROM 
    fact_hirings
JOIN 
    dim_jobs ON fact_hirings.job_id = dim_jobs.job_id
WHERE 
    -- Garante que apenas registros com data de encerramento do contrato (não nulos) sejam considerados
    contract_end_date IS NOT NULL
    -- Filtra os registros onde a data de encerramento do contrato está no intervalo de 01/01/2024 a 31/12/2024
    AND contract_end_date BETWEEN '2024-01-01' AND '2024-12-31'
    -- Filtra pelo cargo específico
    AND dim_jobs.job_title = 'Cytogeneticist';

-- Média de retenção por vaga
SELECT 
    job_title,
    ROUND(AVG(DATEDIFF(contract_end_date, hiring_date))) AS retention_days
FROM
    fact_hirings
        JOIN
    dim_jobs ON fact_hirings.job_id = dim_jobs.job_id
WHERE
    contract_end_date IS NOT NULL
    AND contract_end_date BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY 
	job_title;