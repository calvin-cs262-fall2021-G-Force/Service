DROP TABLE IF EXISTS PlayerGame;
DROP TABLE IF EXISTS Game;
DROP TABLE IF EXISTS Player;

-- Create the schema.
CREATE TABLE User (
	email varchar(50) PRIMARY KEY NOT NULL,
	firstName varchar(50) NOT NULL,
	lastName varchar(50)
	);

CREATE TABLE Player (
	ID SERIAL PRIMARY KEY,
	email varchar(50) NOT NULL,
	name varchar(50)
	);

CREATE TABLE PlayerGame (
	gameID integer REFERENCES Game(ID), 
	playerID integer REFERENCES Player(ID),
	score integer
	);
