/* Below Command loading data from hive table into pig_input_table */

pig_input_table_match = LOAD 'ipl_stats.matches' using org.apache.hive.hcatalog.pig.HCatLoader();
pig_input_table_deliveries = LOAD 'ipl_stats.deliveries' using org.apache.hive.hcatalog.pig.HCatLoader();


/* Here we doing data formating  and Joing Multiple tables */

mths = FOREACH pig_input_table_match GENERATE id AS id,(chararray)season ;
deliveries = FOREACH pig_input_table_deliveries GENERATE batsman,match_id,batsman_runs,(wide_runs>0?0:1) AS ballsfaced,(batsman_runs==4?1:0) AS four_runs,(batsman_runs==6?1:0) AS six_runs,player_dismissed ;
join_table = JOIN deliveries BY (match_id),mths BY (id);


/* Here we Calculating  run ,strikerate  ,4's and 6's for each batsman on each season and overall   */

run_calculation = FOREACH join_table GENERATE match_id,batsman,batsman_runs,ballsfaced,four_runs,six_runs,season ; -- to calculate run,strikerate ,4's and 6's

-- Here we doing GROUP BY and Aggregate Function for Each Season
run_groupby_season = GROUP run_calculation BY (batsman, season) ;
run_season   = FOREACH run_groupby_season { 
						  uniq_matches = DISTINCT run_calculation.match_id ;
                                            GENERATE FLATTEN(group) AS (batsman, season),COUNT(uniq_matches)AS innings,SUM(run_calculation.batsman_runs)AS run,ROUND_TO(((double)SUM(run_calculation.batsman_runs) / SUM(run_calculation.ballsfaced) )*100,2) AS strike_rate,SUM(run_calculation.four_runs) AS four_runs,SUM(run_calculation.six_runs) AS six_runs ;
                                          };

-- Here we doing GROUP BY and Aggregate Function for Overall Season
run_groupby_all = GROUP run_calculation BY batsman ;
run_all   = FOREACH run_groupby_all {
					   uniq_matches = DISTINCT run_calculation.match_id ;
					   GENERATE group AS batsman,'ALL' AS season,COUNT(uniq_matches)AS innings,SUM(run_calculation.batsman_runs)AS run,ROUND_TO(((double)SUM(run_calculation.batsman_runs) / SUM(run_calculation.ballsfaced) )*100,2) AS strike_rate,SUM(run_calculation.four_runs) AS four_runs,SUM(run_calculation.six_runs) AS six_runs ; 
                                    };
batsman_run = union run_season,run_all;


/* Here we Calculating  noofdismissal and average for each batsman on each season and overall   */
dismissal_filter = FILTER join_table BY (player_dismissed is NOT NULL) ;
out_calculation = FOREACH dismissal_filter GENERATE match_id,season,player_dismissed ; -- to calculate noofdismmisal and Average

-- Here we doing GROUP BY and Aggregate Function Each Season
out_groupby_season = GROUP out_calculation BY (player_dismissed, season) ;
out_season = FOREACH out_groupby_season GENERATE FLATTEN(group) AS (player_dismissed, season),COUNT(out_calculation.player_dismissed)AS noofdismissal;

-- Here we doing GROUP BY and Aggregate Function for Overall Season
out_groupby_all = GROUP out_calculation BY (player_dismissed) ;
out_all = FOREACH out_groupby_all GENERATE FLATTEN(group) AS (player_dismissed),'ALL' AS season, COUNT(out_calculation.player_dismissed)AS noofdismissal;
batsman_out = union out_season,out_all;


/* Loading final result into Hive Table */

most_run_join = JOIN batsman_run by (batsman, season) LEFT OUTER , batsman_out by (player_dismissed, season) ;
most_run = FOREACH most_run_join GENERATE batsman_run::batsman AS batsman ,batsman_run::season AS season,batsman_run::innings AS innings ,((batsman_run::innings)-(batsman_out::noofdismissal)) AS not_out ,batsman_run::run AS run  ,ROUND_TO(((double)(batsman_run::run)/(batsman_out::noofdismissal)),2)AS average ,batsman_run::strike_rate AS strike_rate ,batsman_run::four_runs AS four_runs ,batsman_run::six_runs AS six_runs ;

STORE most_run INTO 'ipl_stats.most_run' USING org.apache.hive.hcatalog.pig.HCatStorer();
