create database QLK

use QLK

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
('N01','01',70,100,'01/04/2022'),
('N02','03',130,80,'02/04/2022'),
('N03','05',200,130,'03/04/2022')

insert into Xuat values
('X01','01',20,300,'04/04/2022'),
('X02','03',110,170,'05/04/2022')

select TenVT from Ton
where SoLuongT = ( select max(SoLuongT) from Ton)

select Ton.MaVT, TenVT from Ton
inner join Xuat on Ton.MaVT = Xuat.MaVT
group by Ton.MaVT, TenVT
having sum(SoLuongX) > 100

create view vw_timexuat
as
	select month(NgayX) as 'ThangXuat', 
	year(NgayX) as 'NamXuat', 
	sum(SoLuongX) as 'SoLuongXuat'
	from Xuat
	group by month(NgayX), year(NgayX)

select * from vw_timexuat
	
create view vw_inforVT
as 
	select Ton.MaVT, TenVT, SoLuongN, SoLuongX, DonGiaN, DonGiaX
	from Ton inner join Nhap on Ton.MaVT = Nhap.MaVT
	inner join Xuat on Nhap.MaVT = Xuat.MaVT

select * from vw_inforVT

create view vw_hangton
as
	select Ton.MaVT, TenVT, sum(SoLuongN - SoLuongX + SoLuongT) as 'SoLuongCon'
	from Ton inner join Nhap on Nhap.MaVT = Ton.MaVT
	inner join Xuat on Nhap.MaVT = Xuat.MaVT
	group by Ton.MaVT, TenVT

select * from vw_hangton