CREATE DATABASE QLNV
go

USE QLNV
go

CREATE TABLE CHUCVU (
	MaCV nvarchar(2) not null primary key,
	TenCV nvarchar(30)
)
go

CREATE TABLE NHANVIEN (
	MaNV nvarchar(4) not null primary key,
	MaCV nvarchar(2),
	TenNV nvarchar(30),
	NgaySinh datetime,
	LuongCanBan float,
	NgayCong int,
	PhuCap float,
	constraint FK_CV_NV foreign key (MaCV)
		references CHUCVU(MaCV)
)
go

INSERT INTO CHUCVU VALUES
('BV', N'Bảo Vệ'),
('GD', N'Giám Đốc'),
('HC', N'Hành Chính'),
('KT', N'Kế Toán'),
('TQ', N'Thủ Quỹ'),
('VS', N'Vệ Sinh')

INSERT INTO NHANVIEN VALUES
('NV01', 'GD', N'Nguyễn Văn An', '12-12-1977', 700000, 25, 500000),
('NV02', 'BV', N'Bùi Văn Tí', '10-10-1978', 400000, 24, 100000),
('NV03', 'KT', N'Trần Thanh Nhật', '9-9-1977', 600000, 26, 400000),
('NV04', 'VS', N'Nguyễn Thị Út', '10-10-1980', 300000, 26, 300000),
('NV05', 'HC', N'Lê Thị Hà', '10-10-1979', 500000, 27, 200000)
go

--1. Viết thủ tục SP_Them_Nhan_Vien, biết tham biến là MaNV, MaCV,
--TenNV,Ngaysinh,LuongCanBan,NgayCong,PhuCap. Kiểm tra MaCV có tồn tại
--trong bảng tblChucVu hay không? nếu thỏa mãn yêu cầu thì cho thêm nhân viên
--mới, nếu không thì đưa ra thông báo.
CREATE PROC SP_Them_Nhan_Vien (@manv nvarchar(4),@macv nvarchar(2),
								 @tennv nvarchar(30),@ngaysinh datetime,
								 @luongcanban float,@ngaycong int,
								 @phucap float
								 )
AS
BEGIN
	IF(not exists (SELECT * FROM CHUCVU WHERE MaCV = @macv))
		PRINT 'Khong co chuc vu ' + @macv + ' trong bang CHUC VU'
	ELSE
		INSERT INTO NHANVIEN VALUES
		(@manv, @macv, @tennv, @ngaysinh, @luongcanban, @ngaycong, @phucap)
END

EXEC SP_Them_Nhan_Vien 'NV06', 'KT', N'Nguyễn Văn A', '2-9-1990', 100000, 23, 100000
go
--2. Viết thủ tục SP_CapNhat_Nhan_Vien ( không cập nhật mã), biết tham biến là
--MaNV, MaCV, TenNV, Ngaysinh, LuongCanBan, NgayCong, PhuCap. Kiểm tra
--MaCV có tồn tại trong bảng tblChucVu hay không? nếu thỏa mãn yêu cầu thì cho
--cập nhật, nếu không thì đưa ra thông báo.
CREATE PROC SP_CapNhat_Nhan_Vien (@manv nvarchar(4),@macv nvarchar(2),
								 @tennv nvarchar(30),@ngaysinh datetime,
								 @luongcanban float,@ngaycong int,
								 @phucap float
								 )
AS
BEGIN
	IF(not exists (SELECT * FROM CHUCVU WHERE MaCV = @macv))
		PRINT 'Khong co chuc vu ' + @macv + ' trong bang CHUC VU'
	ELSE
		UPDATE NHANVIEN
		SET MaCV = @macv, TenNV = @tennv, NgaySinh = @ngaysinh, LuongCanBan = @luongcanban,
			NgayCong = @ngaycong, PhuCap = @phucap
		WHERE MaNV = @manv
END

EXEC SP_CapNhat_Nhan_Vien 'NV06', 'KT', N'Nguyễn Văn A', '2-9-1990', 500000, 23, 100000
go
--3. Viết thủ tục SP_LuongLN với Luong=LuongCanBan*NgayCong PhuCap, biết
--thủ tục trả về, không truyền tham biến.

CREATE PROC SP_LuongLN
AS 
BEGIN
	SELECT *, LuongCanBan*NgayCong + PhuCap as 'Luong'
	FROM NHANVIEN
END

EXEC SP_LuongLN