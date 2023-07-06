-- create table games
CREATE TABLE games (
  id SERIAL PRIMARY KEY,
  publish_date DATE,
  multiplayer INT,
  last_played_at DATE,
  archived BOOLEAN,
  author_id INT,
  FOREIGN KEY (author_id) REFERENCES authors(id)
  
);

-- create table authors
CREATE TABLE authors (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(255),
  last_name VARCHAR(255),

);

-- Add index to the author id columns in games table
CREATE INDEX ix_author ON games(author_id);
