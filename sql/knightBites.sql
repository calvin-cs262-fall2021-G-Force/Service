--Drop previous versions of the table if they exist, in reverse order of foreign keys
DROP TABLE IF EXISTS Post CASCADE;
DROP TABLE IF EXISTS Student CASCADE;
DROP TABLE IF EXISTS Restaurant CASCADE;
DROP TABLE IF EXISTS EventAttendee CASCADE;

-- Create the schema
CREATE TABLE Student (
	email varchar(30) PRIMARY KEY,
	password varchar(50),
	firstName varchar(50) NOT NULL,
	lastName varchar(50),
	year varchar(50),
	bio varchar(150),
	icon varchar(50)
	);

CREATE TABLE Restaurant (
	ID int PRIMARY KEY,
	name varchar(50),
	address varchar (60) NOT NULL,
	openingTime time,
	closingTime time,
	priceRange int, -- Three tiers of prices ranging from 1 through 3
	discount varchar(80)
	);

CREATE TABLE Post (
	ID SERIAL PRIMARY KEY,
	studentEmail varchar(30),
	FOREIGN KEY (studentEmail) REFERENCES Student(email),
	restaurantID int,
	FOREIGN KEY (restaurantID) REFERENCES Restaurant(ID),
	postTitle varchar (30),
	post varchar(150),
	postTime timestamp,
	meetupTime timestamp
);

CREATE TABLE EventAttendee (
	postID SERIAL,
	FOREIGN KEY (postID) REFERENCES Post(ID),
	studentEmail varchar(30),
	FOREIGN KEY (studentEmail) REFERENCES Student(email)
);

-- Allow Students to select data from the tables
GRANT SELECT ON Student TO PUBLIC;
GRANT SELECT ON Restaurant TO PUBLIC;
GRANT SELECT ON Post TO PUBLIC;
GRANT SELECT ON EventAttendee TO PUBLIC;

-- Add sample records
INSERT INTO Student VALUES ('bw12', 'pw12', 'Bruce', 'Wayne', 'Sophomore', 'I am vengance', 'bug-outline'); 
INSERT INTO Student VALUES ('ck23', 'pw23', 'Clark', 'Kent', 'Junior', 'Up, up, and away!', 'rocket-outline');
INSERT INTO Student VALUES ('dp34', 'pw34', 'Diana', 'Prince', 'Senior','Fighting doesn''t make you a hero', 'pulse-outline');

INSERT INTO Restaurant VALUES (1,'Uccello''s Ristorante', '2630 E Beltline Ave SE, Grand Rapids, MI 49546', '11:00', '23:00', 1, '15% off');
INSERT INTO Restaurant VALUES (2, 'Anna''s House', '2409 E Beltline Ave SE, Grand Rapids, MI 49546', '06:00', '15:00', 1, '10% off till 2pm');
INSERT INTO Restaurant VALUES (3, 'IHOP', '5039, 28th Street SE, MI 49546', '6:00', '22:00', 2, '20% off');
INSERT INTO Restaurant VALUES (4, 'Papa Johns', '4236 Kalamazoo Ave SE, Grand Rapids, MI 49508', '08:00', '23:00', 3, 'Large 1 Toppings go for $6.99 and Large 3 Toppings go for $10');
INSERT INTO Restaurant VALUES (5, 'Eastern Floral', '2836 Broadmoor Ave SE, Grand Rapids, MI 49512', '09:00', '17:30', 3, '10% off');
INSERT INTO Restaurant VALUES (6, 'Schuil Coffee', '3679 29th St SE, Grand Rapids, MI 49512', '07:00', '18:00', 3, '20% off');
INSERT INTO Restaurant VALUES (7, 'Culver''s', '2510 E Beltline Ave SE, Grand Rapids, MI 49546', '10:00', '23:00', 1, '5% off');
INSERT INTO Restaurant VALUES (8, 'Align Nutrition', '1144 E Paris Ave SE Suite 6, Grand Rapids, MI 49546', '08:00', '18:00', 3, '$1 off');
INSERT INTO Restaurant VALUES (9, 'Applebees''s', '4955 28th St SE, Grand Rapids, MI 49546', '11:00', '24:00', 2, '10% off');
INSERT INTO Restaurant VALUES (10, 'Panera Bread', '3770 28th St SE, Kentwood, MI 49512', '06:00', '19:00', 3, 'Limitied Coffee $8.99 a month');
INSERT INTO Restaurant VALUES (11, 'Malamiah Juice Bar', '122 Oakes St SW #110, Grand Rapids, MI 49503', '07:00', '16:00', 1, '10% off');
INSERT INTO Restaurant VALUES (12, 'Hall Street Bakery', '1200 Hall St SE, Grand Rapids, MI 49506', '6:30', '21:00', 2, '10% off');
INSERT INTO Restaurant VALUES (13, 'Cafe Boba', '4314 Division Ave S, Kentwood, MI 49548', '14:00', '20:00', 1, '10% off');
INSERT INTO Restaurant VALUES (14, 'Old Chicago', '3333 28th St SE Ste 1, Grand Rapids, MI 49512', '11:00', '22:00', 2, '$5 off on an order of $20 or more');
INSERT INTO Restaurant VALUES (15, 'Tallarico''s Boardwalk Subs', '3083 Broadmoor Ave SE, Kentwood, MI 49512', '10:30', '15:00', 1, '15% off');
INSERT INTO Restaurant VALUES (16, 'Panda Express', '3170 28th St SE, Kentwood, MI 49508', '10:30', '21:00', 1, '20% off');
INSERT INTO Restaurant VALUES (17, 'Bitter End Coffeehouse', '752 Fulton St W, Grand Rapids, MI 49504', '01:00', '24:00', 1, '10% off');

INSERT INTO Post(studentemail, restaurantid, posttitle, post, posttime, meetuptime) VALUES ('bw12', 1 , 'Wanna have lunch at Johnny''s?','I am going to Johnny''s with my friends in a bit. You can join if you want to','2021-10-31 10:23:54', '2021-11-02 10:30');
INSERT INTO Post(studentemail, restaurantid, posttitle, post, posttime, meetuptime) VALUES ('ck23', 2 , 'Lunch at Culvers','I need to get coffee NOW! Anybody wanna join me?','2021-10-28 10:30', '2021-10-31 12:25');
INSERT INTO Post(studentemail, restaurantid, posttitle, post, posttime, meetuptime) Values('bw12', 4, 'Me Hungry', 'need fooood', '2021-12-04 09:29:35 +0000', '2021-12-24 10:25:00 +0000');
INSERT INTO Post(studentemail, restaurantid, posttitle, post, posttime, meetuptime) Values('dp34', 2, 'Let''s get COFFEE', 'Really need coffee asap', '2021-12-06 08:24:35 +0000', '2021-12-30 12:25:00 +0000');

INSERT INTO EventAttendee VALUES (1, 'ck23');
INSERT INTO EventAttendee VALUES (1, 'dp34');
INSERT INTO EventAttendee VALUES (2, 'bw12');