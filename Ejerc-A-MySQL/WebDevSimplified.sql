/* Exercises from Web Dev Simplified Youtube channel. Please, visit his channel for more explications. */
/*  Web Dev Simplified Youtube video (Learn SQL): https://www.youtube.com/watch?v=p3qvj9hO_Bo */
/**************** Done in MySQL ****************/

-- CREATE DATABASE record_company;
USE record_company;

-- CREATE TABLE bands (
--   id INT NOT NULL AUTO_INCREMENT,
--   name VARCHAR(255) NOT NULL,
--   PRIMARY KEY (id)
-- );

-- CREATE TABLE albums (
--   id INT NOT NULL AUTO_INCREMENT,
--   name VARCHAR(255) NOT NULL,
--   release_year INT,
--   band_id INT NOT NULL,
--   PRIMARY KEY (id),
--   FOREIGN KEY (band_id) REFERENCES bands(id)
-- );

-- DROP TABLE songs;
-- CREATE TABLE songs(
-- 	id INT NOT NULL auto_increment,
--     name VARCHAR(255) NOT NULL,
--     length FLOAT NOT NULL,
--     album_id INT NOT NULL,
--     PRIMARY KEY(id),
--     FOREIGN KEY (album_id) REFERENCES albums(id)
-- );


-- 2. Select only the Names of all the Bands

SELECT Name AS 'Band Name'
FROM bands;

-- 3. Select the Oldest Album
SELECT *
FROM albums
WHERE release_year IS NOT NULL
ORDER BY release_year ASC
LIMIT 1;

-- 4. Get all Bands that have Albums
SELECT DISTINCT bands.name AS 'Band Name'
FROM bands
JOIN albums
ON bands.id = albums.band_id;

-- 5. Get all Bands that have No Albums
SELECT b.name AS 'Band Name'
FROM bands b
LEFT JOIN albums a
ON b.id = a.band_id
WHERE a.band_id IS NULL;

SELECT bands.name AS 'Band Name'
FROM bands
LEFT JOIN  albums
ON bands.id = albums.band_id
group by albums.band_id
HAVING COUNT(albums.id) = 0;

-- 6. Get the Longest Album
SELECT 		albums.name AS 'Name',
			albums.release_year AS 'Release year',
            SUM(songs.length) AS 'Duration'

FROM albums
JOIN songs
ON albums.id = songs.album_id
GROUP BY albums.id
ORDER BY Duration DESC
LIMIT 1;

-- 7. Update the Release Year of the Album with no Release Year
-- Set the release year to 1986.
SELECT *
FROM albums
WHERE release_year IS NULL;

UPDATE albums
SET release_year = 1986
WHERE id = 4; -- Para que solo actualice la fila que quiero

-- 8. Insert a record for your favorite Band and one of their Albums
-- 1ero BAND xq para ingresar en album, debo colocar una banda primero
INSERT INTO bands (name)
VALUES ('Imagine Dragons');

SELECT *from bands
order by id DESC;

INSERT INTO albums(name, release_year, band_id)
VALUES('Evolve', 2017, 8);

-- 9. Delete the Band and Album you added in #8
DELETE FROM albums
WHERE id = 19;

DELETE FROM bands
WHERE id = 8;

SELECT * FROM bands;

-- 10. Get the Average Length of all Songs
SELECT AVG(length) AS 'Average Song Duration'
FROM songs;

-- 11. Select the longest Song off each Album
SELECT 
		albums.name AS 'Album', 
        albums.release_year AS 'Release year',
        MAX(songs.length) AS 'Duration'
FROM albums
JOIN songs
ON albums.id = songs.album_id
GROUP BY Album;
-- ORDER BY Duration DESC;

-- 12. Get the number of Songs for each Band 
SELECT
		bands.name AS 'Band',
        COUNT(songs.id) AS 'Number of Songs'
FROM bands
JOIN albums ON bands.id = albums.band_id
JOIN songs ON albums.id = songs.album_id
GROUP BY albums.band_id;



