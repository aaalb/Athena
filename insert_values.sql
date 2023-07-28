-- Popolamento della tabella Users
INSERT INTO UniExams.Users (BadgeNumber, Name, Surname, BirthYear, Email, Password, Role)
VALUES
    ('B12345', 'John', 'Doe', '1990-01-01', 'john.doe@example.com', 'password123', 'Student'),
    ('B23456', 'Jane', 'Smith', '1992-05-15', 'jane.smith@example.com', 'password456', 'Teacher'),
    ('B34567', 'Michael', 'Johnson', '1985-09-10', 'michael.johnson@example.com', 'password789', 'Student'),
    ('B45678', 'Emily', 'Davis', '1993-07-20', 'emily.davis@example.com', 'password321', 'Teacher'),
    ('B56789', 'David', 'Wilson', '1991-03-07', 'david.wilson@example.com', 'password654', 'Student'),
    ('B67890', 'Sarah', 'Brown', '1988-12-12', 'sarah.brown@example.com', 'password987', 'Teacher');

-- Popolamento della tabella Teacher
INSERT INTO UniExams.Teacher (BadgeNumber, Faculty)
VALUES
    ('B23456', 'Computer Science'),
    ('B45678', 'Mathematics'),
    ('B67890', 'Physics');

-- Popolamento della tabella Student
INSERT INTO UniExams.Student (BadgeNumber, Faculty, CourseYear)
VALUES
    ('B12345', 'Computer Science', 2),
    ('B34567', 'Mathematics', 1),
    ('B56789', 'Physics', 3);

-- Popolamento della tabella Exam
INSERT INTO UniExams.Exam (PassingDate, StudentBadgeNumber, TeacherBadgeNumber)
VALUES
    ('2023-01-15', 'B12345', 'B23456'),
    ('2023-02-20', 'B34567', 'B45678'),
    ('2023-03-10', 'B56789', 'B67890');

-- Popolamento della tabella Redact
INSERT INTO UniExams.Redact (TeacherBadgeNumber, ExamId)
VALUES
    ('B23456', 1),
    ('B45678', 2),
    ('B67890', 3);

-- Popolamento della tabella Test
INSERT INTO UniExams.Test (Name, TestDate, ExpirationDate, Valid, Vote, Idoneus, BonusPoints, ExamId)
VALUES
    ('Test 1', '2023-01-20', '2023-01-25', true, 20, true, 1, 1),
    ('Test 2', '2023-02-25', '2023-03-01', true, 25, false, 2, 2),
    ('Test 3', '2023-03-15', '2023-03-20', true, 28, true, 3, 3);
