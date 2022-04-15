use master
go

create database DeptEmp
on primary(
	name = 'DeptEmp',
	filename = '.\DeptEmp.mdf',
	size = 10mb,
	maxsize = 50mb,
	filegrowth = 10mb
)

log on(
	name = 'DeptEmp_log',
	filename = '.\DeptEmp.ldf',
	size = 10mb,
	maxsize = 50mb,
	filegrowth = 10mb
)

go

use DeptEmp

create table Department (
	DepartmentNo int not null primary key,
	DepartmentName char(25) not null,
	Location char(25) not null
)
go

create table Employee (
	EmpNo int not null primary key,
	Fname varchar(15) not null,
	Lname varchar(15) not null,
	Job varchar(25) not null,
	HireDate datetime not null,
	Salary numeric not null,
	Commision numeric,
	DepartmentNo int not null,
	constraint FK_Employee_De foreign key(DepartmentNo)
		references Department(DepartmentNo),
)
go


insert into Department values
	(10, 'Accounting', 'Melbourne'),
	(20, 'Research', 'Adealide'),
	(30, 'Sales', 'Sydney'),
	(40, 'Operations', 'Perth')
go

insert into Employee values
	(1, 'John', 'Smith', 'Clerk', '17-Dec-1980', 800, null, 20),
	(2, 'Peter', 'Allen', 'Salesman', '20-Feb-1981', 1600, 300, 30),
	(3, 'Kate', 'Ward', 'Salesman', '22-Feb-1981', 1250, 500, 30),
	(4, 'Jack', 'Jones', 'Manager', '02-Apr-1981', 2975, null, 20),
	(5, 'Joe', 'Martin', 'Salesman', '28-Sep-1981', 1250, 1400, 30)
go


--1, 2
select * from Department
select * from Employee
--3.Hiển thị employee number, employee first name và employee last name từ
--bảng Employee mà employee first name có tên là ‘Kate’.

select EmpNo, Fname, Lname
from Employee
where Fname = 'Kate'

go
--4. Hiển thị ghép 2 trường Fname và Lname thành Full Name, Salary,
--10%Salary (tăng 10% so với lương ban đầu).

select Fname + ' ' + Lname as 'Full Name', Salary, Salary+0.1*Salary as 'New Salary'
from Employee
go
--5. Hiển thị Fname, Lname, HireDate cho tất cả các Employee có HireDate là
--năm 1981 và sắp xếp theo thứ tự tăng dần của Lname.

select Fname, Lname, HireDate
from Employee
where YEAR(HireDate) = 1981
order by Lname
go
--6. Hiển thị trung bình(average), lớn nhất (max) và nhỏ nhất(min) của
--lương(salary) cho từng phòng ban trong bảng Employee.

select AVG(Salary) as 'Average', MAX(Salary) as 'Max', MIN(Salary) as 'Min'
from Employee
group by DepartmentNo
go
--7. Hiển thị DepartmentNo và số người có trong từng phòng ban có trong bảngEmployee.

select DepartmentNo, COUNT(EmpNo) as 'Quantity Person'
from Employee
group by DepartmentNo
go
--8. Hiển thị DepartmentNo, DepartmentName, FullName (Fname và Lname),
--Job, Salary trong bảng Department và bảng Employee.

select Employee.DepartmentNo, DepartmentName, Fname + ' ' + Lname as 'Full Name', Job, Salary
from Employee
inner join Department
	on Employee.DepartmentNo = Department.DepartmentNo

go
--9. Hiển thị DepartmentNo, DepartmentName, Location và số người có trong
--từng phòng ban của bảng Department và bảng Employee.

select Department.DepartmentNo, DepartmentName, Location, COUNT(EmpNo) as 'Quantity'
from Employee
inner join Department
	on Employee.DepartmentNo = Department.DepartmentNo
group by Department.DepartmentNo, DepartmentName, Location

go
--10. Hiển thị tất cả DepartmentNo, DepartmentName, Location và số người có
--trong từng phòng ban của bảng Department và bảng Employee

select Department.DepartmentNo, DepartmentName, Location, COUNT(EmpNo) as 'Quantity'
from Employee
full join Department
	on Employee.DepartmentNo = Department.DepartmentNo
group by Department.DepartmentNo, DepartmentName, Location

go