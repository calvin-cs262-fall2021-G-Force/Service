-- Sample queries

-- Get all records from the Student table
SELECT * FROM Student

-- Get all records from the Restaurant table
SELECT * FROM Restaurant

-- Get name of the student, restaurant information, and meetup information
SELECT Student.firstName, Student.lastName, restaurantName, restaurantAddress, meetupTime, postTime, priceRange
FROM Post, Restaurant, Student  
WHERE studentEmail = Student.email AND
Restaurant.name = restaurantName AND
Post.studentEmail = 'ck23'