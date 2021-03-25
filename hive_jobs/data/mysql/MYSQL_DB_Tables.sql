# This is a SQL file which creates all the tables used as examples
# Please note that if you are creating tables, use
# DIFFERENT tables names or use a DIFFERENT DATABASE with the same table names.
#
# NOTE: The Sales_Data table has 2 versions called Sales_Data and Sales_Data_new
# The second version references the Stores and Products table.
#
# Run this test file if you want to try out the examples
#
# Starting up MySQL and running the commands in this file in a Terminal Window:
# Run “mysql < DB_Tables.sql” on the terminal window prompt
#
# If you’re already inside MySQl
# Run “source file_name”
# Then “\. file_name”
#
# See this link for additional details:
# https://dev.mysql.com/doc/refman/5.7/en/mysql-batch-commands.html
#
# For MySql workbench just see this link on how to run scripts within it
# https://dev.mysql.com/doc/workbench/en/wb-sql-editor-toolbar.html


# Use the exampleDB;

create database exampleDB;
use exampleDB;

CREATE TABLE Students
(
StudentID INT NOT NULL AUTO_INCREMENT,
FirstName VARCHAR(30) NOT NULL,
LastName VARCHAR(30) NOT NULL,
Gender CHAR(1),
Email VARCHAR(30) NOT NULL,
PRIMARY KEY (StudentID)
);

# Insert data into the Students table

INSERT INTO Students
(FirstName,LastName,Gender,Email)
VALUES
('Janani','Ravi','F','janani@loonycorn.com');

INSERT INTO Students
(FirstName,LastName,Gender,Email)
VALUES
('Swetha','Kolalapudi','F','swetha@loonycorn.com'),
('Vitthal','Srinivasan','M','vitthal@loonycorn.com'),
('Navdeep','Singh','M','navdeep@loonycorn.com');

INSERT INTO Students
(Email,FirstName,LastName)
VALUES
('mateenwa@gmail.com','Ahmad','Mateen');

INSERT INTO Students
(StudentID,Email,FirstName,LastName)
VALUES
(99,'anuradha@gmail.com','Anu','Radha');

INSERT INTO Students
(Email,FirstName,LastName)
VALUES
('pradeep@loonycorn.com','Pradeep','Shetty');

# Create the Campus_Housing tab;e

CREATE TABLE Campus_Housing
(
StudentID INT NOT NULL,
DormitoryName VARCHAR(50),
AptNumber INT,
CONSTRAINT fk_students_studentid
FOREIGN KEY (StudentID)
REFERENCES Students (StudentID)
);

# Insert into the Campus_Housing table

INSERT INTO Campus_Housing
values
(1,'Gandhi House',110),
(2,'Akbar Hall',231),
(3,'Gandhi House',345),
(4,NULL,NULL);


# Create and insert data into the Sales_Data table

CREATE TABLE Sales_Data
(
StoreLocation VARCHAR(30) NOT NULL,
Product VARCHAR(30) NOT NULL,
Date DATE NOT NULL,
Revenue DEC(10,2) NOT NULL DEFAULT 0.0,
PRIMARY KEY (StoreLocation,Product, Date)
);

Insert into Sales_Data
Values
('Bellandur','Bananas','2016-01-16', 8236.33);

Insert into Sales_Data
Values
('Bellandur','Nutella','2016-01-16', 7455.67),
('Bellandur','Peanut Butter', '2016-01-16',5316.89),
('Bellandur','Milk','2016-01-16', 2433.76),
('Koramangala','Bananas','2016-01-16', 9456.01),
('Koramangala','Nutella ','2016-01-16',3644.33),
('Koramangala','Peanut Butter', '2016-01-16', 8988.64),
('Koramangala','Milk','2016-01-16', 1621.58);

Insert into Sales_Data
Values
('Bellandur','Bananas','2016-01-18', 8236.33),
('Bellandur','Nutella','2016-01-18', 7455.67),
('Bellandur','Peanut Butter','2016-01-18', 5316.89),
('Bellandur','Milk','2016-01-18', 2433.76),
('Koramangala','Bananas','2016-01-18', 9456.01),
('Koramangala','Nutella','2016-01-18', 3644.33),
('Koramangala','Peanut Butter','2016-01-18', 8988.64),
('Koramangala','Milk','2016-01-18',1621.58),
('Bellandur','Bananas','2016-01-17', 2342.33),
('Bellandur','Nutella','2016-01-17', 6345.10),
('Bellandur','Peanut Butter','2016-01-17', 5673.01),
('Bellandur','Milk','2016-01-17', 4543.98),
('Koramangala','Bananas','2016-01-17', 8902.65),
('Koramangala','Nutella','2016-01-17', 9114.67),
('Koramangala','Peanut Butter','2016-01-17', 5102.05),
('Koramangala','Milk','2016-01-17', 1299.45);

