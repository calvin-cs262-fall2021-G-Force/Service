/**
 * This module implements a REST-inspired webservice for the Knight Bites App.
 * The database is hosted on ElephantSQL.
 *
 * To guard against SQL injection attacks, this code uses pg-promise's built-in
 * variable escaping. This prevents a client from issuing this URL:
 *     https://cs262-monopoly-service.herokuapp.com/players/1%3BDELETE%20FROM%20PlayerGame%3BDELETE%20FROM%20Player
 * which would delete records in the PlayerGame and then the Player tables.
 * In particular, we don't use JS template strings because it doesn't filter
 * client-supplied values properly.
 *
 * TODO: Consider using Prepared Statements.
 *      https://vitaly-t.github.io/pg-promise/PreparedStatement.html
 *
 * @author: Knight Bites Team
 * @date: Fall 2021
 */

// Set up the database connection.
const pgp = require("pg-promise")();
const db = pgp({
  host: process.env.DB_SERVER,
  port: process.env.DB_PORT,
  database: process.env.DB_USER,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
});

// Configure the server and its routes.
const express = require("express");
const app = express();
const port = process.env.PORT || 3000;
const router = express.Router();
router.use(express.json());

router.get("/", readHelloMessage);
router.get("/posts", readPosts); // Reads all the posts in the database in decsending order by posttime
router.get("/posts-details/posttime", readPostsPostTime); // Reads all the details about each post(information about post, restaurant, poster) in the database ordered by posttime
router.get("/posts/:id", readPost); //Reads all the information about a specific post
router.get("/posts-details/meetuptime", readPostsMeetUpTime); // Reads all the details about each post(information about post, restaurant, poster) in the database ordered by meetup time
router.get("/studentposts/:studentemail", readStudentPosts); //Reads all the posts made by a specific student
router.get("/students", readStudents); // Reads the list of all students
router.get("/restaurants", readRestaurants); // Reads the list of all restaurants
router.get("/students/:email", readStudent); //Reads information about a specific student
router.get("/attendees/:postid", readAttendees); // Reads the students that are attending a specific event(represented by the postid)
router.post("/posts", createPost); // Creates a post
router.post("/students", createStudent); // Creates a student
router.post("/attendees/:postid", createAttendee); // Creates a new record in the attendees table with a postid and a studentemail
router.put("/students/:email", updateStudent); // Updates information about a specific student (represented by the email)
router.delete("/posts/:id", deletePost); // Deletes a specific post

app.use(router);
app.use(errorHandler);
app.listen(port, () => console.log(`Listening on port ${port}`));

// Implement the CRUD operations.

function errorHandler(err, req, res) {
  if (app.get("env") === "development") {
    console.log(err);
  }
  res.sendStatus(err.status || 500);
}

function returnDataOr404(res, data) {
  if (data == null) {
    res.sendStatus(404);
  } else {
    res.send(data);
  }
}

// Returns a hello message
function readHelloMessage(req, res) {
  res.send("Hello, Knights! Welcome to Knight Bites!");
}

// Returns all the posts in the Post table
function readPosts(req, res, next) {
  db.manyOrNone("SELECT * FROM Post ORDER BY posttime DESC")
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

// Returns all the posts in the Post table alond with the related student information and restaurant information for each post sorted by post time
function readPostsPostTime(req, res, next) {
  db.manyOrNone(
    "SELECT * FROM Post, Student, Restaurant WHERE Post.studentEmail = Student.email AND Post.restaurantId = Restaurant.restaurantID ORDER BY posttime DESC"
  )
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

// Returns all the posts in the Post table alond with the related student information and restaurant information for each post sorted by meetup time
function readPostsMeetUpTime(req, res, next) {
  db.manyOrNone(
    "SELECT * FROM Post, Student, Restaurant WHERE Post.studentEmail = Student.email AND Post.restaurantId = Restaurant.restaurantID ORDER BY meetuptime ASC"
  )
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

// Takes in a post id and returns that post
function readPost(req, res, next) {
  db.oneOrNone("SELECT * FROM Post WHERE id=${id}", req.params)
    .then((data) => {
      returnDataOr404(res, data);
    })
    .catch((err) => {
      next(err);
    });
}

// Takes in the post title, post time, meetup time, student's email, and restaurant id, and creates a new post in the Post table
function createPost(req, res, next) {
  db.one(
    "INSERT INTO Post(postTitle, post, postTime, meetupTime, studentEmail, restaurantID) VALUES (${posttitle}, ${post}, ${posttime}, ${meetuptime}, ${studentemail}, ${restaurantid}) RETURNING studentemail",
    req.body
  )
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

// Takes in a student's email, firstname, lastname, year in college, bio, and profile icon name, and creates a new record in the Student table
function createStudent(req, res, next) {
  db.one(
    "INSERT INTO Student(email, firstname, lastname, collegeyear, bio, icon) VALUES (${email}, ${firstname}, ${lastname}, ${collegeyear}, ${bio}, ${icon}) RETURNING email",
    req.body
  )
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

// Takes in a postid and studentemail and creates a new record in the EventAttendee table
function createAttendee(req, res, next) {
  db.one(
    "INSERT INTO EventAttendee(postid, studentEmail) VALUES (${postid}, ${studentemail}) RETURNING postid",
    req.body
  )
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

// Takes in a post id and returns all the students signed up to that post
function readAttendees(req, res, next) {
  db.manyOrNone(
    "SELECT postid, studentEmail, firstname, lastname FROM EventAttendee, Student WHERE EventAttendee.studentEmail=Student.email AND postid = ${postid}",
    req.params
  )
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

// Takes in a student email and returns all the posts made by that student
function readStudentPosts(req, res, next) {
  db.manyOrNone(
    "SELECT * FROM Post, Student, Restaurant WHERE Post.studentEmail = Student.email AND Post.restaurantId = Restaurant.restaurantID AND Student.email=${studentemail} ORDER BY posttime DESC",
    req.params
  )
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

//Reads all the records in the Student table
function readStudents(req, res, next) {
  db.many("SELECT * FROM Student")
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

// Returns all the records in the Restaurant table in ascending order by name
function readRestaurants(req, res, next) {
  db.many("SELECT * FROM Restaurant ORDER BY restaurantname ASC")
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

// Takes in a student email and returns the student's record from the Student table
function readStudent(req, res, next) {
  db.oneOrNone("SELECT * FROM Student WHERE email=${email}", req.params)
    .then((data) => {
      returnDataOr404(res, data);
    })
    .catch((err) => {
      next(err);
    });
}

// Takes in student email and updates the record in the Student table
function updateStudent(req, res, next) {
  db.oneOrNone(
    "UPDATE student SET firstname=${body.firstname}, lastname=${body.lastname},collegeyear=${body.collegeyear}, bio=${body.bio} WHERE email=${params.email} RETURNING email",
    req
  )
    .then((data) => {
      returnDataOr404(res, data);
    })
    .catch((err) => {
      next(err);
    });
}

// Takes in a postid and deletes the post fromt the Post table
function deletePost(req, res, next) {
  db.oneOrNone("DELETE FROM Post WHERE id=${id} RETURNING id", req.params)
    .then((data) => {
      returnDataOr404(res, data);
    })
    .catch((err) => {
      next(err);
    });
}
