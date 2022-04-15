use master
go

create database MarkManagement
on primary(
	name = 'MarkManagement',
	filename = 'E:\SQL\Buoi2\MarkManagement.mdf',
	size = 10mb,
	maxsize = 50mb,
	filegrowth = 10mb
)

log on(
	name = 'MarkManagement_log',
	filename = 'E:\SQL\Buoi2\MarkManagement.ldf',
	size = 10mb,
	maxsize = 50mb,
	filegrowth = 10mb
)

go
use MarkManagement

create table Students (
	StudentID nvarchar(12) not null primary key,
	StudentName nvarchar(25) not null,
	DateOfBirth datetime not null,
	Email nvarchar(40),
	Phone nvarchar(12),
	Class nvarchar(10)
)

create table Subjects (
	SubjectID nvarchar(10) not null primary key,
	SubjectName nvarchar(25) not null
)

create table Mark (
	StudentID nvarchar(12) not null,
	SubjectID nvarchar(10) not null,
	Date datetime,
	Theory tinyint,
	practical tinyint
	constraint PK_Mark primary key (StudentID, SubjectID),
	constraint FK_Mark_StID foreign key(StudentID)
		references Students(StudentID),
	constraint FK_Mark_SuID foreign key(SubjectID)
		references Subjects(SubjectID),
)


insert into Subjects values
	('S001', 'SQL'),
	('S002', 'Java Simplefield'),
	('S003', 'Active Server Page')

insert into Students values
	('AV0807005', N'Mai Trung Hiếu', '11-10-1989', 'trunghieu@yahoo.com', '0904115116', 'AV1'),
	('AV0807006', N'Nguyễn Quý Hùng', '2-12-1988', 'quyhung@yahoo.com', '0955667787 ', 'AV2'),
	('AV0807007', N'Đỗ Đắc Huỳnh', '2-1-1990', 'dachuynh@yahoo.com', '0988574747', 'AV2'),
	('AV0807009', N'An Đăng Khuê', '6-3-1986', 'dangkhue@yahoo.com', '0986757463', 'AV1'),
	('AV0807010', N'Nguyễn T. Tuyết Lan', '12-7-1989', 'tuyetlan@yahoo.com', '0983310342', 'AV2'),
	('AV0807011', N'Đinh Phụng Long', '2-12-1990', 'phunglong@yahoo.com', null, 'AV1'),
	('AV0807012', N'Nguyễn Tuấn Nam', '2-3-1990', 'tuannam@yahoo.com', null, 'AV1')

insert into Mark values
	('AV0807005', 'S001', '6-5-2008', 8, 25),
	('AV0807006', 'S002', '6-5-2008', 16, 30),
	('AV0807007', 'S001', '6-5-2008', 10, 25),
	('AV0807009', 'S003', '6-5-2008', 7, 13),
	('AV0807010', 'S003', '6-5-2008', 9, 16),
	('AV0807011', 'S002', '6-5-2008', 8, 30),
	('AV0807012', 'S001', '6-5-2008', 7, 31),
	('AV0807005', 'S002', '6-6-2008', 12, 11),
	('AV0807010', 'S001', '6-6-2008', 7, 6)

go


select * from Students
select * from Subjects
select * from Mark

--2. Hiển thị nội dung danh sách sinh viên lớp AV1
select * 
from Students
where Class = 'AV1'
--3. Sử dụng lệnh UPDATE để chuyển sinh viên có mã AV0807012 sang lớp AV2
UPDATE Students
SET Class = 'AV2' 
WHERE StudentID = 'AV0807012'
--4. Tính tổng số sinh viên của từng lớp
SELECT Class , COUNT(StudentID) AS 'Sum' 
FROM Students
GROUP BY Class
--5. Hiển thị danh sách sinh viên lớp AV2 được sắp xếp tăng dần theo StudentName
SELECT *
FROM Students
WHERE Class = 'AV2'
ORDER BY StudentName
--6. Hiển thị danh sách sinh viên không đạt lý thuyết môn S001 (theory <10) thi ngày 6/5/2008
SELECT *
FROM MARK M
INNER JOIN Students S ON S.StudentID = M.StudentID
WHERE SubjectID ='S001' AND theory <10 AND Date = '2008-5-6'
--7. Hiển thị tổng số sinh viên không đạt lý thuyết môn S001. (theory <10)
SELECT COUNT(StudentID) AS 'Failed S001'
FROM Mark
WHERE SubjectID = 'S001' AND theory <10
--8. Hiển thị Danh sách sinh viên học lớp AV1 và sinh sau ngày 1/1/1980
SELECT *
FROM Students
WHERE DateofBirth > 1980/1/1
--9. Xoá sinh viên có mã AV0807011
DELETE 
FROM Students
WHERE EXISTS (select *
					from Mark
					where Students.StudentID = Mark.StudentID
						and Students.StudentID = 'AV0807011')
--10.Hiển thị danh sách sinh viên dự thi môn có mã S001 ngày 6/5/2008 bao gồm
--các trường sau: StudentID, StudentName, SubjectName, Theory, Practical, Date
SELECT  S.StudentID, StudentName, SubjectName, Theory, Practical,Date
FROM Students S 
INNER JOIN Mark M ON S.StudentID = M.StudentID
INNER JOIN Subjects SJ ON SJ.SubjectID = M.SubjectID
WHERE SJ.SubjectID = 'S001' and Date = '2008/5/6'