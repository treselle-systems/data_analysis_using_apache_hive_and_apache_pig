-- Dropping Database
DROP DATABASE IF EXISTS ipl_data CASCADE;
DROP DATABASE IF EXISTS ipl_stats CASCADE;

-- Creating a Database
CREATE DATABASE ipl_data ;  -- Database for Loading CSV Input File  
CREATE DATABASE ipl_stats ; -- Database for Loading stats tables

-- Creating two tables to load input files ( matches and deliveries )
CREATE TABLE ipl_data.matches(
  `id` int,
  `season` int,
  `city` string,
  `date` date,
  `team1` string,
  `team2` string,
  `toss_winner` string,
  `toss_decision` string,
  `result` string,
  `dl_applied` int,
  `winner` string,
  `win_by_runs` int,
  `win_by_wickets` int,
  `player_of_match` string,
  `venue` string,
  `umpire1` string,
  `umpire2` string,
  `umpire3` string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = "\""
)
STORED AS TEXTFILE 
TBLPROPERTIES (
    'serialization.null.format' = '',  
    'skip.header.line.count' = '1');


CREATE TABLE ipl_data.deliveries(
  `match_id` int,
  `inning` int,
  `batting_team` string,
  `bowling_team` string,
  `over` int,
  `ball` int,
  `batsman` string,
  `non_striker` string,
  `bowler` string,
  `is_super_over` int,
  `wide_runs` int,
  `bye_runs` int,
  `legbye_runs` int,
  `noball_runs` int,
  `penalty_runs` int,
  `batsman_runs` int,
  `extra_runs` int,
  `total_runs` int,
  `player_dismissed` string,
  `dismissal_kind` string,
  `fielder` string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = "\""
)
STORED AS TEXTFILE 
TBLPROPERTIES (
    'serialization.null.format' = '',  
    'skip.header.line.count' = '1');

-- Creating a table to load Actual data into Compressed file Format(ORC) table.
CREATE TABLE ipl_stats.matches(
  `id` int,
  `season` int,
  `city` string,
  `date` date,
  `team1` string,
  `team2` string,
  `toss_winner` string,
  `toss_decision` string,
  `result` string,
  `dl_applied` int,
  `winner` string,
  `win_by_runs` int,
  `win_by_wickets` int,
  `player_of_match` string,
  `venue` string,
  `umpire1` string,
  `umpire2` string,
  `umpire3` string)
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY ','
STORED AS ORC ; 

CREATE TABLE ipl_stats.deliveries(
  `match_id` int,
  `inning` int,
  `batting_team` string,
  `bowling_team` string,
  `over` int,
  `ball` int,
  `batsman` string,
  `non_striker` string,
  `bowler` string,
  `is_super_over` int,
  `wide_runs` int,
  `bye_runs` int,
  `legbye_runs` int,
  `noball_runs` int,
  `penalty_runs` int,
  `batsman_runs` int,
  `extra_runs` int,
  `total_runs` int,
  `player_dismissed` string,
  `dismissal_kind` string,
  `fielder` string)
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY ','
STORED AS ORC ; 
	

	