DROP TABLE IF EXISTS data_science_job;

CREATE TABLE data_science_job (
    enrollee_id SERIAL PRIMARY KEY,
    city TEXT NOT NULL,
    city_development_index FLOAT,
    gender VARCHAR(10),
    relevent_experience VARCHAR(30) NOT NULL,
    enrolled_university VARCHAR(50),
    education_level VARCHAR(20),
    major_discipline VARCHAR(50),
    experience FLOAT,
    company_size VARCHAR(20),
    company_type VARCHAR(50),
    training_hours FLOAT,
    target SMALLINT CHECK (target IN (0,1))
);

ALTER TABLE data_science_job 
ALTER COLUMN target TYPE NUMERIC(10,2); -- ou FLOAT

SELECT * FROM data_science_job 

SHOW data_directory;


COPY data_science_job FROM 'C:\Program Files\PostgreSQL\16\data\data_science_job.csv' DELIMITER ',' 
CSV HEADER;

/*OBERSERVAÇÃO MUITO IMPORTANTE QUE EU DEMOREI UM DIA PRA DESCOBRIR:

Para importar um arquivo CSV para o PostgreSQL, é preciso mandar o arquivo pra pasta:
C:\Program Files\PostgreSQL\16\data

FINALMENTE CONSEGUI!
*/