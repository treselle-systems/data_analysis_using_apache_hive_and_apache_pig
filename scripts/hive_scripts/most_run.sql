-- Drop the table if already exists
DROP TABLE IF EXISTS ipl_stats.most_run ;

-- Creating table
CREATE TABLE ipl_stats.most_run (
batsman string,
season string,
innings bigint,
not_out bigint,
run bigint,
average double,
strike_rate double,
four_runs bigint,
six_runs bigint
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE ;