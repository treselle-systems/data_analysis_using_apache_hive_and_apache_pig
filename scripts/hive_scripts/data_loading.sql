-- Loading Input CSV File into ipl_data Database
LOAD DATA LOCAL INPATH 
'/home/hduser/usecase/ipl_stats/input_file/matches.csv' 
INTO TABLE ipl_data.matches;

LOAD DATA LOCAL INPATH 
'/home/hduser/usecase/ipl_stats/input_file/deliveries.csv' 
INTO TABLE ipl_data.deliveries;


-- Here we loading data to orc format table from text format table 
INSERT OVERWRITE TABLE ipl_stats.matches 
SELECT * FROM ipl_data.matches ;

INSERT OVERWRITE TABLE ipl_stats.deliveries 
SELECT * FROM ipl_data.deliveries ;
