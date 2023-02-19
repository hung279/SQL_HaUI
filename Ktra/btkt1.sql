use master
go

CREATE DATABASE QLBanHang
go

use QLBanHang
go

--cau1
CREATE TABLE CongTy (
	MaCT CHAR(4) NOT NULL PRIMARY KEY,
	TenCT nvarchar(50) NOT NULL,
	TrangThai nvarchar(20),
	ThanhPho nvarchar(30)
)

CREATE TABLE SanPham(
	MaSP CHAR(4) NOT NULL PRIMARY KEY,
	TenSP NVARCHAR(30) NOT NULL,
	MauSac nvarchar(20),
	GiaBan money,
	SoLuongCo int
)

CREATE TABLE CungUng(
	MaCT char(4) NOT NULL,
	MaSP char(4) NOT NULL,
	SoLuongBan int,
	Constraint PK_CungUng primary key (MaCT, MaSP),
	Constraint FK_CungUng_CongTy foreign key (MaCT) references CongTy(MaCT),
	Constraint FK_CungUng_SanPham foreign key (MaSP) references SanPham(MaSP),
)

INSERT INTO CongTy VALUES
('CT01', 'CONG TY A', N'Tôt', N'Hà Nội'),
('CT02', 'CONG TY B', N'Tôt', N'Yên Bái'),
('CT03', 'CONG TY C', N'Tôt', N'Hà Nội')

INSERT INTO SanPham VALUES
('SP01', 'Tivi', N'Đen', 300000, 15),
('SP02', N'Tủ lạnh', N'Trắng', 200000, 9),
('SP03', N'Điện thoại', N'Đỏ', 500000, 18)

INSERT INTO CungUng VALUES
('CT01', 'SP03', 8),
('CT02', 'SP03', 6),
('CT02', 'SP01', 10),
('CT03', 'SP02', 4),
('CT01', 'SP02', 5),
('CT03', 'SP01', 5)

SELECT * FROM CongTy
SELECT * FROM SanPham
SELECT * FROM CungUng
go

--cau3
SELECT SanPham.*
FROM SanPham
	INNER JOIN CungUng on CungUng.MaSP = SanPham.MaSP
WHERE SoLuongBan between 5 and 20
go

--cau2
CREATE VIEW Cau_4
AS
	SELECT MaCT, Count(*) SoLuongHang
	FROM CungUng
	GROUP BY MaCT
go

SELECT * FROM Cau_4
go

SELECT MaCT, TenCT, TrangThai, ThanhPho
From CongTy
WHERE MaCT in (
SELECT MaCT
FROM Cau_4
WHERE SoLuongHang = (SELECT COUNT(*) FROM SanPham))
go
--Cau 5

CREATE FUNCTION TinhSoLuong(@thanhpho nvarchar(30))
RETURNS int
AS
BEGIN
	DECLARE @tong int
		SET @tong = (SELECT COUNT(*) 
					 FROM CongTy
					 WHERE ThanhPho = @thanhpho
					 GROUP BY ThanhPho)
	RETURN @tong
END
go

SELECT dbo.TinhSoLuong(N'Yên Bái') as 'So Luong'
go


--b
--CREATE FUNCTION <Tên function>
--([@<tên tham số> <kiểu dữ liệu> [= <giá trị mặc định>], …,[...]])
--RETURNS @<tên biến trả về> TABLE (<tên cột 1> <kiểu dữ liệu> [tùy chọn thuộc tính], ..., <tên cột n> <kiểu dữ liệu> [tùy chọn thuộc tính])
--[AS]
--BEGIN
	--INSERT INTO @bang 
--		<Câu lệnh SQL>
--RETURN
--END
CREATE FUNCTION TienCongTy (@tencongty nvarchar(50))
RETURNS @bang TABLE (MaCTy char(4),
					 TenCTy nvarchar(50),
					 Tien float)
AS
BEGIN
	INSERT INTO @bang 
		SELECT CongTy.MaCTy, TenCTY, Tien = SoLuongCungUng*GiaBan
		FROM CungUng
			INNER JOIN CongTy ON CongTy.MaCTy = CungUng.MaCTy
			INNER JOIN SanPham ON SanPham.MaSP = CungUng.MaSP
		WHERE TenCTy = @tencongty
RETURN
END
go

SELECT * FROM dbo.TienCongTy('Samsung')

