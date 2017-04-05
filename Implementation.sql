/******** TABLES *******/

/*
* Created by: Carver
* Reviewed by: Bryan
* Relation for the user profiles which includes basic user information
* and whether they are a clan member.
*/
/** Picture is a string to the image url. **/
CREATE TABLE Profile (
	Email VARCHAR(63) PRIMARY KEY,
	Username VARCHAR(31) UNIQUE,
	Address VARCHAR(127),
	Latitude FLOAT,
	Longitude FLOAT,
	Age INT,
	Country VARCHAR(63),
	Gender VARCHAR(63),
	Description VARCHAR(255),
	Picture VARCHAR(255),
	ClanMember VARCHAR(31),
	FOREIGN KEY(ClanMember) REFERENCES Clan(Name)
		ON UPDATE CASCADE
		ON DELETE SET NULL
);

/*
* Created by: Danny
* Reviewed by: Nick
* Relation for games which include basic info about them
*/
CREATE TABLE Game (
	Title VARCHAR(63) PRIMARY KEY,
	ReleaseYear INT,
	GenreName VARCHAR(63) PRIMARY KEY,
	CHECK (GenreName in (SELECT “Action” UNION SELECT “Action-Adventure” UNION SELECT “Adventure” UNION SELECT “Role-playing” UNION SELECT “Simulation” UNION SELECT “Strategy” UNION SELECT “Sports”)
);

/*
* Created by: Danny
* Reviewed by: Carver
* Relation relating users to games.
* The user with that email plays the game with title and uses the role when they play
*/
CREATE TABLE Plays (
	Email VARCHAR(63),
	Title VARCHAR(63),
	DateAdded DATETIME,
	CharacterRole	VARCHAR(255),
	PRIMARY KEY(DateAdded, Email, Title),
	FOREIGN KEY(Email) REFERENCES Profile(Email) 
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(Title) REFERENCES Game(Title)
		ON UPDATE CASCADE
		ON DELETE DELETE
);

/*
* Created by: Carver
* Reviewed by: Nick
* Relation that holds all of the basic information for an event such as
* name, location, description, etc.
* Also tracks the owners of each event
*/
/** Picture is a string to the image url. **/
CREATE TABLE Event (
	Name VARCHAR(31),
	Address VARCHAR(127),
	DateTime DATETIME,
	VenueName VarChar(63),
	Latitude FLOAT,
	Longitude FLOAT,
	Description VARCHAR(255),
	Picture	VARCHAR(255),
	Creator VARCHAR(63) NOT NULL,
	PRIMARY KEY(Name, Address, DateTime),
	FOREIGN KEY(Creator) REFERENCES Profile(Email)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

/*
* Created by: Bryan
* Reviewed by: Danny
* Parent class structure for the Response, EventThread, and ClanThread subclasses
* Either begins a thread on an Event or Clan page or responds to another thread/response
* Can include both text and/or a picture
*/
/** Picture is a string to the image url. **/
CREATE TABLE Comment (
	Email VARCHAR(63),
	DateTime DATETIME,
	Comment VARCHAR(255) NOT NULL,
	Picture Varchar(255),
	PRIMARY KEY(Email, DateTime),
	FOREIGN KEY(Email) REFERENCES Profile(Email)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

/*
* Created by: Nick
* Reviewed by: Carver
* A special type of comment that is a response to an existing comment
* These comments will inherit the thread location of their parent
*/
CREATE TABLE Response(
	ResponseEmail VARCHAR(63),
	ResponseDateTime DATETIME,
	PRIMARY KEY(ResponseEmail, ResponseDateTime),
	FOREIGN KEY(ResponseEmail, ResponseDateTime) REFERENCES Comment(Emai, DateTimel) 
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

/*
* Created by: Bryan
* Reviewed by: Nick
* Subclass of Comment
* Creates a new thread on an Event page
*/
CREATE TABLE EventThread(
	EventName VARCHAR(31),
	EventAddress VARCHAR(127),
	EventDateTime DATETIME,
	ThreadDateTime DATETIME,
	ThreadEmail VARCHAR(63),
	PRIMARY KEY(ThreadDateTime, ThreadEmail),
	FOREIGN KEY(EventName, EventAddress, EventDateTime) REFERENCES Event(Name, Address, DateTime) 
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(ThreadDateTime, ThreadEmail) REFERENCES Comment(DateTime, Email)
			ON UPDATE CASCADE
			ON DELETE CASCADE
	UNIQUE (EventName, EventAddress, EventDateTime)
);

/*
* Created by: Nick
* Reviewed by: Bryan
* Creates a new top-level comment on a clan page
*/
CREATE TABLE ClanThread(
	ClanName VARCHAR(31),
	ThreadDateTime DATETIME,
	ThreadEmail VARCHAR(63),
	PRIMARY KEY(ThreadDateTime, ThreadEmail),
	FOREIGN KEY(ClanName) REFERENCES Clan(Name)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(ThreadDateTime, ThreadEmail) REFERENCES Comment(DateTime, Email)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	UNIQUE (ClanName)
);


/*
* Created by: Carver
* Reviewed by: Nick
* Self-Association relation of profile that records who are friends.
* Check that friends cannot be friends with themselves.
*/
CREATE TABLE FriendsWith (
	Email1 VARCHAR(63),
	Email2 VARCHAR(63),
	PRIMARY KEY(Email1, Email2),
	FOREIGN KEY(Email1) REFERENCES Profile(Email)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(Email2) REFERENCES Profile(Email)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CHECK (Email1 <> Email2)
);

/*
* Created by: Danny
* Reviewed by: Carver
* Relation for messages between 2 profiles. 
* Identifies the profiles based on receivedBy and sentBy.
* Also has an optional foreign key to itself specifying if it is a reply to a previous message
*/
CREATE TABLE Message (
	ReceivedBy VARCHAR(63),
	SentBy VARCHAR(63),
	DateTime DATETIME,
	Message VARCHAR(255),
	ResponseTo VARCHAR(63),
	ResponseFrom VARCHAR(63),
	ResponseDate VARCHAR(63),
	PRIMARY KEY(ReceivedBy, SentBy, DateTime),
	FOREIGN KEY(ReceivedBy) REFERENCES Profile(Email)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(SentBy) REFERENCES Profile(Email)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(ResponseTo, ResponseFrom, ResponseDate) REFERENCES Message(ReceivedBy, SentBy, DateTime)
		ON UPDATE CASCADE
		ON DELETE SET NULL
);

/*
* Created by: Carver
* Reviewed by: Danny
* Relation to hold the information of a clan, which is a group of users with a common connection
* Clans must have one and only one owner
*/
/** Picture is a string to the image url. **/
CREATE TABLE Clan (
	Name VARCHAR(31) PRIMARY KEY,
	Description VARCHAR(255),
	Picture VARCHAR(255),
	Owner VARCHAR(63) NOT NULL,
	FOREIGN KEY(Owner) REFERENCES Profile(Email)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	UNIQUE (Owner)
);

/*
* Created by: Danny
* Reviewed by: Bryan
* Relates Events to Games based on whether 
* the Game will be played at the Event
*/
CREATE TABLE WillBePlayed (
	Name VARCHAR(31),
	Address VARCHAR(127),
	DateTime DATETIME,
	Title VARCHAR(63),
	PRIMARY KEY(Name, Address, DateTime, Title),
	FOREIGN KEY(Name, Address, DateTime) REFERENCES Event(Name, Address, DateTime)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(Title) REFERENCES Game(Title) 
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

/*
* Created by: Nick
* Reviewed by: Bryan
* Relates profiles to events when people sign-up as “attending”
*/
CREATE TABLE Attending (
	Email VARCHAR(63),
	Name VARCHAR(31),
	Address VARCHAR(127),
	DateTime DATETIME,
	PRIMARY KEY(Email, Name, Address, DateTime),
	FOREIGN KEY(Email) REFERENCES Profile(Email)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY(Name, Address, DateTime) REFERENCES Event(Name, Address, DateTime)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

/*
* Created by: Bryan
* Reviewed by: Danny
* Records which Comment was upvoted and which Profile upvoted it
*/
CREATE TABLE Upvoted (
	ProfileEmail VARCHAR(63),
	CommentEmail VARCHAR(63),
	DateTime DATETIME,
	PRIMARY KEY(ProfileEmail,CommentEmail, DateTime),
	FOREIGN KEY(ProfileEmail) REFERENCES Profile(Email)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (CommentEmail, DateTime) REFERENCES Comment(Email, DateTime)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

/******* TRIGGERS *******/

/*
* Created by: Danny
* Reviewed by: Nicholas
*/
/*After a clan is created, set the creator to be in the clan*/
CREATE TRIGGER ClanCreated
AFTER INSERT ON Clan
FOR EACH ROW
BEGIN
	UPDATE Profile
	SET ClanMember = New.Name
	WHERE Email = New.Owner;
END;

/*
* Created by: Nick
* Reviewed by: Danny
*/
*/ When a comment is updated (edited), change the DateTime to the most recent edit */
CREATE TRIGGER CommentEdited
AFTER UPDATE ON Comment
FOR EACH ROW
BEGIN
	UPDATE Comment
	SET DateTime = NOW()    /* NOW() returns the current DATETIME */
	WHERE New.Email = Old.Email AND New.DateTime = Old.DateTime AND 
   (New.Comment <> Old.Comment OR New.Picture <> Old.Picture);
END;

/******* VIEWS *******/

/*
* Created by: Carver
* Reviewed by: Bryan
*/
/*View all of the roles users have/will have played over all events */
CREATE VIEW RolesPlayed(Username,Title,Role,Name, Address, DateTime) AS
	SELECT P.Username, G.Title, Pl.Role, E.Name, E.Address, E.DateTime
	FROM Profile P, Game G, Event E, Plays Pl, WillBePlayed W, Attending A
	WHERE P.Email = Pl.Email AND Pl.Title = G.Title AND G.Title = W.Title AND 
	E.Name = W.Name AND E.Address = W.Address AND E.DateTime = W.DateTime AND 
	P.Email = A.Email AND E.Name = A.Name AND E.Address = A.Address AND E.DateTime = A.DateTime

/*
* Created by: Bryan
* Reviewed by: Nicholas
* View all events attended by X (in this case 500) or more users
*/
CREATE VIEW LargeAttendance as
	SELECT *
	FROM Event E, (SELECT COUNT(*) FROM Attending A WHERE A.Name = E.Name AND A.Address = E.Address AND A.DateTime = E.DateTime) as ACount
	WHERE ACount >= 500
	GROUP BY E.Name, E.Address, E.DateTime;

/******* ASSERTIONS *******/
/*
* Created by: Nick
* Reviewed by: Carver
*/
/*  Ensure that our comment subclassing is demonstrating complete coverage
* i.e. Comments should either be responses, clan threads, or event threads
*/
CREATE ASSERTION CommentCoverage
	CHECK (
	NOT EXISTS (SELECT * FROM Comment
	WHERE (Email, DateTime) 
	NOT IN ((SELECT Email, DateTime FROM Response 
	  UNION SELECT Email, DateTime FROM ClanThread)
	  UNION SELECT Email, DateTime FROM EventThread)
	)
);

/*
* Created by: Nick
* Reviewed by: Carver
*/
/* Enforces 1…* cardinality for having at least one member in each clan at any time */
CREATE ASSERTION ClanNotEmpty
	CHECK (
	NOT EXISTS (SELECT * 
	FROM Clan
	WHERE Name NOT IN (SELECT ClanMember FROM Profile))
);

/***** QUERIES *****/

/*
* Created by: Danny
* Reviewed by: Carver
*/
/*Insert sample data into profile*/
INSERT INTO Profile(Email, Username, Address, Latitude, Longitude, Age, Country, Gender, Description, Picture, ClanMember)
VALUES
(‘daniel.mccormick@vanderbilt.edu’, ’Danny’, ’311 Orchard Ln’, 15321.5, -145.32,20, ’USA’, ’Male’, ’Best gamer’, ‘http://www.smashbros.com/us/images/index/image/main-wiiu-logo.png’, NULL);

/*
* Created by: Danny
* Reviewed by: Nicholas
*/
/*Get the total number of upvotes for a given comment*/
SELECT COUNT(*) 
FROM UpVoted U
WHERE U.CommentEmail = ‘daniel.mccormick@vanderbilt.edu’
AND U.DateTime = ‘2016-03-23 10:10:10’;


/*
* Created by: Danny
* Reviewed by: Bryan
*/
/*Get the most attended event on a given day and the number of people attending*/
SELECT Tot.Name, Tot.Address, ‘2016-03-23’, MAX(Tot.Num)
FROM (SELECT Name, Address, COUNT(Email) AS Num
FROM Attending A
WHERE A.DateTime = ‘2016-03-23’
GROUP BY Name,Address) Tot;

/*
* Created by: Bryan
* Reviewed by: Carver
* Finds how many of a profile’s friends play a game
* In this case, find how many of Bryan’s play Super Smash Bros Melee
*/
SELECT COUNT(*)
FROM FriendsWith F, Plays P
WHERE F.Email1 = ‘bryan.a.diaz@vanderbilt.edu’ AND P.Email = F.Email2 AND P.Title = ‘Super Smash Bros Melee’;

/*
* Created by: Bryan
* Reviewed by: Danny
* Find the games played at all events created by a profile
* ‘User’ is a placeholder for the profile we want to find out about
*/
SELECT W.Title
FROM Event E, WillBePlayed W
WHERE E.Creator = ‘User’ AND E.Name = W.Name AND E.Address = W.Address AND E.DateTime = W.DateTime;

/*
* Created by: Bryan
* Reviewed by: Nicholas
* Find the top 5 largest clans and how many people are in each clan
*/
SELECT C.Name, CC.Count
FROM Clan C,  (SELECT COUNT(*) as Count
		FROM Profile P
		WHERE C.Name = P. ClanMember
		GROUP BY C.Name ASC) as CC
ORDER BY CC.Count desc
LIMIT 5;

/*
* Created by: Carver
* Reviewed by: Nicholas
*/
/*Find mutual friends between 2 given users. In this query, return mutual friends of Danny and Carver*/
SELECT f2.Email2
FROM FriendsWith f1 JOIN FriendsWith f2 USING (Email2)
WHERE f1.Email = “carver.d.sorensen@vanderbilt.edu” AND f2.Email1 = “daniel.mccormick@vanderbilt.edu”;

/*
* Created by: Carver
* Reviewed by: Danny
*/
/*Get the 10 profiles that attended the most events*/
SELECT TOP 10 P.Email
FROM (SELECT A.Email AS Email, Count(A.*) AS Tot
FROM Attending A
GROUP BY A.Email) P
ORDER BY A.Tot DESC;

/*
* Created by: Carver
* Reviewed by: Bryan
*/
/*Delete all messages that are at least 10 years old*/
DELETE FROM Message
WHERE datetime(‘now’, ‘-10 year’) >= DateTime;

/*
* Created by: Nick
* Reviewed by: Danny
*/
/* Find Venues that have held more than 5 events */
SELECT E.VenueName
FROM Event E
GROUP BY E.VenueName
HAVING COUNT(*) > 5;

/*
* Created by: Nick
* Reviewed by: Carver
*/
/* Find games that have been played (or will be played) at more than 10 tournaments */
SELECT G.Title
FROM WillBePlayed G
GROUP BY G.Title
HAVING COUNT(*) > 10;

/*
* Created by: Nick
* Reviewed by: Bryan
*/
/* Find the average age of male gamers for each country in the database */
SELECT P.Country, AVG(P.Age)
FROM Profile P
WHERE P.Gender = ‘Male’
GROUP BY P.Country;
