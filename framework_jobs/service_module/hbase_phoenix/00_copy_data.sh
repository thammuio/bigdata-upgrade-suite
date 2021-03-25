#!/bin/bash

hdfs dfs -put data/phoenix_driver_events.csv /tmp/
hdfs dfs -chmod 777 /tmp/phoenix_driver_events.csv

hdfs dfs -put data/phoenix_us_population.csv /tmp/
hdfs dfs -chmod 777 /tmp/phoenix_us_population.csv

hdfs dfs -put data/books.csv /tmp/
hdfs dfs -chmod 777 /tmp/books.csv

