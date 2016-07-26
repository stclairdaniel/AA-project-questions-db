DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL

);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  user_id INTEGER,
  question_id INTEGER

);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  parent_reply_id INTEGER,
  question_id INTEGER NOT NULL,
  author_id INTEGER NOT NULL,


  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Axel', 'Larson'),
  ('Dan', 'St. Clair'),
  ('Bob', 'the Builder');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Post1', 'Body1', 1),
  ('Post2', 'Body2', 2),
  ('Post3', 'Body3', 3),
  ('Post4', 'Body4', 1);

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (2, 1),
  (2, 2),
  (3, 1);

INSERT INTO
  replies (body, parent_reply_id, question_id, author_id)
VALUES
  ('Reply1 from Dan', NULL, 1, 2),
  ('Reply1 from Axel', 1, 1, 1);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (2, 1),
  (2, 2),
  (3, 1);
