--Drop previous versions of the table if they exist, in reverse order of foreign keys
DROP TABLE IF EXISTS Post CASCADE;
DROP TABLE IF EXISTS Student CASCADE;
DROP TABLE IF EXISTS Restaurant CASCADE;

-- Create the schema
CREATE TABLE Student (
	email varchar(30) PRIMARY KEY,
	firstName varchar(50) NOT NULL,
	lastName varchar(50),
	bio varchar(150)
	);

CREATE TABLE Restaurant (
	ID int PRIMARY KEY,
	name varchar(50),
	address varchar (60) NOT NULL,
	openingTime time,
	closingTime time,
	priceRange int, -- Three tiers of prices ranging from 1 through 3
	discount varchar(30)
	);

CREATE TABLE Post (
	studentEmail varchar(30) REFERENCES Student(email),
	restaurantID int,
	FOREIGN KEY (restaurantID) REFERENCES Restaurant(ID),
	postTitle varchar (30),
	post varchar(150),
	postTime timestamp,
	meetupTime timestamp,
	PRIMARY KEY(StudentEmail, postTime)
	);

-- Allow Students to select data from the tables
GRANT SELECT ON Student TO PUBLIC;
GRANT SELECT ON Restaurant TO PUBLIC;
GRANT SELECT ON Post TO PUBLIC;

-- Add sample records
INSERT INTO Student VALUES ('bw12', 'Bruce', 'Wayne', 'I am vengance');
INSERT INTO Student VALUES ('ck23', 'Clark', 'Kent', 'Up, up, and away!');
INSERT INTO Student VALUES ('dp34', 'Diana', 'Prince', 'Fighting doesn''t make you a hero');

INSERT INTO Restaurant VALUES (1,'Johnny''s', '3201 Burton St SE, Grand Rapids, MI', '09:00', '21:00', 1, '20% off');
INSERT INTO Restaurant VALUES (2, 'Peet''s', '3201 Burton St SE, Grand Rapids, MI', '08:00', '20:00', 1, '$15 off till 2pm');
INSERT INTO Restaurant VALUES (3, 'Ucello''s Ristorante', '2630 E Beltline Ave SE, Grand Rapids, MI 49546', '11:00', '02:00', 2, '10% off');
INSERT INTO Restaurant VALUES (4, 'Panera Bread', '5630 28th Street SE, Grand Rapids, MI 49546', '08:00', '18:00', 3, '$2 off');

INSERT INTO Post VALUES ('bw12', 1 , 'Wanna have lunch at Johnny''s?','I am going to Johnny''s with my friends in a bit. You can join if you want to','2021-10-31 10:23:54', '2021-11-02 10:30');
INSERT INTO Post VALUES ('ck23', 2 , 'NEED COFFEE','I need to get coffee NOW! Anybody wanna join me?','2021-10-28 10:30', '2021-10-31 12:25');