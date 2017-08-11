#!/bin/sh 
#set the environment

export HIVE_SCRIPT_DIR=/home/hduser/usecase/ipl_stats/scripts/hive_scripts
export  PIG_SCRIPT_DIR=/home/hduser/usecase/ipl_stats/scripts/pig_scripts
export PIG_LOG_FILE=/home/hduser/usecase/ipl_stats/output_file/pig.log
truncate $PIG_LOG_FILE --size 0

echo "$(date) [MSG] Script Start Sucessfully " >> $PIG_LOG_FILE

# Creating table for stats report
echo "$(date) [INFO] Table Creation  ---> START " >> $PIG_LOG_FILE
hive -f $HIVE_SCRIPT_DIR/most_run.sql 
echo "$(date) [INFO] Table Creation  ---> END   " >> $PIG_LOG_FILE 

# Calling Data Loading Script
echo "$(date) [INFO] Data Loading in ipl_stats DB ---> START " >> $PIG_LOG_FILE
pig -useHCatalog $PIG_SCRIPT_DIR/most_run.pig
echo "$(date) [INFO] Data Loading in ipl_stats DB ---> END   " >> $PIG_LOG_FILE

echo "$(date) [MSG] Script run Sucessfully " >> $PIG_LOG_FILE