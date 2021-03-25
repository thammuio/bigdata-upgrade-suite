USE ${DB};

CREATE TABLE Sales_Data
(
StoreLocation VARCHAR(30),
Product VARCHAR(30),
OrderDate DATE,
Revenue DECIMAL(10,2));

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

select * from Sales_Data;