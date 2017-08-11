/* -------------------------- Sample Query --------------------------------------------- */

SELECT * FROM ipl_stats.matches ;

SELECT * FROM ipl_stats.deliveries ;

SELECT 
  a.batsman,
  collect(a.season,a.run)AS pivot_column
FROM ipl_stats.most_run a JOIN
  (SELECT batsman,run,rank() over (order by run desc) as rank 
   FROM ipl_stats.most_run WHERE season ='ALL') b ON b.batsman=a.batsman 
WHERE rank <=5 GROUP BY a.batsman,b.rank ;

SELECT 
  season  AS SEASON, 
  winner AS WINNER, 
  IF(win_by_runs='0',CONCAT('Won by ',win_by_wickets,' Wickets'),
  CONCAT('Won by ',win_by_runs,' Runs')) AS `WINNING MARGIN`,
  IF(winner=team1,team2,team1) AS RUNNER,
  player_of_match
FROM 
  ipl_stats.matches 
WHERE 
  id IN(SELECT MAX(id) FROM ipl_stats.matches GROUP BY season) ;

SELECT * FROM ipl_stats.most_run WHERE batsman = 'RG Sharma' ;


/* --------------------------- Pivot Query --------------------------------------------- */

SELECT 
  a.batsman,
  a.season,
  a.run
FROM ipl_stats.most_run a JOIN
  (SELECT batsman,run,rank() over (order by run desc) as rank 
    FROM ipl_stats.most_run WHERE season ='ALL') b ON b.batsman=a.batsman 
WHERE rank <=5 ;


add jar /home/hduser/usecase/ipl_stats/input_file/brickhouse-0.6.0.jar ;
CREATE TEMPORARY FUNCTION collect AS 'brickhouse.udf.collect.CollectUDAF';

SELECT 
  a.batsman,
  collect(a.season,a.run)AS pivot_column
FROM ipl_stats.most_run a JOIN
  (SELECT batsman,run,rank() over (order by run desc) as rank 
   FROM ipl_stats.most_run WHERE season ='ALL') b ON b.batsman=a.batsman 
WHERE rank <=5 GROUP BY a.batsman,b.rank ;



/* --------------------------- Chart Query --------------------------------------------- */

SELECT 
batsman,
four_runs,
six_runs,
(run-(four_runs+six_runs)) AS other_run,
run AS total_run FROM
( 
  SELECT batsman,run ,four_runs*4 AS four_runs,six_runs*6 AS six_runs 
  FROM ipl_stats.most_run WHERE season ='ALL' 
  ORDER BY run DESC LIMIT 5 
)a;


add jar /home/hduser/usecase/ipl_stats/input_file/brickhouse-0.6.0.jar ;
CREATE TEMPORARY FUNCTION collect AS 'brickhouse.udf.collect.CollectUDAF';

SELECT batsman,
pivot_column['2008'] AS `2008`,
pivot_column['2009'] AS `2009`,pivot_column['2010'] AS `2010`,
pivot_column['2011'] AS `2011`,pivot_column['2012'] AS `2012`,
pivot_column['2013'] AS `2013`,pivot_column['2014'] AS `2014`,
pivot_column['2015'] AS `2014`,pivot_column['2016'] AS `2016`
FROM(
SELECT a.batsman,b.rank ,collect(a.season,a.run)AS pivot_column
FROM ipl_stats.most_run a JOIN
  (SELECT batsman,run,rank() over (order by run desc) as rank 
   FROM ipl_stats.most_run WHERE season ='ALL') b ON b.batsman=a.batsman 
WHERE rank <=5 GROUP BY a.batsman,b.rank ORDER BY b.rank ) a;

