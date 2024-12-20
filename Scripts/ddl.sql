-- drop section
DROP SCHEMA IF EXISTS localhost305;
DROP USER IF EXISTS 'api'@'localhost';


-- create section
CREATE USER 'api'@'localhost' IDENTIFIED BY 'Root_1234';
GRANT ALL PRIVILEGES ON localhost305.* TO 'api'@'localhost';

FLUSH PRIVILEGES;

use localhost305;

-- create sction
CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_on DATE NOT NULL,
    updated_on DATE NOT NULL
);

CREATE TABLE dim_candidates (
    candidate_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    candidate_name VARCHAR(200) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(12)  NOT NULL,
    birth_date DATE NOT NULL
);

CREATE TABLE dim_jobs (
    job_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    job_title VARCHAR(200) NOT NULL,
    number_of_positions INT NOT NULL,
    job_requirements VARCHAR(500) NOT NULL,
    job_status VARCHAR(20) NOT NULL,
    location VARCHAR(300) NOT NULL,
    responsible_person VARCHAR(200) NOT NULL,
    opening_date DATETIME NOT NULL,
    closing_date DATETIME NOT NULL
);

CREATE TABLE dim_recruitment_processes (
    process_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    process_name VARCHAR(200) NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    process_status VARCHAR(20) NOT NULL,
    process_description VARCHAR(500) NOT NULL
);

CREATE TABLE dim_recruiters (
    recruiter_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    recruiter_name VARCHAR(200) NOT NULL,
    role VARCHAR(50) NOT NULL,
    feedbacks_given INT NOT NULL
);

CREATE TABLE dim_date (
    date_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    day INT NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL
);

CREATE TABLE dim_hour (
    hour_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    hour INT NOT NULL
);

