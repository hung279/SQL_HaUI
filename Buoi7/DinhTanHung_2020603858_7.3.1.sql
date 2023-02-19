use master
go

create database QLBanHang
go

use QLBanHang

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

--a (1đ). Hãy xây dựng hàm Đưa ra tổng giá trị xuất của hãng tên hãng là A, trong năm tài
--khóa x, với A, x được nhập từ bàn phím.
CREATE FUNCTION TONGGIATRIXUAT(@A NVARCHAR(20), @X INT)
RETURNS FLOAT
AS
	BEGIN
		DECLARE @TONG FLOAT
			SET @TONG = (SELECT SUM(SoLuongX * GiaBan) FROM Xuat
							INNER JOIN SanPham on Xuat.MaSP = SanPham.MaSP
							INNER JOIN HangSX on HangSX.MaHangSX = SanPham.MaHangSX
							INNER JOIN PXuat on PXuat.SoHDX = Xuat.SoHDX
						WHERE TenHang = @A AND YEAR(NgayXuat) = @X)
		RETURN @TONG
END
go

SELECT dbo.TONGGIATRIXUAT('Samsung', 2020) AS N'Tong gia tri xuat'
go
--b (1đ). Hãy xây dựng hàm thống kê số lượng nhân viên mỗi phòng với tên phòng nhập từ
--bàn phím.
CREATE FUNCTION SOLUONGNV (@tenphong nvarchar(30))
RETURNS INT
AS
	BEGIN
		DECLARE @TONG INT
			SET @TONG = (SELECT COUNT(MaNV) FROM NhanVien
							WHERE TenPhong = @tenphong
						)
		RETURN @TONG
END
go

SELECT dbo.SOLUONGNV(N'Kế toán')
go
--c (2đ). Hãy viết hàm thống kê xem tên sản phẩm x đã xuất được bao nhiêu sản phẩm trong
--ngày y, với x,y nhập từ bản phím.
CREATE FUNCTION SANPHAMTHEONGAY (@x nvarchar(20), @y date)
RETURNS INT
AS
	BEGIN
		DECLARE @tong INT
			SET @tong = (SELECT SUM(SoLuongX) FROM Xuat
							INNER JOIN SanPham on SanPham.MaSP = Xuat.MaSP
							INNER JOIN PXuat on PXuat.SoHDX = Xuat.SoHDX
						WHERE TenSP = @x and NgayXuat = @y)
		RETURN @tong
END
go

SELECT dbo.SANPHAMTHEONGAY('Galaxy V21', '2019-05-18')
go
--d (2đ). Hãy viết hàm trả về số diện thoại của nhân viên đã xuất số hóa đơn x, với x nhập từ
--bàn phím.
CREATE FUNCTION SDTNHANVIEN(@x nchar(20))
RETURNS nvarchar(30)
AS
	BEGIN
		DECLARE @sdt nvarchar(30)
			SET @sdt = (Select SoDT FROM NhanVien
							INNER JOIN PXuat on PXuat.MaNV = NhanVien.MaNV
						WHERE SoHDX = @x)
		RETURN @sdt
END
go

SELECT dbo.SDTNHANVIEN('X05')
go
--e (2đ). Hãy viết hàm thống kê tổng số lượng thay đổi nhập xuất của tên sản phẩm x trong
--năm y, với x,y nhập từ bàn phím.
CREATE FUNCTION TongSoLuong(@x nvarchar(20), @y int)
RETURNS int
AS
BEGIN
	DECLARE @tongthaydoi int
	DECLARE @tongnhap int 
	DECLARE @tongxuat int
		SET @tongnhap = (SELECT SUM(SoLuongN) FROM Nhap
							INNER JOIN PNhap on Nhap.SoHDN = PNhap.SoHDN
							INNER JOIN SanPham on Nhap.MaSP = SanPham.MaSP
						WHERE TenSP = @x and YEAR(NgayNhap) = @y)
		SET @tongxuat = (SELECT SUM(SoLuongX) FROM Xuat
							INNER JOIN PXuat on Xuat.SoHDX = PXuat.SoHDX
							INNER JOIN SanPham on Xuat.MaSP = SanPham.MaSP
						WHERE TenSP = @x and YEAR(NgayXuat) = @y)
		SET @tongthaydoi = @tongnhap - @tongxuat
	RETURN @tongthaydoi
END
go

SELECT dbo.TongSoLuong('Galaxy V21', 2020)
go
--f (2đ). Hãy viết hàm thống kê tổng số lượng sản phầm của hãng x, với tên hãng nhập từ
--bàn phím.
CREATE FUNCTION TongSanPhamTheoHang(@x nvarchar(20))
RETURNS INT
AS
BEGIN
	DECLARE @tong int
		SET @tong = (SELECT COUNT(MaSP) from SanPham
						INNER JOIN HangSX on SanPham.MaHangSX = HangSX.MaHangSX
					WHERE TenHang = @x
					GROUP BY TenHang)
	RETURN @tong
END
go

SELECT dbo.TongSanPhamTheoHang('Samsung')
go