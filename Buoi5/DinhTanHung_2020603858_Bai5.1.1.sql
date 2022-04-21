use master
go
create database QLKHO
go

use QLKHO
go

create table Ton(
	MaVT varchar(10) not null primary key,
	TenVT nvarchar(50) not null,
	SoLuongT int
)
go

create table Nhap(
	SoHDN varchar(10) not null,
	MaVT varchar(10) not null,
	SoLuongN int,
	DonGiaN decimal(10, 2),
	NgayN Datetime,
	constraint PK_N_T primary key(SoHDN, MaVT),
	constraint FK_N_T foreign key(MaVT)
		references Ton(MaVT)
)
go

create table Xuat(
	SoHDX varchar(10) not null,
	MaVT varchar(10) not null,
	SoLuongX int,
	DonGiaX decimal(10, 2),
	NgayX Datetime,
	constraint PK_X_T primary key(SoHDX, MaVT),
	constraint FK_X_T foreign key(MaVT)
		references Ton(MaVT)
)
go

select * from Ton
select * from Nhap
select * from Xuat
go

--câu 2
create view tb_vt
as
select Ton.MaVT, TenVT, Sum(SoLuongX * DonGiaX) as N'Tiền Bán'
from Xuat
	inner join Ton
		on Xuat.MaVT = Ton.MaVT
group by Ton.MaVT, TenVT
go

select * from tb_vt
go

--câu 3
create view SoLuongXuat
as
select TenVT, sum(SoLuongX * DonGiaX) as N'Tổng SLX'
from Xuat
	inner join Ton
		on Xuat.MaVT = Ton.MaVT
group by Ton.MaVT, TenVT
go

select * from SoLuongXuat
go

--câu 4
create view SoLuongNhap
as
select TenVT, sum(SoLuongN * DonGiaN) as N'Tổng SLN'
from Nhap
	inner join Ton
		on Nhap.MaVT = Ton.MaVT
group by Ton.MaVT, TenVT
go

select * from SoLuongNhap
go

--câu 5
create view TonKho
as
select Ton.MaVT, TenVT, sum(SoLuongN) - sum(SoLuongX) + sum(SoLuongT) as N'Tồn kho còn'
from Nhap
	inner join Ton
		on Nhap.MaVT = Ton.MaVT
	inner join XUat
		on Xuat.MaVT = Ton.MaVT
group by Ton.MaVT, TenVT
go

select * from TonKho
go

drop view TonKho
go
delete from Ton
from Nhap
where Ton.MaVT = Nhap.MaVT
      and Ton.MaVT in (select Nhap.MaVT
						from Nhap
							inner join Xuat
								on Nhap.MaVT = Xuat.MaVT
							where DonGiaX < DonGiaN)