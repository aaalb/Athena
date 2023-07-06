CREATE SCHEMA UniExams;

CREATE TABLE UniExams.Teacher(
    BadgeNumber VARCHAR(6) PRIMARY KEY 
        CHECK (LENGTH(BadgeNumber) = 6),
    Name VARCHAR(128),
    Surname VARCHAR(128),
    BirthYear DATE
);

CREATE TABLE UniExams.Student(
    BadgeNumber VARCHAR(6) PRIMARY KEY 
        CHECK (LENGTH(BadgeNumber) = 6),
    Name VARCHAR(128),
    Surname VARCHAR(128),
    BirthYear DATE,
    Faculty VARCHAR(128),
    CourseYear INTEGER
        CHECK (CourseYear < 4)
);

CREATE TABLE UniExams.Exam(
    IdExam SERIAL PRIMARY KEY,
    PassingDate DATE,
    BadgeNumber FOREIGN KEY,

    BadgeNumber REFERENCES UniExams.Student(BadgeNumber)
);

CREATE TABLE UniExams.Redact(
    BadgeNumber FOREIGN KEY,
    IdExam FOREIGN KEY,

    BadgeNumber REFERENCES UniExams.Teacher(BadgeNumber),
    IdExam REFERENCES Uniexams.Exam(IdExam),
    PRIMARY KEY(BadgeNumber, IdExam)
);

CREATE TABLE UniExams.Test(
    idTest SERIAL,
    Name VARCHAR(128),
    TestDate DATE,
    ExpirationDate DATE,
    Valid BOOLEAN,
    Vote INTEGER CHECK (Vote >= 18 AND Vote <= 31),
    Idoneus BOOLEAN,
    BonusPoints INTEGER CHECK (BonusPoints > 0),
    IdExam FOREIGN KEY,

    IdExam REFERENCES UniExams.Exam(IdExam)
);
