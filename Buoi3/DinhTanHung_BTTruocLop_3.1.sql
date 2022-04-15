use master
go

create database ThucTap
on primary(
	name = 'ThucTap',
	filename = 'E:\SQL\Buoi3\ThucTap.mdf',
	size = 10mb,
	maxsize = 50mb,
	filegrowth = 10mb
)

log on(
	name = 'ThucTap_log',
	filename = 'E:\SQL\Buoi3\ThucTap.ldf',
	size = 10mb,
	maxsize = 50mb,
	filegrowth = 10mb
)

go
use ThucTap

create table Khoa(
	maKhoa char(10) not null primary key,
	tenKhoa char(30) not null,
	dienThoai nvarchar(10),
)

create table DeTai(
	maDT char(10) not null primary key,
	tenDT char(30) not null,
	kinhPhi int,
	noiThucTap nvarchar(30)
)

create table GiangVien(
	maGV int not null primary key,
	hoTenGV char(30) not null,
	luong decimal(5, 2),
	maKhoa char(10),
	constraint FK_GV_maKhoa foreign key(maKhoa)
		references Khoa(maKhoa)
)

create table SinhVien(
	maSV int not null primary key,
	hoTenSV char(30) not null,
	maKhoa char(10),
	nameSinh int,
	queQuan char(30),
	constraint FK_SV_maKhoa foreign key(maKhoa)
		references Khoa(maKhoa)
)

create table HuongDan(
	maSV int not null,
	maDT char(10) not null,
	maGV int not null,
	ketQua decimal(5, 2),
	PRIMARY KEY (maSV, maDT, maGV),
	FOREIGN KEY (maSV) REFERENCES dbo.SinhVien(maSV),
	FOREIGN KEY (maDT) REFERENCES dbo.DeTai(maDT),
	FOREIGN KEY (maGV) REFERENCES dbo.GiangVien(maGV)
)

drop table HuongDan

insert into Khoa values
	('K01', 'CNTT', '0912345678'),
	('K02', 'DIA LY', '0945678123'),
	('K03', 'QLTN', '0914725836'),
	('K04', 'Toan', '0914725836'),
	('K05', 'CONG NGHE SINH HOC', '0914725836')


insert into DeTai values
	('DT01', 'ABC', 500000, 'Ha Noi'),
	('DT02', 'DEF', 200000, 'Ha Noi'),
	('DT03', 'GHI', 250000, 'Ha Noi'),
	('DT04', 'KML', 100000, 'Ha Noi'),
	('DT05', 'XYZ', 950000, 'Ha Noi')

insert into GiangVien values
	(100, 'Nguyen Thi A', 50.0, 'K05'),
	(101, 'Nguyen Thi B', 55.0, 'K02'),
	(102, 'Nguyen Van C', 65.0, 'K01'),
	(103, 'Nguyen Van D', 45.0, 'K03'),
	(104, 'Nguyen Thi E', 50.0, 'K04')
	
insert into GiangVien values
	(105, 'Nguyen Thi F', 50.0, 'K05')

insert into SinhVien values
	(200, 'Sinh Vien A', 'K05', 2000, 'Ha Noi'),
	(201, 'Sinh Vien B', 'K02', 2000, 'Ha Noi'),
	(202, 'Le Van Son', 'K01', 2000, 'Ha Noi'),
	(203, 'Le Van Son', 'K05', 2000, 'Ha Noi'),
	(204, 'Nguyen Thi E', 'K04', 2000, 'Ha Noi')


insert into HuongDan values
	(202, 'DT02', 101, 9.2),
	(201, 'DT01', 100, 8.0),
	(200, 'DT03', 103, 7.5),
	(203, 'DT05', 104, 9.4),
	(204, 'DT04', 105, 8.2)

select maGV, hoTenGV, tenKhoa
from GiangVien inner join Khoa
on GiangVien.maKhoa = Khoa.maKhoa 

select maGV, hoTenGV, tenKhoa
from GiangVien inner join Khoa
on GiangVien.maKhoa = Khoa.maKhoa
where tenKhoa = 'DIA LY'

select YEAR(GETDATE());

select maSV, hoTenSV, YEAR(GETDATE())-nameSinh AS N'Tuổi' from SinhVien
where maKhoa in (select maKhoa from Khoa where tenKhoa = 'TOAN')

select count(maSV) AS N'Số Lượng'
from SinhVien
where maKhoa in (select maKhoa from Khoa where tenKhoa = 'CONG NGHE SINH HOC')

select count(maGV) AS N'Số Lượng'
from GiangVien
where maKhoa in (select maKhoa from Khoa where tenKhoa = 'CONG NGHE SINH HOC')

select * from SinhVien
where maSV not in (select maSV from HuongDan)

select Khoa.maKhoa, tenKhoa, count(maGV)
from Khoa inner join GiangVien
on Khoa.maKhoa = GiangVien.maKhoa
group by Khoa.maKhoa, Khoa.tenKhoa

select dienThoai from Khoa
where maKhoa in (select maKhoa from SinhVien 
	where hoTenSV = 'Le Van Son' )