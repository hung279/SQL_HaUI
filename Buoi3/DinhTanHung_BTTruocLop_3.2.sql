use master
go

create database ThucTap2
on primary(
	name = 'ThucTap2',
	filename = 'E:\SQL\Buoi3\ThucTap2.mdf',
	size = 10mb,
	maxsize = 50mb,
	filegrowth = 10mb
)

log on(
	name = 'ThucTap2_log',
	filename = 'E:\SQL\Buoi3\ThucTap2.ldf',
	size = 10mb,
	maxsize = 50mb,
	filegrowth = 10mb
)

go
use ThucTap2

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
	PRIMARY KEY (maSV),
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
	(102, 'Tran son', 65.0, 'K01'),
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
	(201, 'DT01', 102, 8.0),
	(200, 'DT03', 103, 7.5),
	(203, 'DT05', 102, 9.4),
	(204, 'DT04', 105, 8.2)
insert into HuongDan values
	(202, 'DT03', 103, 8.0)
--1. Cho biết mã số và tên của các đề tài do giảng viên ‘Tran son’ hướng dẫn
select DeTai.maDT, tenDT
from HuongDan
inner join DeTai
on DeTai.maDT = HuongDan.maDT
inner join GiangVien
on HuongDan.maGV = GiangVien.maGV
where hoTenGV = 'Tran son'

--2. Cho biết tên đề tài không có sinh viên nào thực tập
select tenDT
from DeTai
where maDT not in (select maDT from HuongDan)
--3. Cho biết mã số, họ tên, tên khoa của các giảng viên hướng dẫn từ 3 sinh viên trở lên.
select GiangVien.maGV, hoTenGV, tenKhoa
from GiangVien
inner join Khoa
on GiangVien.maKhoa = Khoa.maKhoa
where maGV in (select maGV from HuongDan group by maGV
					having count(maSV) > 2)

--4. Cho biết mã số, tên đề tài của đề tài có kinh phí cao nhất
select maDT, tenDT 
from DeTai
where kinhPhi = (select MAX(kinhPhi) from DeTai)
--5. Cho biết mã số và tên các đề tài có nhiều hơn 2 sinh viên tham gia thực tập
select maDT, tenDT 
from DeTai
where maDT in (select maDT from HuongDan group by maDT
					having count(maSV) > 2)
--6. Đưa ra mã số, họ tên và điểm của các sinh viên khoa ‘DIALY và QLTN’
select SinhVien.maSV, hoTenSV, ketQua as 'Diem'
from SinhVien inner join HuongDan
on SinhVien.maSV = HuongDan.maSV
inner join Khoa
on SinhVien.maKhoa = Khoa.maKhoa
where tenKhoa = 'DIA LY' or tenKhoa = 'QLTN'
--7. Đưa ra tên khoa, số lượng sinh viên của mỗi khoa
select tenKhoa, count(maSV)
from Khoa inner join SinhVien
on Khoa.maKhoa = SinhVien.maKhoa
group by Khoa.maKhoa, tenKhoa
--8. Cho biết thông tin về các sinh viên thực tập tại quê nhà
select SinhVien.* from HuongDan
inner join SinhVien
on SinhVien.maSV = HuongDan.maSV
inner join DeTai
on DeTai.maDT = HuongDan.maDT
where queQuan = noiThucTap
--9. Hãy cho biết thông tin về những sinh viên chưa có điểm thực tập
select * from SinhVien
where maSV not in (select maSV from HuongDan)
--10.Đưa ra danh sách gồm mã số, họ tên các sinh viên có điểm thực tập bằng 0
select maSV, hoTenSV
from SinhVien
where maSV in (select maSV from HuongDan where ketQua = 0)