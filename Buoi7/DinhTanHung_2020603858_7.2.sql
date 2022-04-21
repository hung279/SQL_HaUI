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

--Bài 1 (5đ). Scalar Valued Function
--a. Hãy xây dựng hàm Đưa ra tên HangSX khi nhập vào MaSP từ bàn phím
CREATE FUNCTION TimHang(@MaSP nchar(10))
RETURNS nvarchar(20)
AS
BEGIN
	DECLARE @tenhang nvarchar(20)
		SET @tenhang = (SELECT TenHang FROM HangSX
							INNER JOIN SanPham on HangSX.MaHangSX = SanPham.MaHangSX
						WHERE MaSP = @MaSP)
	RETURN @tenhang
END
go
 
SELECT dbo.TimHang('SP01') AS 'TEN HANG'
go
--b. Hãy xây dựng hàm đưa ra tổng giá trị nhập từ năm nhập x đến năm nhập y, với x, y được
--nhập vào từ bàn phím.
CREATE FUNCTION TongGiaTriNhap(@x int, @y int)
RETURNS int
AS
BEGIN
	DECLARE @tong int
		SET @tong = (SELECT SUM(DonGiaN * SoLuongN) FROM Nhap
							INNER JOIN PNhap on Nhap.SoHDN = PNhap.SoHDN
						WHERE YEAR(NgayNhap) between @x and @y)
	RETURN @tong
END
go

SELECT dbo.TongGiaTriNhap(2020, 2020)
go
--c. Hãy viết hàm thống kê tổng số lượng thay đổi nhập xuất của tên sản phẩm x trong năm
--y, với x,y nhập từ bàn phím.
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
--d. Hãy xây dựng hàm Đưa ra tổng giá trị nhập từ ngày nhập x đến ngày nhập y, với x, y
--được nhập vào từ bàn phím.
CREATE FUNCTION TongGiaTriNhapNgay(@x date, @y date)
RETURNS int
AS
BEGIN
	DECLARE @tong int
		SET @tong = (SELECT SUM(DonGiaN * SoLuongN) FROM Nhap
							INNER JOIN PNhap on Nhap.SoHDN = PNhap.SoHDN
						WHERE NgayNhap between @x and @y)
	RETURN @tong
END
go

SELECT dbo.TongGiaTriNhapNgay('2020-02-01', '2020-03-31')
go
--Bài 2 (5đ). Table Valued Function
--a. Hãy xây dựng hàm đưa ra thông tin các sản phẩm của hãng có tên nhập từ bàn phím.
CREATE FUNCTION DSSP_HANG(@tenhang nvarchar(20))
RETURNS table
AS
RETURN
	SELECT SanPham.* FROM SanPham
		INNER JOIN HangSX on HangSX.MaHangSX = SanPham.MaHangSX
	WHERE TenHang = @tenhang
go

SELECT * from DSSP_HANG('Samsung')
go
--b. Hãy viết hàm Đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được nhập
--từ ngày x đến ngày y, với x,y nhập từ bàn phím.
CREATE FUNCTION DSSP_NhapTheoNgay(@x date, @y date)
RETURNS @bang table (
					MaSP nchar(10),
					TenSP nvarchar(20),
					TenHang nvarchar(20),
					NgayNhap date,
					SoLuongN int,
					DonGiaN money
					)
AS
BEGIN
	INSERT INTO @bang
		SELECT SanPham.MaSP, TenSP, TenHang, NgayNhap, SoLuongN, DonGiaN
		FROM Nhap
			INNER JOIN SanPham on SanPham.MaSP = Nhap.MaSP
			INNER JOIN HangSX on HangSX.MaHangSX = SanPham.MaHangSX
			INNER JOIN PNhap on PNhap.SoHDN = Nhap.SoHDN
		WHERE NgayNhap between @x and @y
	RETURN
END
go

SELECT * FROM dbo.DSSP_NhapTheoNgay('2020-02-01', '2020-03-31')
go
--c. Hãy xây dựng hàm Đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn,
--nếu lựa chọn = 0 thì Đưa ra danh sách các sản phẩm có SoLuong = 0, ngược lại lựa chọn
--=1 thì Đưa ra danh sách các sản phẩm có SoLuong >0.
CREATE FUNCTION DSSP_NhapTheoLuaChon(@tenhang nvarchar(20) , @choose int)
RETURNS @bang table (
					MaSP nchar(10),
					TenSP nvarchar(20),
					TenHang nvarchar(20),
					SoLuong int,
					MauSac nvarchar(20),
					GiaBan money,
					DonViTinh nchar(10),
					MoTa nvarchar(max)
					)
AS
BEGIN
	IF(@choose = 0)
		INSERT INTO @bang
			SELECT SanPham.MaSP, TenSP, TenHang,SoLuong,MauSac,GiaBan,DonViTinh,MoTa
			FROM SanPham
				INNER JOIN HangSX on HangSX.MaHangSX = SanPham.MaHangSX
			WHERE TenHang = @tenhang and SoLuong = 0
	ELSE IF(@choose = 1)
		INSERT INTO @bang
			SELECT SanPham.MaSP, TenSP, TenHang,SoLuong,MauSac,GiaBan,DonViTinh,MoTa
			FROM SanPham
				INNER JOIN HangSX on HangSX.MaHangSX = SanPham.MaHangSX
			WHERE TenHang = @tenhang and SoLuong > 0
	RETURN
END
go

SELECT * FROM dbo.DSSP_NhapTheoLuaChon('OPPO', 1)
go
--d. Hãy xây dựng hàm Đưa ra danh sách các nhân viên có tên phòng nhập từ bàn phím.
CREATE FUNCTION DSNV(@phong nvarchar(30))
RETURNS table
AS
RETURN
	SELECT * FROM NhanVien
	WHERE TenPhong = @phong
go

SELECT * FROM dbo.DSNV(N'Kế toán')