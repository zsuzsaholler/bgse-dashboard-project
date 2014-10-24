
CREATE DATABASE MyApp;

USE MyApp;

CREATE TABLE sample(
    id        INT NOT NULL AUTO_INCREMENT,
    name      CHAR(32) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE data(
    sample_id INT NOT NULL,
    x         REAL NOT NULL,
    y         REAL NOT NULL
);

