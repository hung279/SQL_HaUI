CREATE DATABASE QLTruong

USE QLTruong
go

CREATE TABLE Khoa(
	MaKhoa varchar(10) primary key not null,
	TenKhoa nvarchar(30) not null,
	DienThoai varchar(15)
)
go

CREATE TABLE LOP(
	MaLop varchar(10) primary key not null,
	TenLop nvarchar(30) not null,
	Khoa int not null,
	Hedt nvarchar(20),
	NamNhapHoc int,
	MaKhoa varchar(10),
	CONSTRAINT FK_Khoa_Lop foreign key(MaKhoa)
		references Khoa(MaKhoa)
)
go

--Câu 1 (5đ). Viết thủ tục nhập dữ liệu vào bảng KHOA với các tham biến:
--makhoa,tenkhoa, dienthoai, hãy kiểm tra xem tên khoa đã tồn tại trước đó hay chưa,
--nếu đã tồn tại trả về giá trị 0, nếu chưa tồn tại thì nhập vào bảng khoa, test với 2
--trường hợp.

CREATE PROC BT2_1(@makhoa varchar(10), @tenkhoa nvarchar(30), @dienthoai varchar(15), @kq int output)
AS
BEGIN
	IF(EXISTS(SELECT * FROM KHOA WHERE TenKhoa = @tenkhoa))
		set @kq = 0
	ELSE
		INSERT INTO Khoa
		VALUES (@makhoa, @tenkhoa, @dienthoai)
	RETURN @kq
END
go

DECLARE @Ketqua int
EXEC BT2_1 'K01', 'CNTT', '012345678', @Ketqua output
SELECT @Ketqua
go
--Câu 2 (5đ). Hãy viết thủ tục nhập dữ liệu cho bảng lop với các tham biến
--malop,tenlop,khoa,hedt,namnhaphoc,makhoa.
-- - Kiểm tra xem tên lớp đã có trước đó chưa nếu có thì trả về 0.
-- - Kiểm tra xem makhoa này có trong bảng khoa hay không nếu không có thì trả về
--1.
-- - Nếu đầy đủ thông tin thì cho nhập và trả về 2.

CREATE PROC BT2_2(@malop varchar(10), @tenlop nvarchar(30),
				@khoa int, @hedt nvarchar(20),
				@namnhaphoc int, @makhoa varchar(10), @kq int output)
AS
BEGIN
	IF(EXISTS(SELECT * FROM LOP WHERE TenLop = @tenlop))
		SET @kq = 0
	ELSE IF(NOT EXISTS (SELECT * FROM Khoa WHERE MaKhoa = @makhoa))
		SET @kq = 1
	ELSE
		BEGIN
			INSERT INTO LOP
			VALUES(@malop, @tenlop, @khoa, @hedt, @namnhaphoc, @makhoa)
			SET @kq = 2
		END
	RETURN @kq
END
go

DECLARE @Ketqua int
EXEC BT2_2 'KTPM3', N'Kỹ thuật phầm mềm 3', 15, N'Đại học', 2020, 'K01', @Ketqua output
SELECT @Ketqua
go

DECLARE @Ketqua int
EXEC BT2_2 'CK2', N'Cơ khí 2', 15, N'Đại học', 2020, 'K02', @Ketqua output
SELECT @Ketqua
