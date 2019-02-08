DROP TABLE JobSeekers
DELETE FROM JobSeekers

DROP TABLE Vacancy
DELETE FROM Vacancy

CREATE TABLE JobSeekers (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    FIO VARCHAR(255) NOT NULL,
    birth_date DATE,
    specialty VARCHAR(255) NOT NULL
);
GO

CREATE TABLE Vacancy (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    company VARCHAR(255) NOT NULL,
    specialty VARCHAR(255) NOT NULL,
    salary INT NOT NULL
);
GO

INSERT INTO JobSeekers(FIO, birth_date, specialty) VALUES('Ivanov Ivan Ivanovich', '1990-09-25', 'JAVA-programmer')
INSERT INTO JobSeekers(FIO, birth_date, specialty) VALUES('Petrov Petr Petrovich', '1987-11-12', '1C-specialist')

INSERT INTO JobSeekers(FIO, birth_date, specialty) VALUES('asfdaf', '1990-09-25', 'jD')
INSERT INTO JobSeekers(FIO, birth_date, specialty) VALUES('qwretwry', '1987-11-12', 'jD')
INSERT INTO JobSeekers(FIO, birth_date, specialty) VALUES('asfdaf', '1990-09-25', 'jD')
INSERT INTO JobSeekers(FIO, birth_date, specialty) VALUES('rgthryj', '1987-11-12', 'jD')
INSERT INTO JobSeekers(FIO, birth_date, specialty) VALUES('dsvdbg', '1990-09-25', 'jD')
INSERT INTO JobSeekers(FIO, birth_date, specialty) VALUES('sdfvdv', '1987-11-12', 'jD')
INSERT INTO JobSeekers(FIO, birth_date, specialty) VALUES('ytjuk', '1990-09-25', 'jD')
INSERT INTO JobSeekers(FIO, birth_date, specialty) VALUES('rew', '1987-11-12', 'jD')


INSERT INTO Vacancy(company, specialty, salary) VALUES('OOO "Romashka"', 'jD', 30000)
INSERT INTO Vacancy(company, specialty, salary) VALUES('OAO "Vasilek"', 'Chief of department', 300000)

SELECT * FROM JobSeekers;
SELECT * FROM Vacancy;


SELECT * FROM Vacancy
WHERE salary > 10000 AND salary < 50000

SELECT J.FIO
FROM JobSeekers as J JOIN Vacancy AS V ON J.id = V.id
WHERE J.specialty != V.specialty

SELECT specialty, company
FROM Vacancy
WHERE (SELECT COUNT(*) FROM JobSeekers as J JOIN Vacancy AS V ON J.id = V.id WHERE J.specialty = V.specialty) > 5
