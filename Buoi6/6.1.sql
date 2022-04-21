CREATE DATABASE QLBanHang

USE QLBanHang
GO
CREATE TABLE HangSX (
	MaHangSX nchar(10) NOT NULL PRIMARY KEY,
	TenHang nvarchar(20) NOT NULL,
	DiaChi nvarchar(20),
	SoDt char(10),
	Email nchar(20)
)

CREATE TABLE NhanVien (
	MaNV nchar(10) NOT NULL PRIMARY KEY,
	TenNV nvarchar(20) NOT NULL,
	GioiTinh nvarchar(7),
	DiaChi nvarchar(20),
	SoDT char(10),
	Email nchar(20),
	TenPhong nvarchar(15)
)

CREATE TABLE SanPham (
	MaSP nchar(10) NOT NULL PRIMARY KEY,
	MaHangSX nchar(10) NOT NULL,
	TenSP nvarchar(20) NOT NULL,
	SoLuong int,
	MauSac nvarchar(10),
	GiaBan money,
	DonViTinh nchar(10),
	MoTa ntext,

	CONSTRAINT FK_HSX FOREIGN KEY(MaHangSX) REFERENCES HangSX(MaHangSX)
)

CREATE TABLE PNhap (
	SoHDN int NOT NULL PRIMARY KEY,
	NgayNhap date,
	MaNV nchar(10),

	CONSTRAINT FK_NV FOREIGN KEY(MaNV) REFERENCES NhanVien(MaNV)
)

CREATE TABLE Nhap (
	SoHDN int NOT NULL,
	MaSP nchar(10) NOT NULL,
	SoLuongN int,
	DonGiaN float,

	CONSTRAINT PK_Nhap PRIMARY KEY(SoHDN, MaSP),
	CONSTRAINT FK_PN FOREIGN KEY(SoHDN) REFERENCES PNhap(SoHDN),
	CONSTRAINT FK_SP FOREIGN KEY(MaSP) REFERENCES SanPham(MaSP)
)

CREATE TABLE PXuat (
	SoHDX int NOT NULL PRIMARY KEY,
	NgayXuat date,
	MaNV nchar(10),

	CONSTRAINT FK_PX_NV FOREIGN KEY(MaNV) REFERENCES NhanVien(MaNV)
)

CREATE TABLE Xuat (
	SoHDX int NOT NULL,
	MaSP nchar(10) NOT NULL,
	SoLuongX int,

	CONSTRAINT PK_Xuat PRIMARY KEY(SoHDX, MaSP),
	CONSTRAINT FK_PX FOREIGN KEY(SoHDX) REFERENCES PXuat(SoHDX),
	CONSTRAINT FK_X_SP FOREIGN KEY(MaSP) REFERENCES SanPham(MaSP)
)

INSERT INTO HangSX VALUES
	('H01', 'Ivy Moda', N'Hà Nội', '0246662343', 'ivyModa@gmail.com'),
	('H02', 'Owen', N'TP HCM', '0989008079', 'owen@gmail.com'),
	('H03', 'Nem Fashion', N'Hà Nội', '0246290908', 'nemFas@gmail.com'),
	('H04', 'Chic-Land', N'Hà Nam', '0795008686', 'chicLand@gmail.com'),
	('H05', 'Seven AM', N'Đà Nẵng', '0900633694', 'sevenAM@gmail.com')

INSERT INTO NhanVien VALUES
	('NV01', N'Đào Tuấn Anh', N'Nam', N'Hà Nội', '0796388079', 'anh@gmail.com', 'P01'),
	('NV02', N'Nguyễn Phương Anh', N'Nữ', N'TP HCM', '0868588816', 'anhcute@gmail.com', 'P02'),
	('NV03', N'Trần Thanh Hương', N'Nữ', N'Hà Nam', '0246662343', 'huong@gmail.com', 'P03'),
	('NV04', N'Hoàng Anh Đức', N'Nam', N'TP HCM', '0989008079', 'duc@gmail.com', 'P04'),
	('NV05', N'Nguyễn Thị Mai', N'Nữ', N'Hải Phòng', '0246290908', 'mai@gmail.com', 'P05')

INSERT INTO SanPham VALUES 
	('P01', 'H04', N'Bộ vest', 20, N'Màu đen', 970, 'VND', N'Dài'),
	('P02', 'H01', N'Áo dạ', 30, N'Màu be',630 , 'VND', N'Ngắn tay'),
	('P03', 'H02', N'Áo gile', 15, N'Màu nu', 240, 'VND', N'Loại 1'),
	('P04', 'H05', N'váy dạ', 50, N'Màu đen', 190, 'VND', N'Sếp ly'),
	('P05', 'H03', N'Quần suông', 25, N'Màu nâu', 280, 'VND', N'Loại1')

INSERT INTO PNhap VALUES 
	(1,'2018-01-1', 'NV02'),
	(2,'2020-01-7', 'NV05'),
	(3,'2020-01-8', 'NV01'),
	(4,'2019-01-8', 'NV03'),
	(5,'2021-01-14', 'NV04')

INSERT INTO Nhap VALUES 
	(1,'P03', 5, 150),
	(2, 'P01', 4, 300),
	(4, 'P04', 10, 100)

INSERT INTO PXuat VALUES 
	(1,'2018-01-2', 'NV02'),
	(2,'2020-01-6', 'NV05'),
	(3,'2020-01-8', 'NV01'),
	(4,'2019-01-9', 'NV03'),
	(5,'2021-01-13', 'NV04')

INSERT INTO Xuat VALUES 
	(1,'P03', 2),
	(2, 'P01', 1),
	(5, 'P04', 7)

UPDATE HangSX
SET SoDt = 0123456789
WHERE DiaChi = 'Hà Nội'

UPDATE NhanVien 
SET GioiTinh = 1

UPDATE SanPham 
SET SoLuong = 10
WHERE MaSP = 'P03' AND GiaBan > 200

UPDATE PNhap
SET MaNV = 'NV02'

UPDATE Nhap 
SET DonGiaN = 300

UPDATE PXuat
SET NgayXuat = '2022/02/01'

UPDATE Xuat 
SET SoLuongX = 2

DELETE FROM HangSX
DELETE FROM NhanVien
DELETE FROM SanPham
DELETE FROM PNhap
DELETE FROM Nhap
DELETE FROM PXuat
DELETE FROM Xuat

SELECT * FROM HangSX
SELECT * FROM NhanVien
SELECT * FROM SanPham
SELECT * FROM PNhap
SELECT * FROM Nhap
SELECT * FROM PXuat
SELECT * FROM Xuat