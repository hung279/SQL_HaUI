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
--nếu đã tồn tại đưa ra thông báo, nếu chưa tồn tại thì nhập vào bảng khoa, test với 2
--trường hợp.

CREATE PROC BT1(@makhoa varchar(10), @tenkhoa nvarchar(30), @dienthoai varchar(15))
AS
BEGIN
	IF(EXISTS(SELECT * FROM KHOA WHERE TenKhoa = @tenkhoa))
		PRINT 'Ten khoa' + @tenkhoa + ' da ton tai'
	ELSE
		INSERT INTO Khoa
		VALUES (@makhoa, @tenkhoa, @dienthoai)
END
go

SELECT * FROM Khoa
EXEC BT1 'K01', 'CNTT', '012345678'
go
--Câu 2 (5đ). Hãy viết thủ tục nhập dữ liệu cho bảng Lop với các tham biến Malop,
--Tenlop, Khoa,Hedt,Namnhaphoc,Makhoa nhập từ bàn phím.
-- - Kiểm tra xem tên lớp đã có trước đó chưa nếu có thì thông báo
-- - Kiểm tra xem makhoa này có trong bảng khoa hay không nếu không có thì thông
--báo
-- - Nếu đầy đủ thông tin thì cho nhập

CREATE PROC BT2(@malop varchar(10), @tenlop nvarchar(30), @khoa int, @hedt nvarchar(20), @namnhaphoc int, @makhoa varchar(10))
AS
BEGIN
	IF(EXISTS(SELECT * FROM LOP WHERE TenLop = @tenlop))
		PRINT 'Lop ' + @tenlop + ' da ton tai'
	ELSE IF(NOT EXISTS (SELECT * FROM Khoa WHERE MaKhoa = @makhoa))
		PRINT 'Ma khoa ' + @makhoa + ' chua co trong bang Khoa'
	ELSE
		INSERT INTO LOP
		VALUES(@malop, @tenlop, @khoa, @hedt, @namnhaphoc, @makhoa)
END
go
SELECT * FROM LOP
SELECT * FROM KHOA
EXEC BT2 'KTPM2', N'Kỹ thuật phầm mềm 2', 15, N'Đại học', 2020, 'K01'
EXEC BT2 'CK2', N'Cơ khí 2', 15, N'Đại học', 2020, 'K02'
go


CREATE PROC CAU2(@tenkhoa varchar(10), @tenbenhvien nvarchar(30))
AS
BEGIN
	declare @makhoa
	set @makhoa = (select MaKhoa from KhoaKham where TenKhoa = @tenkhoa)
	declare @tongtien
	set @tongtien = (select SUM(SoNgayNV*100000)
					 from BenhNhan where MaKhoa = @makhoa
					 group by MaKhoa)
	@tenbenhvien = (select TenBV from BenhVien
						inner join KhoaKham
							on BenhVien.MaBV = KhoaKham.MaBV
						where TenBV = @tenbenbien)
	PRINT 'Khoa ' + @tenkhoa + N' - Bệnh Viện ' + @tenbenhvien + N'- Tổng số tiền: ' + @tongtien 
END
go


EXEC Cau2 N'Khoa X', N'Bệnh Viện X'