﻿use master

CREATE DATABASE QLBH
go

use QLBH
go

--------------Cau1----------------
--SANPHAM(MaSP,TenSP,SoLuong,DonGia,MauSac)
--NHAP(SoHDN,MaSP,NgayN,SoluongN,DonGiaN)
--XUAT(SoHDX,MaSP,NgayX,SoluongX)
CREATE TABLE SANPHAM(
	MASP CHAR(4) NOT NULL PRIMARY KEY,
	TENSP NVARCHAR(30),
	SOLUONG INT,
	DONGIA MONEY,
	MAUSAC NVARCHAR(20)
)
GO

CREATE TABLE NHAP(
	SOHDN CHAR(4) NOT NULL,
	MASP CHAR(4) NOT NULL ,
	MGAYN DATE,
	SOLUONGN INT,
	DONGIAN INT,
	CONSTRAINT PK_NHAP PRIMARY KEY (SOHDN, MASP),
	CONSTRAINT FK_NHAP_SANPHAM FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP)
)
GO

CREATE TABLE XUAT(
	SOHDX CHAR(4) NOT NULL,
	MASP CHAR(4) NOT NULL ,
	NGAYX DATE,
	SOLUONGX INT,
	CONSTRAINT PK_XUAT PRIMARY KEY (SOHDX, MASP),
	CONSTRAINT FK_XUAT_SANPHAM FOREIGN KEY (MASP) REFERENCES SANPHAM(MASP)
)
GO

INSERT INTO SANPHAM VALUES
	('SP01', N'Điện thoại', 7, 300000, N'Đen'),
	('SP02', N'Laptop', 7, 450000, N'Đỏ'),
	('SP03', N'Ipad', 9, 200000, N'Đen'),
	('SP04', N'Tủ lạnh', 3, 350000, N'Xanh'),
	('SP05', N'Điều hòa', 11, 100000, N'Đen')
 
	
INSERT INTO NHAP VALUES 
	('N01', 'SP03', '2021-9-3', 4, 300000),
	('N02', 'SP02', '2021-12-11', 6, 500000),
	('N03', 'SP05', '2021-12-29', 8, 150000)

INSERT INTO XUAT VALUES 
	('X01', 'SP03', '2021-8-8', 5),
	('X02', 'SP05', '2022-1-3', 4),
	('X03', 'SP02', '2022-1-12', 6)

SELECT * FROM SANPHAM
SELECT * FROM NHAP
SELECT * FROM XUAT
GO

---Cau1-a: ----------
CREATE FUNCTION DS_SANPHAM (@NGAYXUAT DATE)
RETURNS @BANG TABLE (
						MASP CHAR(4),
						TENSP NVARCHAR(30),
						MAUSAC NVARCHAR(20),
						SOLUONGX INT,
						DONGIA MONEY,
						TIENBAN MONEY
					)
AS
BEGIN
	INSERT INTO @BANG
		SELECT SANPHAM.MASP, TENSP, MAUSAC, SOLUONGX, DONGIA, TIENBAN = (SOLUONGX*DONGIA)
		FROM SANPHAM
			INNER JOIN XUAT ON XUAT.MASP = SANPHAM.MASP
		WHERE NGAYX = @NGAYXUAT
	RETURN
END
GO

SELECT * FROM DBO.DS_SANPHAM('2022-1-12')
GO

-----Cau1-b: -------------
CREATE PROC CAPNHAT_NHAP(@SOHDN CHAR(4), @MASP CHAR(4), @SOLUONGN INT, @DONGIAN MONEY, @KQ INT OUTPUT)
AS
BEGIN
	IF(NOT EXISTS (SELECT * FROM SANPHAM WHERE MASP = @MASP))
		SET @KQ = 1
	ELSE
		BEGIN
			SET @KQ = 0
			UPDATE NHAP
			SET MASP = @MASP, SOLUONGN = @SOLUONGN, DONGIAN = @DONGIAN
			WHERE SOHDN = @SOHDN
		END
	RETURN @KQ
END
GO

DECLARE @KQ INT
EXEC CAPNHAT_NHAP 'N01', 'SP03', 4, 350000, @KQ output
SELECT @KQ
go

SELECT * FROM NHAP
GO


----------------------CAU 2 ---------------------------
----CAU2-A :   ---------------------------------
CREATE FUNCTION TIENXUAT(@TENSP NVARCHAR(30), @NGAYX DATE)
RETURNS MONEY
AS
BEGIN
	DECLARE @TIENX MONEY
		SET @TIENX = (SELECT TIENX = SOLUONGX*DONGIA FROM XUAT
						INNER JOIN SANPHAM ON SANPHAM.MASP = XUAT.MASP
						WHERE TENSP = @TENSP AND NGAYX = @NGAYX)
	RETURN @TIENX
END
GO

SELECT DBO.TIENXUAT(N'Ipad', '2021-8-8') AS 'Tien Xuat'
GO

------CAU2-B: ----------------
CREATE PROC CAPNHAT_NHAP2(@SOHDN CHAR(4), @MASP CHAR(4), @SOLUONGN INT, @DONGIAN MONEY)
AS
BEGIN
	IF(NOT EXISTS (SELECT * FROM SANPHAM WHERE MASP = @MASP))
		PRINT 'KHONG CO ' + @MASP + ' TRONG BANG SANPHAM'
	ELSE
		BEGIN
			UPDATE NHAP
			SET MASP = @MASP, SOLUONGN = @SOLUONGN, DONGIAN = @DONGIAN
			WHERE SOHDN = @SOHDN
			PRINT 'CAP NHAT THANH CONG'
		END
END
GO

EXEC CAPNHAT_NHAP2 'N01', 'SP06', 5, 350000
GO

SELECT * FROM NHAP
GO