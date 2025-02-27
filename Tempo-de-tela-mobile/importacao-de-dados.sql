CREATE TABLE screentime_analysis (
	Date CHAR(10),
	App VARCHAR(20),
	Usage_minutes SMALLINT,
	Notifications SMALLINT,
	Times_Opened SMALLINT
)

SELECT * FROM screentime_analysis

COPY screentime_analysis 
FROM 'C:\Program Files\PostgreSQL\16\data\screentime_analysis.csv' 
DELIMITER ',' 
CSV HEADER;