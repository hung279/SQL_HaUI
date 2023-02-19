use master
go

create database QLSV
go

use QLSV
go

create table SV (
	MaSV int not null primary key,
	TenSV nvarchar(30) not null,
	Que nvarchar(30),
)
go

create table MON (
	MaMH int not null primary key,
	TenMH nvarchar(20) not null,
	Sotc int
)
go

create table KQ(
	MaSV int not null,
	MaMH int not null,
	Diem float,
	constraint PK_MaSV_MaMH primary key(MaSV, MaMH),
	constraint FK_SV_MON foreign key(MaSV)
		references SV(MaSV),
	constraint FK_MON_KQ foreign key(MaMH)
		references MON(MaMH)
)

insert into SV values
(1, 'A', N'Hà Nội'),
(2, 'B', N'Hà Nội'),
(3, 'C', N'Hà Nam')
go

insert into MON values
(1, 'CSDL', 3),
(2, 'Java', 3),
(3, 'PHP', 4)
go

insert into KQ values
(1, 2, 8.2),
(2, 1, 7.2),
(1, 1, 10),
(2, 3, 10),
(3, 3, 5.3),
(2, 2, 6.5)


--2.
SELECT MaMH, TenMH, Sotc
FROM MON
WHERE MaMH not in (SELECT MaMH FROM KQ
						WHERE Diem = 10.0)
go
--3
CREATE VIEW Cau_4
AS
	SELECT MON.MaMH, COUNT(MaSV) sl
	FROM MON
		INNER JOIN KQ on MON.MaMH = KQ.MaMH
	GROUP BY MON.MaMH
go
DROP VIEW Cau_4
Select * from Cau_4

SELECT TenMH FROM MON
WHERE MaMH in (SELECT MaMH FROM Cau_4
				WHERE sl = 3)

go
--5
CREATE FUNCTION So_SV_Cung_Que(@que nvarchar(30))
RETURNS int
AS
BEGIN
	DECLARE @sl int
		SET @sl = (SELECT COUNT(MaSV) FROM SV
					WHERE Que = @que
					group by que)
	RETURN @sl
END
go
DROP FUNCTION dbo.So_SV_Cung_Que
SELECT dbo.So_SV_Cung_Que(N'Hà Nam') as N'So luong'