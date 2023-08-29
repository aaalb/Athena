-- Popolamento della tabella Users
INSERT INTO UniExams.Users (BadgeNumber, Name, Surname, BirthYear, Email, Password, Role)
VALUES
    ('B12345', 'John', 'Doe', '1990-01-01', 'john.doe@example.com', 'scrypt:32768:8:1$mKz7CYhVCz9OKp5d$c631e0252630a17bc3b7e0ee301bc2de8459ea0513e7fe61e52672553388acbb041c2c4ba7e16e5e619b0ecbb5180510f3cc12b069a2480d2e000db2dad8f462', 'Student'), //password123
    ('B23456', 'Jane', 'Smith', '1992-05-15', 'jane.smith@example.com', 'scrypt:32768:8:1$ZBFL6ALfOLYB7kk9$09afabd25e56ab0d163e0299d71a57dbff5f07c19db20990cfafff8cd6806ee97a43dec64fd24387c8054489bf2375636c4567022eb1a29693ef02901e9758af', 'Teacher'), //password456
    ('B34567', 'Michael', 'Johnson', '1985-09-10', 'michael.johnson@example.com', 'scrypt:32768:8:1$InF5HdDYQaMNoKo3$986c7795026afc9823acf9502a4f7436a9c973e1af81dc4ff81152c57d682cbcd098dfff518b8dc2f1f0c6c9fdb97762b3acaf0666ef1cd9a27a7cdcfb61a1a4', 'Student'), //password789
    ('B45678', 'Emily', 'Davis', '1993-07-20', 'emily.davis@example.com', 'scrypt:32768:8:1$vAYCJBnoDNGEgNsj$a799c3af5a1127a47258ee6a9abeba0cf488e7bb99586304d8e89942dc325f1206b1a44d634793e668fb8259138b62ed3f13795a2f10808b0096a1fa7f48a8fc', 'Teacher'), //password321
    ('B56789', 'David', 'Wilson', '1991-03-07', 'david.wilson@example.com', 'scrypt:32768:8:1$muvxMSyhC2KZ39uP$7d51e3c21743c29f824cc78afd34146d69e1edea6dff1a11acdee1d8aae8b1dc37b486fe5e4cbd86769864270a279cccdd472f481ec24e593dfb9e56d8e527fa', 'Student'), //password654
    ('B67890', 'Sarah', 'Brown', '1988-12-12', 'sarah.brown@example.com', 'scrypt:32768:8:1$aQ2qEYyhSe3wyID6$d3b9aae1e34d33b13a6bfdc9e268398cbe391e0e826097bac7f379efd3134f6e2a335e82970b5f95db4c00621bf665ca6843022e2b20b5e9b5924e4235d49287', 'Teacher'); //password987

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
