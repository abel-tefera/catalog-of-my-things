-- Create music_albums table
CREATE TABLE music_albums (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  genre_id INT REFERENCES genre(id) ON UPDATE CASCADE ON DELETE CASCADE,
  publish_data DATE NOT NULL,
  archived BIT NOT NULL,
  on_spotify BIT NOT NULL
);

-- Create genres table
CREATE TABLE genres (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  genre_name VARCHAR(50) NOT NULL,
);

CREATE INDEX genre_idx ON music_albums (genre_id);