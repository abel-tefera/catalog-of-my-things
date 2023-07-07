CREATE DATABASE CATALOG;

CREATE TABLE books(
    id Int generated always as identity,
    publisher  varchar(255) ,
    cover_state  varchar(255),
    publish_date  date,
    archived  boolean,
    label_id  Int,
    CONSTRAINT fk_label FOREIGN KEY (label_id) REFERENCES labels(id),
    PRIMARY KEY (id)
);

CREATE TABLE labels(
    id int generated always as identity,
    title varchar(255),
    color varchar(255),
    primary key (id)
);

CREATE INDEX label_idx ON books (label_id);

-- Create music_albums table
CREATE TABLE music_albums (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  genre_id INT REFERENCES genre(id) ON UPDATE CASCADE ON DELETE CASCADE,
  publish_data DATE NOT NULL,
  archived BOOLEAN NOT NULL,
  on_spotify BOOLEAN NOT NULL
);

-- Create genres table
CREATE TABLE genres (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  genre_name VARCHAR(50) NOT NULL,
);

CREATE INDEX genre_idx ON music_albums (genre_id);

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