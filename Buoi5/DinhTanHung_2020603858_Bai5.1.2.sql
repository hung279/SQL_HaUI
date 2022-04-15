use master
go

create database QLSV
go

use QLSV
go

create table Lop (
	MaLop int not null primary key,
	TenLop varchar(20) not null,
	Phong int
)
go

create table SV (
	MaSV int not null primary key,
	TenSV nvarchar(30) not null,
	MaLop int not null,
	constraint FK_SV_LOP foreign key(MaLop)
		references Lop(MaLop)
)
go

insert into Lop values
(1, 'CD', 1),
(2, 'DH', 2),
(3, 'LT', 2),
(4, 'CH', 4)
go

insert into SV values
(1, 'A', 1),
(2, 'B', 2),
(3, 'C', 1),
(4, 'D', 3)
go

select * from Lop
select * from SV
go

--1
create function thongke(@malop int)
returns int
as
begin
	declare @sl int
	select @sl = count(SV.MaSV)
	from SV
		inner join Lop
			on SV.MaLop = Lop.MaLop
	where Lop.MaLop = @malop
	group by Lop.TenLop
	return @sl
end
go
select dbo.thongke(1) as 'So luong SV'
go
--2
create function DSSV(@malop int, @tenlop nvarchar(30))
returns table
as
return
	select SV.MaSV, TenSV
	from SV
		inner join Lop
			on SV.MaLop = Lop.MaLop
	where Lop.MaLop = @malop and TenLop = @tenlop
go
select * from DSSV(1, 'CD')
go
--3
create function Ham_ThongKe(@tenlop nvarchar(30))
returns @thongke table (
		malop int,
		tenlop nvarchar(30),
		soluongsv int
)
begin
	if(not exists(select MaLop from Lop where TenLop = @tenlop))
		insert into @thongke
			select Lop.*, count(SV.MaSV) as N'Số lượng sv'
			from Lop
				inner join SV
					on Lop.MaLop = SV.MaLop
			group by Lop.MaLop, TenLop
	else
		insert into @thongke
			select Lop.*, count(SV.MaSV) as N'Số lượng sv'
			from Lop
				inner join SV
					on Lop.MaLop = SV.MaLop
			where TenLop = @tenlop
			group by Lop.MaLop, TenLop
	return
end
go

select * from dbo.Ham_ThongKe('CD');