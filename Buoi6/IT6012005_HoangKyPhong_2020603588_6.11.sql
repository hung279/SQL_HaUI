create database QLKHO

use QLKHO

create table Ton
(
	MaVT char(20) primary key,
	TenVT char(30),
	SoLuongT int
)

create table Nhap
(
	SoHDN char(10),
	MaVT char(20),
	SoLuongN int,
	DonGiaN float,
	NgayN date,

	constraint pk_nhap primary key (SoHDN, MaVT),
	constraint fk_nhap foreign key (MaVT) references Ton(MaVT)
)
--drop table Nhap

create table Xuat
(
	SoHDX char(10),
	MaVT char(20),
	SoLuongX int,
	DonGiaX float,
	NgayX date,

	constraint pk_xuat primary key (SoHDX, MaVT),
	constraint fk_xuat foreign key (MaVT) references Ton(MaVT)
)
--drop table Xuat

insert into Ton values 
('01','Ton1',1),
('02','Ton2',7),
('03','Ton3',3),
('04','Ton4',5),
('05','Ton5',2)

insert into Nhap values
('N01','01',20,100,'01/04/2022'),
('N02','03',15,80,'02/04/2022'),
('N03','05',6,130,'03/04/2022')

insert into Xuat values
('X01','01',20,300,'04/04/2022'),
('X02','03',15,170,'05/04/2022')

delete from Ton from Nhap 
inner join Ton on Nhap.MaVT = Ton.MaVT
inner join Xuat on Xuat.MaVT = Ton.MaVT
where DonGiaX < DonGiaN

select * from Ton

update Xuat
set NgayX = NgayN
from Nhap inner join Xuat
on Nhap.MaVT = Xuat.MaVT
where Nhap.MaVT = Xuat.MaVT and NgayX < NgayN 

select * from Xuat