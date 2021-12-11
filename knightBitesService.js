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
router.get("/posts", readPosts);
router.get("/posts-details/posttime", readPostsPostTime);
router.get("/posts-details/meetuptime", readPostsMeetUpTime);
router.get("/posts/:id", readPost);
router.post("/posts", createPost);
router.get("/students", readStudents);
router.get("/students/:email", readStudent);
router.post("/students", createStudent);
router.get("/restaurants", readRestaurants);
router.get("/events", readEvents);
router.post("/attendees/:postid", createAttendee);
router.get("/attendees/:postid", readAttendees);
// router.put("/players/:id", updatePlayer);
// router.post('/players', createPlayer);
router.delete("/posts/:id", deletePost);

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

function readHelloMessage(req, res) {
  res.send("Hello, Knights! Welcome to Knight Bites!");
}

function readPosts(req, res, next) {
  db.manyOrNone("SELECT * FROM Post ORDER BY posttime DESC")
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

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

function readPost(req, res, next) {
  db.oneOrNone("SELECT * FROM Post WHERE id=${id}", req.params)
    .then((data) => {
      returnDataOr404(res, data);
    })
    .catch((err) => {
      next(err);
    });
}

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

function createAttendee(req, res, next) {
  db.one(
    "INSERT INTO EventAttendee(postid, studentEmail) VALUES (${postid}, ${studentemail})",
    req.body
  )
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

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

function readEvents(req, res, next) {
  db.many("SELECT * FROM EventAttendee ORDER BY postID")
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

function readStudents(req, res, next) {
  db.many("SELECT * FROM Student")
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

function readRestaurants(req, res, next) {
  db.many("SELECT * FROM Restaurant")
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

function readStudent(req, res, next) {
  db.oneOrNone("SELECT * FROM Student WHERE email=${email}", req.params)
    .then((data) => {
      returnDataOr404(res, data);
    })
    .catch((err) => {
      next(err);
    });
}

function updatePlayer(req, res, next) {
  db.oneOrNone(
    "UPDATE Player SET email=${body.email}, name=${body.name} WHERE id=${params.id} RETURNING id",
    req
  )
    .then((data) => {
      returnDataOr404(res, data);
    })
    .catch((err) => {
      next(err);
    });
}

function createPlayer(req, res, next) {
  db.one(
    "INSERT INTO Player(email, name) VALUES (${email}, ${name}) RETURNING id",
    req.body
  )
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      next(err);
    });
}

function deletePost(req, res, next) {
  db.oneOrNone("DELETE FROM Post WHERE id=${id} RETURNING id", req.params)
    .then((data) => {
      returnDataOr404(res, data);
    })
    .catch((err) => {
      next(err);
    });
}