# Create and insert into the Stores table

create table stores
(
StoreID INT NOT NULL,
StoreLocation VARCHAR(30) NOT NULL,
City VARCHAR(30) NOT NULL,
PRIMARY KEY(StoreID))
;

Insert into stores
values
(1,'Bellandur', 'Bangalore'),
(2,'Koramangala', 'Bangalore'),
(3,'Deccan Gymkhana', 'Pune'),
(4,'Bandra','Mumbai'),
(5,'Hussain Sagar', 'Hyderabad'),
(6,'Powai','Mumbai'),
(7,'Koregaon Park','Pune');

# Create and insert into the Products table

create table products
(
ProductID INT NOT NULL,
ProductName VARCHAR(30),
PRIMARY KEY (ProductID)
);

# Create a Sales_Data_new which holds the store id
# and product id information and references the Stores
# and Products table

CREATE TABLE Sales_Data_new
(
StoreID INT NOT NULL,
ProductID INT NOT NULL,
Date DATE NOT NULL,
Revenue DEC(10,2) NOT NULL DEFAULT 0.0,
PRIMARY KEY (StoreID,ProductID, Date)
);

insert into Sales_Data_new
values
(1, 1 , '2016-01-17',2342.33 ),
(1, 2 , '2016-01-17',4543.98 ),
(1, 3 , '2016-01-17',6345.10 ),
(1, 4 , '2016-01-17',5673.01 ),
(2, 1 , '2016-01-17',8902.65 ),
(2, 2 , '2016-01-17',1299.45 ),
(2, 3 , '2016-01-17',9114.67 ),
(2, 4 , '2016-01-17',5102.05 ),
(1, 1 , '2016-01-18',8236.33 ),
(1, 2 , '2016-01-18',2433.76 ),
(1, 3 , '2016-01-18',7455.67 ),
(1, 4 , '2016-01-18',5316.89 ),
(2, 1 , '2016-01-18',9456.01 ),
(2, 2 , '2016-01-18',1621.58 ),
(2, 3 , '2016-01-18',3644.33 ),
(2, 4 , '2016-01-18',8988.64 );


Insert into products
values
(1,'Bananas'),
(2,'Milk'),
(3,'Nutella'),
(4,'Peanut Butter'),
(5,'Marmalade'),
(6,'Oranges'),
(7,'Condensed Milk');


# Create the Movies and Reviews table

create table Movies
(
MovieID INT NOT NULL,
MovieName VARCHAR(30),
Country varchar(30),
Year int NOT null,
PRIMARY KEY (MovieID)
);

create table Reviews
(
MovieID INT NOT NULL,
ReviewID INT NOT NULL,
Review VARCHAR(30),
Rating int unsigned NOT null,
PRIMARY KEY (ReviewID)
);

insert into Movies
(MovieID, MovieName,Year,Country)
values
(1, 'The Godfather',1972, 'USA'),
(2, 'The Departed',2006,'USA'),
(3, 'Infernal Affairs',2002,'Hong Kong'),
(4, 'Parinda',1989,'India'),
(5, 'Gunda',1998,'India'),
(6, 'Little Caesar',1931,'USA');


insert into Reviews
values
(1,1, 'Amazing',5),
(1,2, 'Genre-Defining',5),
(1,3, 'Classic',5),
(1,4, 'Overrated',1),
(1,5, 'OK, Not Great',3),
(1,6, 'Two Thumbs Up',5),
(3,7, 'Crossover Hit',5),
(3,8, 'Love It',4),
(3,9, 'Nailbiting!',5),
(1,10, 'Cinematic Masterpiece',5),
(5,11, 'So Bad Its Good',0),
(2,12, 'Not Best As Good as Original',3),
(2,13, 'Overrated',2),
(2,14, 'Too Morbid',3),
(4,15, 'Sad, Thought-Provoking',4),
(4,16, 'Cinema At Its Best',5);





/*check *
SELECT M.MovieName,
AVG(R.Rating)

FROM
 MOVIES M
INNER JOIN
 REVIEWS R
ON
 M.MovieID = R.MovieID
GROUP BY MovieName
 HAVING COUNT(ReviewID) >= 2;

SELECT
M.MovieID,
R.Review
from
 movies M
 left join
 reviews  R
 ON
 M.MovieID = R.MovieID;
SELECT S.StudentID,FirstName,LastName
FROM students S, campus_housing C
WHERE
DormitoryName = 'Akbar Hall'
AND S.StudentID = C.StudentID;

SELECT S.StoreLocation,REV.Date, Revenue
FROM
 stores S
 INNER JOIN
 sales_data_new REV
 ON
 S.StoreID = REV.StoreID
 AND S.StoreLocation = 'KORAMANGALA';
 
 SELECT SUM(REVENUE)TotalRevenue, Product
FROM
Sales_Data
GROUP BY
Product;
*/