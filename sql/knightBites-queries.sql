-- Sample queries

-- Get all records from the Student table
SELECT * FROM Student

-- Get all records from the Restaurant table
SELECT * FROM Restaurant

-- Get all the information about each post, student who made the post, and restaurant 
-- the post is associated with from the database in descending order of post time
SELECT *
FROM Post, Student, Restaurant
WHERE Post.studentEmail = Student.email
AND Post.restaurantId = Restaurant.restaurantID
ORDER BY posttime DESC

-- Get the email, firstname, and lastname of all students who are attending an event.
SELECT studentEmail, firstname, lastname
FROM EventAttendee, Student
WHERE EventAttendee.studentEmail=Student.email
AND postid = 83