CREATE TABLE fact_applications (
    recruiter_id BIGINT,
    candidate_id BIGINT,
    job_id BIGINT,
    process_id BIGINT,
    date_id BIGINT,
    hour_id BIGINT,
    number_of_applications INT NOT NULL,
    PRIMARY KEY (recruiter_id, candidate_id, job_id, process_id, date_id, hour_id),
    FOREIGN KEY (candidate_id) REFERENCES dim_candidates(candidate_id),
    FOREIGN KEY (job_id) REFERENCES dim_jobs(job_id),
    FOREIGN KEY (process_id) REFERENCES dim_recruitment_processes(process_id),
    FOREIGN KEY (recruiter_id) REFERENCES dim_recruiters(recruiter_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (hour_id) REFERENCES dim_hour(hour_id)
);

CREATE TABLE fact_hirings (
    hiring_id BIGINT AUTO_INCREMENT,
    candidate_id BIGINT,
    job_id BIGINT,
    date_id BIGINT NOT NULL,
    hour_id BIGINT NOT NULL,
    hiring_date DATE NOT NULL,
    initial_salary DECIMAL(8,2) NOT NULL,
    contract_type VARCHAR(50) NOT NULL,
    acceptance_date DATETIME NOT NULL,
    qty_hirings INT NOT NULL,
    PRIMARY KEY (hiring_id, candidate_id, job_id, date_id, hour_id),
    FOREIGN KEY (candidate_id) REFERENCES dim_candidates(candidate_id),
    FOREIGN KEY (job_id) REFERENCES dim_jobs(job_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (hour_id) REFERENCES dim_hour(hour_id)
);

alter table fact_hirings
add contract_end_date date;

INSERT INTO dim_candidates (candidate_id, candidate_name, email, phone, birth_date) 
VALUES
(1, 'Ana Silva', 'ana.silva@email.com', '11987654321', '1990-05-12'),
(2, 'Carlos Pereira', 'carlos.pereira@email.com', '11987654322', '1985-08-23'),
(3, 'Maria Oliveira', 'maria.oliveira@email.com', '11987654323', '1992-11-30'),
(4, 'José Santos', 'jose.santos@email.com', '11987654324', '1988-02-15');

INSERT INTO dim_jobs (job_id, job_title, number_of_positions, job_requirements, job_status, location, responsible_person, opening_date, closing_date) 
VALUES
(1, 'Desenvolvedor', 3, 'Conhecimento em Java, SQL', 'Aberta', 'São Paulo - SP', 'Ricardo Lima', '2024-01-15 09:00:00', '2024-02-15 18:00:00'),
(2, 'Analista de Marketing', 2, 'Experiência com SEO, Google Ads', 'Aberta', 'Rio de Janeiro - RJ', 'Juliana Costa', '2024-02-01 09:00:00', '2024-03-01 18:00:00'),
(3, 'Designer Gráfico', 1, 'Portfólio com projetos criativos', 'Fechada', 'Curitiba - PR', 'Pedro Almeida', '2023-11-01 09:00:00', '2023-12-01 18:00:00');

INSERT INTO dim_recruitment_processes (process_id, process_name, start_date, end_date, process_status, process_description) 
VALUES
(1, 'Processo Seletivo 2024 - Desenvolvimento', '2024-01-16 09:00:00', '2024-02-15 18:00:00', 'Em Andamento', 'Seleção de candidatos para vagas de desenvolvedor.'),
(2, 'Processo Seletivo 2024 - Marketing', '2024-02-02 09:00:00', '2024-03-01 18:00:00', 'Em Andamento', 'Seleção para vagas na área de marketing.'),
(3, 'Processo Seletivo 2023 - Design', '2023-11-02 09:00:00', '2023-12-01 18:00:00', 'Finalizado', 'Seleção para designer gráfico.'),
(4, 'Processo Seletivo 2024 - TI', '2024-03-01 09:00:00', '2024-04-01 18:00:00', 'Agendado', 'Seleção para novas vagas na área de TI.');

INSERT INTO dim_recruiters (recruiter_id, recruiter_name, role, feedbacks_given) 
VALUES
(1, 'Ricardo Lima', 'Gerente de RH', 15),
(2, 'Juliana Costa', 'Coordenadora de RH', 8),
(3, 'Pedro Almeida', 'Especialista em Recrutamento', 10);

INSERT INTO dim_date (date_id, day, month, year)
VALUES
  (1, 1, 1, 2024),
  (2, 2, 1, 2024),
  (3, 3, 1, 2024);

INSERT INTO dim_hour (hour_id, hour)
VALUES
  (1, 0),
  (2, 1),
  (3, 2);

INSERT INTO fact_applications (recruiter_id, candidate_id, job_id, date_id, hour_id, process_id, number_of_applications) 
VALUES
(1, 1, 1, 1, 1, 1, 1),
(1, 2, 1, 1, 2, 1, 1),
(2, 3, 2, 2, 1, 2, 1),
(3, 4, 3, 3, 1, 3, 1);

INSERT INTO fact_hirings (hiring_id, candidate_id, job_id, date_id, hour_id, hiring_date, initial_salary, contract_type, acceptance_date, qty_hirings) 
VALUES
(1, 1, 1, 1, 1, '2024-02-16', 15000.00, 'CLT', '2024-02-10 12:00:00', 1),
(2, 2, 1, 1, 2, '2024-02-20', 14000.00, 'CLT', '2024-02-18 15:00:00', 1),
(3, 3, 2, 2, 1, '2024-03-02', 12000.00, 'PJ', '2024-02-25 10:00:00', 1);

INSERT INTO users (email, name, password, created_on, updated_on) 
VALUES 
('api@email.com', 'api', '$2a$12$qQHqq5cdoWedWUi25cDtjupMlxRWwKO74HkhbCzZctouolZpeyTV.', '2024-09-13', '2024-09-13');

-- Criando a tabela de roles
CREATE TABLE dim_roles (
    role_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(255) NOT NULL UNIQUE
);

-- Criando a tabela de permissões
CREATE TABLE dim_permissions (
    permission_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    permission_name VARCHAR(255) NOT NULL UNIQUE
);

-- Criando uma tabela para conectar as permissões na role criada
CREATE TABLE fact_roles_permissions (
    role_id BIGINT NOT NULL,
    permission_id BIGINT NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES dim_roles(role_id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES dim_permissions(permission_id) ON DELETE CASCADE
);

-- Realizando um insert das roles na tabela de roles
insert into dim_roles (role_name) VALUES ('ADMIN'),('SUPERVISOR'),('USER');

-- Realizando um insert das permissões na tabela de permissões
INSERT INTO dim_permissions (permission_name) VALUES
('allowed_to_see'),
('allowed_to_change'),
('allowed_to_import'),
('allowed_to_add_role'),
('allowed_to_see_money');

-- Realizando um insert na tabela de vinculação entre as tabelas roles e permissions para atribuir todas as permissões na ADMIN
INSERT INTO fact_roles_permissions (role_id, permission_id) VALUES
(1, (SELECT permission_id FROM dim_permissions WHERE permission_name = 'allowed_to_see')),
(1, (SELECT permission_id FROM dim_permissions WHERE permission_name = 'allowed_to_change')),
(1, (SELECT permission_id FROM dim_permissions WHERE permission_name = 'allowed_to_import')),
(1, (SELECT permission_id FROM dim_permissions WHERE permission_name = 'allowed_to_add_role')),
(1, (SELECT permission_id FROM dim_permissions WHERE permission_name = 'allowed_to_see_money'));

-- Realizando um insert na tabela de vinculação entre as tabelas roles e permissions para atribuir todas as permissões na SUPERVISOR
INSERT INTO fact_roles_permissions (role_id, permission_id) VALUES
(2, (SELECT permission_id FROM dim_permissions WHERE permission_name = 'allowed_to_see')),
(2, (SELECT permission_id FROM dim_permissions WHERE permission_name = 'allowed_to_import')),
(2, (SELECT permission_id FROM dim_permissions WHERE permission_name = 'allowed_to_see_money'));

-- Realizando um insert na tabela de vinculação entre as tabelas roles e permissions para atribuir todas as permissões na SUPERVISOR
INSERT INTO fact_roles_permissions (role_id, permission_id) VALUES
(3, (SELECT permission_id FROM dim_permissions WHERE permission_name = 'allowed_to_see')),
(3, (SELECT permission_id FROM dim_permissions WHERE permission_name = 'allowed_to_import'));

RENAME TABLE users TO dim_users;
ALTER TABLE dim_users ADD COLUMN role_id BIGINT;
ALTER TABLE dim_users ADD CONSTRAINT fk_user_role FOREIGN KEY (role_id) REFERENCES dim_roles(role_id);

UPDATE dim_users SET role_id = 1 WHERE user_id = 1;
