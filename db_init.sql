CREATE SCHEMA UniExams;

CREATE TABLE UniExams.Users (
    BadgeNumber VARCHAR(6) PRIMARY KEY CHECK (LENGTH(BadgeNumber) = 6),
    Name VARCHAR(128),
    Surname VARCHAR(128),
    BirthYear DATE,
    Email VARCHAR(128) UNIQUE,
    Password VARCHAR(256),
    Role VARCHAR(128) NOT NULL CHECK(Role = 'Student' OR Role = 'Teacher')
);

CREATE TABLE UniExams.Teacher (
    BadgeNumber VARCHAR(6) PRIMARY KEY CHECK (LENGTH(BadgeNumber) = 6),
    Faculty VARCHAR(128),
    FOREIGN KEY (BadgeNumber) REFERENCES UniExams.Users (BadgeNumber)
);

CREATE TABLE UniExams.Student (
    BadgeNumber VARCHAR(6) PRIMARY KEY CHECK (LENGTH(BadgeNumber) = 6),
    Faculty VARCHAR(128),
    CourseYear INTEGER CHECK (CourseYear < 4),
    FOREIGN KEY (BadgeNumber) REFERENCES UniExams.Users (BadgeNumber)
);

CREATE TABLE UniExams.Exam (
    IdExam SERIAL PRIMARY KEY,
    PassingDate DATE,
    StudentBadgeNumber VARCHAR(6),
    TeacherBadgeNumber VARCHAR(6),
    FOREIGN KEY (StudentBadgeNumber) REFERENCES UniExams.Student (BadgeNumber),
    FOREIGN KEY (TeacherBadgeNumber) REFERENCES UniExams.Teacher (BadgeNumber)
);

CREATE TABLE UniExams.Redact (
    TeacherBadgeNumber VARCHAR(6),
    ExamId INTEGER,
    CFU INTEGER,
    FOREIGN KEY (TeacherBadgeNumber) REFERENCES UniExams.Teacher (BadgeNumber),
    FOREIGN KEY (ExamId) REFERENCES UniExams.Exam (IdExam),
    PRIMARY KEY (TeacherBadgeNumber, ExamId)
);

CREATE TABLE UniExams.Test (
    idTest SERIAL PRIMARY KEY,
    Name VARCHAR(128),
    TestDate DATE,
    ExpirationDate DATE,
    Schedule TIME,
    Valid BOOLEAN,
    Vote INTEGER CHECK (Vote >= 18 AND Vote <= 31),
    Idoneus BOOLEAN,
    BonusPoints INTEGER CHECK (BonusPoints > 0),
    ExamId INTEGER,
    FOREIGN KEY (ExamId) REFERENCES UniExams.Exam (IdExam)
);
