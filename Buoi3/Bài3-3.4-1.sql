USE master
GO	
If(Exists(Select * From SysDatabases Where Name='DeptEmp'))
Drop Database DeptEmp
GO
CREATE DATABASE DeptEmp
GO
USE DeptEmp
GO
CREATE TABLE  Department(
DepartmentNo Integer  PRIMARY KEY ,
DepartmentName Char(25)  NOT NULL,
Location Char(25)  NOT NULL
 )

GO
CREATE TABLE  Employee
(
EmpNo Integer  PRIMARY KEY ,
Fname varchar(15)  NOT NULL,
Lname Varchar(15)  NOT NULL,
Job Varchar(25)  NOT NULL,
HireDate Datetime  NOT NULL,
Salary Numeric  NOT NULL,
Commision Numeric,
DepartmentNo Integer FOREIGN KEY REFERENCES Department(DepartmentNo)

)

INSERT INTO Department VALUES
(10,'Accounting','Melbourne'),
(20,'Research','Adealide'),
(30,'Sales','Sydney'),
(40,'Operations','Perth')


INSERT INTO Employee VALUES
(1 ,'John' ,'Smith' ,'Clerk' ,'1980-12-17' ,800, null ,20),
(2, 'Peter' ,'Allen' ,'Salesman', '1981-11-20' ,1600 ,300 ,30),
(3 ,'Kate', 'Ward' ,'Salesman', '1981-11-22' ,1250 ,500,30),
(4 ,'Jack' ,'Jones','Manager','1981-07-02' ,2975 ,null ,20),
(5 ,'Joe','Martin' ,'Salesman' ,'1981-09-28' ,1250 ,1400 ,30)
--1
SELECT * FROM Department
--2
SELECT * FROM Employee
--3
SELECT EmpNo,Fname,Lname
FROM Employee
WHERE Fname = 'Kate'
--4
SELECT (Fname+Lname) AS 'FULL NAME',Salary, (Salary+0.1*Salary) AS 'Tang 10% luong'
FROM Employee

--5
SELECT Fname, Lname, HireDate
FROM Employee
WHERE YEAR(HireDate) = '1981'
--6
SELECT DepartmentNo, AVG(salary) AS 'LUONG TB',MIN(salary) AS 'LUONG MIN',MAX(salary) AS 'LUONG MAX'
FROM Employee
GROUP BY DepartmentNo
--7
SELECT DepartmentNo ,COUNT(EmpNo) AS 'SO NHAN VIEN '
FROM Employee
GROUP BY DepartmentNo
--8

SELECT  D.DepartmentNo,DepartmentName, 'FullName' = (Fname + Lname),Job, Salary
FROM Department D 
INNER JOIN Employee E ON D.DepartmentNo = E.DepartmentNo
--9
SELECT D.DepartmentNo, DepartmentName, Location , COUNT(EmpNo) AS 'SO NHAN VIEN'
FROM Department D 
INNER JOIN Employee E ON D.DepartmentNo = E.DepartmentNo
GROUP BY D.DepartmentNo, DepartmentName, Location

--10
SELECT D.DepartmentNo, DepartmentName, Location , COUNT(EmpNo) AS 'SO NHAN VIEN'
FROM Department D
FULL JOIN Employee E ON E.DepartmentNo = D.DepartmentNo
GROUP BY D.DepartmentNo, DepartmentName, Location