--Drop previous versions of the table if they exist, in reverse order of foreign keys
DROP TABLE IF EXISTS Post CASCADE;
DROP TABLE IF EXISTS Student CASCADE;
DROP TABLE IF EXISTS Restaurant CASCADE;
DROP TABLE IF EXISTS EventAttendee CASCADE;

-- Create the schema
CREATE TABLE Student (
	email varchar(30) PRIMARY KEY,
	firstName varchar(50) NOT NULL,
	lastName varchar(50),
	collegeYear varchar(50),
	bio varchar(150),
	icon varchar(50)
	);

CREATE TABLE Restaurant (
	restaurantID int PRIMARY KEY,
	restaurantName varchar(50),
	address varchar (60) NOT NULL,
	openingTime time,
	closingTime time,
	priceRange int, -- Three tiers of prices ranging from 1 through 3
	discount varchar(80)
	);

CREATE TABLE Post (
	ID SERIAL PRIMARY KEY,
	studentEmail varchar(30),
	FOREIGN KEY (studentEmail) REFERENCES Student(email) ON DELETE CASCADE,
	restaurantID int,
	FOREIGN KEY (restaurantID) REFERENCES Restaurant(restaurantID),
	postTitle varchar (30),
	post varchar(150),
	postTime timestamp,
	meetupTime timestamp
);

CREATE TABLE EventAttendee (
	postID SERIAL,
	FOREIGN KEY (postID) REFERENCES Post(ID) ON DELETE CASCADE,
	studentEmail varchar(30),
	FOREIGN KEY (studentEmail) REFERENCES Student(email) ON DELETE CASCADE
);

-- Allow Students to select data from the tables
GRANT SELECT ON Student TO PUBLIC;
GRANT SELECT ON Restaurant TO PUBLIC;
GRANT SELECT ON Post TO PUBLIC;
GRANT SELECT ON EventAttendee TO PUBLIC;

-- Add all restaurants
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