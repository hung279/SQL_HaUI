USE master
GO	
If(Exists(Select * From SysDatabases Where Name='MarkManagement '))
Drop Database MarkManagement 
GO
CREATE DATABASE MarkManagement 
GO
USE MarkManagement 
GO
CREATE TABLE Students(
StudentID Nvarchar(12) PRIMARY KEY,
StudentName Nvarchar(25) NOT NULL,
DateofBirth Datetime NOT NULL,
Email Nvarchar(40),
Phone Nvarchar(12),
Class Nvarchar(10)
)

CREATE TABLE Subjects(
SubjectID Nvarchar(10) PRIMARY KEY,
SubjectName Nvarchar(25) NOT NULL
)

CREATE TABLE Mark
(
StudentID Nvarchar(12),
SubjectID Nvarchar(10),
Theory Tinyint,
Practical Tinyint,
Date Datetime
CONSTRAINT PK_Mark PRIMARY KEY (StudentID,SubjectID)
)

INSERT INTO Students VALUES
('AV0807005', N'Mail Trung Hi?u' ,'1989/10/11', 'trunghieu@yahoo.com' ,0904115116,'AV1'),
('AV0807006' ,N'Nguy?n Quý Hùng' ,'1988/12/2' ,'quyhung@yahoo.com' ,0955667787, 'AV2'),
('AV0807007' ,N'?? ??c Hu?nh' ,'1990/1/2' ,'dachuynh@yahoo.com', 0988574747, 'AV2'),
('AV0807009' ,N'An ??ng Khuê' ,'1986/3/6' ,'dangkhue@yahoo.com', 0986757463 ,'AV1'),
('AV0807010', N'Nguy?n T. Tuy?t Lan' ,'1989/7/12', 'tuyetlan@gmail.com', 0983310342, 'AV2'),
('AV0807011', N'?inh Ph?ng Long' , '1990/12/2' ,'phunglong@yahoo.com',null ,'AV1'),
('AV0807012', N'Nguy?n Tu?n Nam' ,'1990/3/2' ,'tuannam@yahoo.com',null ,'AV1')

INSERT INTO Subjects VALUES
('S001' ,'SQL'),
('S002' ,'Java Simplefield'),
('S003' ,'Active Server Page')


INSERT INTO Mark VALUES
('AV0807005', 'S001',8,25, '2008/5/6'),
('AV0807006' ,'S002',16,30, '2008/5/6'),
('AV0807007' ,'S001',10,25,'2008/5/6'),
('AV0807008' ,'S003',7,13, '2008/5/6'),
('AV0807011' ,'S002',8,30,'2008/5/6'),
('AV0807012' ,'S001',7,31,'2008/5/6'),
('AV0807005' ,'S002',12,11,'2008/6/6'),
('AV0807009' ,'S003',11,20,'2008/6/6'),
('AV0807010' ,'S001',7,6,'2008/6/6')
GO
--1
SELECT * FROM Students
--2
SELECT * 
FROM Students
WHERE Class = 'AV1'
--3
UPDATE Students
SET Class = 'AV2' 
WHERE StudentID = 'AV0807012'
--4
SELECT Class , COUNT(StudentID) AS 'So sinh vien' 
FROM Students
GROUP BY Class
--5
SELECT *
FROM Students
WHERE Class = 'AV2'
ORDER BY StudentName ASC

--6
SELECT *
FROM MARK M
INNER JOIN Students S ON S.StudentID = M.StudentID
WHERE SubjectID ='S001' AND theory <10 AND Date = '2008/5/6'
--7
SELECT COUNT(StudentID) AS 'SO SINH VIEN K DAT LY THUYET MON S001'
FROM Mark
WHERE SubjectID = 'S001' AND theory <10
--8
SELECT *
FROM Students
WHERE DateofBirth > 1980/1/1
--9
DELETE FROM Students
WHERE StudentID = 'AV0807011'
--check
SELECT * FROM Students
--10
SELECT  S.StudentID, StudentName, SubjectName, Theory, Practical,Date
FROM Students S 
INNER JOIN Mark M ON S.StudentID = M.StudentID
INNER JOIN Subjects SJ ON SJ.SubjectID = M.SubjectID
WHERE SJ.SubjectID = 'S001' and Date = '2008/5/6'
 