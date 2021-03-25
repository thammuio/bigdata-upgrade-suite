USE ${DB};

select count(distinct part) from partiton_tbl_1;
select count(distinct part) from partiton_tbl_2;
select count(distinct part) from partiton_tbl_3;
select count(distinct part) from partiton_tbl_4;
select count(distinct part) from partiton_tbl_5;
select count(distinct part) from partiton_tbl_6;
select count(distinct part) from partiton_tbl_7;
select count(distinct part) from partiton_tbl_8;
select count(distinct part) from partiton_tbl_9;
select count(distinct part) from partiton_tbl_10;

select count(distinct part) from ext_partiton_tbl_1;
select count(distinct part) from ext_partiton_tbl_2;
select count(distinct part) from ext_partiton_tbl_3;
select count(distinct part) from ext_partiton_tbl_4;
select count(distinct part) from ext_partiton_tbl_5;
select count(distinct part) from ext_partiton_tbl_6;
select count(distinct part) from ext_partiton_tbl_7;
select count(distinct part) from ext_partiton_tbl_8;
select count(distinct part) from ext_partiton_tbl_9;
select count(distinct part) from ext_partiton_tbl_10;

-- Count all partitions
SELECT
v1.partiton_tbl_1,v2.partiton_tbl_2,v3.partiton_tbl_3,v4.partiton_tbl_4,v5.partiton_tbl_5,v6.partiton_tbl_6,v7.partiton_tbl_7,v8.partiton_tbl_8,v9.partiton_tbl_9,v10.partiton_tbl_10,
ev1.ext_partiton_tbl_1,ev2.ext_partiton_tbl_2,ev3.ext_partiton_tbl_3,ev4.ext_partiton_tbl_4,ev5.ext_partiton_tbl_5,ev6.ext_partiton_tbl_6,ev7.ext_partiton_tbl_7,ev8.ext_partiton_tbl_8,ev9.ext_partiton_tbl_9,ev10.ext_partiton_tbl_10
FROM
  (select count(distinct part) as partiton_tbl_1 from partiton_tbl_1) AS v1
CROSS JOIN
  (select count(distinct part) as partiton_tbl_2 from partiton_tbl_2) AS v2
CROSS JOIN
  (select count(distinct part) as partiton_tbl_3 from partiton_tbl_3) AS v3
CROSS JOIN
  (select count(distinct part) as partiton_tbl_4 from partiton_tbl_4) AS v4
CROSS JOIN
  (select count(distinct part) as partiton_tbl_5 from partiton_tbl_5) AS v5
CROSS JOIN
  (select count(distinct part) as partiton_tbl_6 from partiton_tbl_6) AS v6
CROSS JOIN
  (select count(distinct part) as partiton_tbl_7 from partiton_tbl_7) AS v7
CROSS JOIN
  (select count(distinct part) as partiton_tbl_8 from partiton_tbl_8) AS v8
CROSS JOIN
  (select count(distinct part) as partiton_tbl_9 from partiton_tbl_9) AS v9
CROSS JOIN
  (select count(distinct part) as partiton_tbl_10 from partiton_tbl_10) AS v10
CROSS JOIN
  (select count(distinct part) as ext_partiton_tbl_1 from partiton_tbl_1) AS ev1
CROSS JOIN
  (select count(distinct part) as ext_partiton_tbl_2 from partiton_tbl_2) AS ev2
CROSS JOIN
  (select count(distinct part) as ext_partiton_tbl_3 from partiton_tbl_3) AS ev3
CROSS JOIN
  (select count(distinct part) as ext_partiton_tbl_4 from partiton_tbl_4) AS ev4
CROSS JOIN
  (select count(distinct part) as ext_partiton_tbl_5 from partiton_tbl_5) AS ev5
CROSS JOIN
  (select count(distinct part) as ext_partiton_tbl_6 from partiton_tbl_6) AS ev6
CROSS JOIN
  (select count(distinct part) as ext_partiton_tbl_7 from partiton_tbl_7) AS ev7
CROSS JOIN
  (select count(distinct part) as ext_partiton_tbl_8 from partiton_tbl_8) AS ev8
CROSS JOIN
  (select count(distinct part) as ext_partiton_tbl_9 from partiton_tbl_9) AS ev9
CROSS JOIN
  (select count(distinct part) as ext_partiton_tbl_10 from partiton_tbl_10) AS ev10
;


-- Get max value of partition
select max(part) from partiton_tbl_1;
select max(part) from partiton_tbl_2;
select max(part) from partiton_tbl_3;
select max(part) from partiton_tbl_4;
select max(part) from partiton_tbl_5;
select max(part) from partiton_tbl_6;
select max(part) from partiton_tbl_7;
select max(part) from partiton_tbl_8;
select max(part) from partiton_tbl_9;
select max(part) from partiton_tbl_10;

select max(part) from ext_partiton_tbl_1;
select max(part) from ext_partiton_tbl_2;
select max(part) from ext_partiton_tbl_3;
select max(part) from ext_partiton_tbl_4;
select max(part) from ext_partiton_tbl_5;
select max(part) from ext_partiton_tbl_6;
select max(part) from ext_partiton_tbl_7;
select max(part) from ext_partiton_tbl_8;
select max(part) from ext_partiton_tbl_9;
select max(part) from ext_partiton_tbl_10;