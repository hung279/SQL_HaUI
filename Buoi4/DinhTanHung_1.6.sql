use master
go

create database QLBanHang
on primary(
	name = 'QLBanHang',
	filename = 'E:\SQL\Buoi2\QLBanHang.mdf',
	size = 10mb,
	maxsize = 50mb,
	filegrowth = 10mb
)

log on(
	name = 'QLBanHang_log',
	filename = 'E:\SQL\Buoi2\QLBanHang.ldf',
	size = 10mb,
	maxsize = 50mb,
	filegrowth = 10mb
)

go

create table HangSX(
	MaHangSX nchar(10) not null primary key,
	TenHang nvarchar(20) not null,
	DiaChi nvarchar(30),
	soDT nvarchar(20),
	Email nvarchar(30)
)

create table SanPham(
	MaSP nchar(10) not null primary key,
	MaHangSX nchar(10) not null,
	TenSP nvarchar(20) not null,
	SoLuong int,
	MauSac nvarchar(20),
	GiaBan money,
	DonViTinh nchar(10),
	MoTa nvarchar(max),
	constraint FK_SP_MaHangSX foreign key(MaHangSX)
		references HangSX(MaHangSX)
)

create table NhanVien(
	MaNV nchar(10) not null primary key,
	TenNV nvarchar(20) not null,
	GioiTinh nchar(10),
	DiaChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(30),
	TenPhong nvarchar(30)
)

create table PNhap(
	SoHDN nchar(10) not null primary key,
	NgayNhap date,
	MaNV nchar(10) not null,
	constraint FK_PN_MaNV foreign key(MaNV)
		references NhanVien(MaNV)
)

create table Nhap(
	SoHDN nchar(10) not null,
	MaSP nchar(10) not null,
	SoLuongN int,
	DonGiaN money,
	constraint PK_SoHDN_MaSP primary key(SoHDN, MaSP),
	constraint FK_Nhap_SoHDN foreign key(SoHDN)
		references PNhap(SoHDN),
	constraint FK_Nhap_MaSP foreign key(MaSP)
		references SanPham(MaSP)
)

create table PXuat(
	SoHDX nchar(10) not null primary key,
	NgayXuat date,
	MaNV nchar(10) not null,

	constraint FK_PX_MaNV foreign key(MaNV)
		references NhanVien(MaNV)
)

create table Xuat(
	SoHDX nchar(10) not null,
	MaSP nchar(10) not null,
	SoLuongX int,

	constraint PK_SoHDX_MaSP primary key(SoHDX, MaSP),
	constraint FK_Xuat_SoHDX foreign key(SoHDX)
		references PXuat(SoHDX),
	constraint FK_Xuat_MaSP foreign key(MaSP)
		references SanPham(MaSP)
)

go

insert into HangSX values
	('H01', 'Samsung', N'Korea', '011-08271717', 'ss@gmail.com.kr'),
	('H02', 'OPPO', N'China', '081-08626262', 'oppo@gmail.com.cn'),
	('H03', 'Vinfone', N'Việt nam', '084-098262626', 'vf@gmail.com.vn')

insert into SanPham values
	('SP01', 'H02', 'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp'),
	('SP02', 'H01', 'Galaxy Note11', 50, N'Đỏ', 19000000, N'Chiếc', N'Hàng cao cấp'),
	('SP03', 'H02', 'F3 lite', 200, N'Nâu', 3000000, N'Chiếc', N'Hàng phổ thông'),
	('SP04', 'H03', 'Vjoy3', 200, N'Xám', 1500000, N'Chiếc', N'Hàng phổ thông'),
	('SP05', 'H01', 'Galaxy V21', 500, N'Nâu', 8000000, N'Chiếc', N'Hàng cận cao cấp')

insert into NhanVien values
	('NV01', N'Nguyễn Thị Thu', N'Nữ', N'Hà Nội', '0982626521', 'thu@gmail.com', N'Kế toán'),
	('NV02',N'Lê Văn Nam',N'Nam',N'Bắc Ninh','0972525252','nam@gmail.com',N'Vật tư'),
	('NV03',N'Trần Hòa Bình',N'Nữ',N'Hà Nội','0328388388','hb@gmail.com',N'Kế toán')

insert into PNhap values
	('N01', '2019-2-5', 'NV01'),
	('N02', '2020-4-7', 'NV02'),
	('N03', '2019-5-17', 'NV02'),
	('N04', '2019-3-22', 'NV03'),
	('N05', '2019-7-7', 'NV01')


insert into Nhap values
	('N01', 'SP02', 10, 17000000),
	('N02', 'SP01', 30,  6000000),
	('N03', 'SP04', 20, 1200000),
	('N04', 'SP01', 10, 6200000),
	('N05', 'SP05', 20, 7000000)


insert into PXuat values
	('X01', '2020-6-14', 'NV02'),
	('X02', '2019-3-5', 'NV03'),
	('X03', '2019-12-12', 'NV01'),
	('X04', '2019-6-2', 'NV02'),
	('X05', '2019-5-18', 'NV01')


insert into Xuat values
	('X01', 'SP03', 5),
	('X02', 'SP01', 3),
	('X03', 'SP02', 1),
	('X04', 'SP03', 2),
	('X05', 'SP05', 1)

go

use QLBanHang
go
--a

select * from HangSX
select * from SanPham
select * from NhanVien
select * from PNhap
select * from Nhap
select * from PXuat
select * from Xuat

go
--b

select MaSP, TenSP, TenHang,SoLuong, MauSac, GiaBan, DonViTinh, MoTa
from SanPham 
	inner join HangSX 
		on SanPham.MaHangSX = HangSX.MaHangSX
order by GiaBan DESC
go
--c

select MaSP, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
from SanPham
	inner join HangSX 
		on SanPham.MaHangSX = HangSX.MaHangSX
where TenHang = 'Samsung'
go
--d

select *
from NhanVien
where GioiTinh = N'Nữ' and TenPhong = N'Kế Toán'
go
--e

select PNhap.SoHDN, SanPham.MaSP, TenSP, TenHang, SoLuongN, DonGiaN, 
N'Tiền Nhập'=SoLuongN*DonGiaN, MauSac, DonViTinh, NgayNhap, TenNV, TenPhong
from Nhap
	inner join SanPham
		on Nhap.MaSP = SanPham.MaSP
	inner join HangSX
		on HangSX.MaHangSX = SanPham.MaHangSX
	inner join PNhap
		on PNhap.SoHDN = Nhap.SoHDN
	inner join NhanVien
		on NhanVien.MaNV = PNhap.MaNV
order by SoHDN
go
--f

select Xuat.SoHDX, SanPham.MaSP, TenSP, TenHang, SoLuongX, GiaBan,
N'Tiền xuất'=SoLuongX*GiaBan, MauSac, DonViTinh, NgayXuat, TenNV, TenPhong
from Xuat
	inner join SanPham
		on Xuat.MaSP = SanPham.MaSP
	inner join HangSX
		on HangSX.MaHangSX = SanPham.MaHangSX
	inner join PXuat
		on PXuat.SoHDX = Xuat.SoHDX
	inner join NhanVien
		on NhanVien.MaNV = PXuat.MaNV
where MONTH(NgayXuat) = 6 and YEAR(NgayXuat) = 2020
order by SoHDX
go