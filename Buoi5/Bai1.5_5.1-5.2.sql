CREATE DATABASE TRUONGHOC
GO

USE TRUONGHOC
GO

-- Tạo bảng HOCSINH
CREATE TABLE HOCSINH
(
MAHS CHAR(5),
TEN NVARCHAR(30),
NAM BIT, -- Column giới tính Nam: 1 - đúng, 0 - sai
NGAYSINH DATETIME,
DIACHI VARCHAR(20),
DIEMTB FLOAT,
)
GO
-- Tạo bảng GIAOVIEN
CREATE TABLE GIAOVIEN
(
MAGV CHAR(5),
TEN NVARCHAR(30),
Nam BIT, -- Column giới tính Nam: 1 - đúng, 0 - sai
NGAYSINH DATETIME,
DIACHI VARCHAR(20),
LUONG MONEY
)
GO
-- Tạo bảng LOPHOC
CREATE TABLE LOPHOC
(
MALOP CHAR(5),
TENLOP NVARCHAR(30),
SOLUONG INT
)
GO

INSERT dbo.HOCSINH
VALUES 
('CS001' , N'VĂN A' , 1 ,'19940226', 'HANOI' ,9.0),
('CS002' , N'KIM LONG' , 1 ,'19940226', 'DONGNAI' ,9.0),
('CS003' , N'VĂN C' , 1 ,'19940226', 'HANOI' ,9.0),
('CS004' , N'VĂN D' , 1 ,'19940226', 'HUNGYEN' ,9.0),
('CS005' , N'VĂN E' , 1 ,'19940226', 'YENBAI' ,9.0)
GO



SELECT * FROM HOCSINH
SELECT * FROM GIAOVIEN
--Ví dụ 1: Xóa tất cả dữ liệu trong Table HOCSINH, ta sử dụng lệnh:
DELETE dbo.HOCSINH
--Ví dụ 2: Xóa những giáo viên có lương hơn 5000:
DELETE dbo.GIAOVIEN WHERE LUONG >5000
--Ví dụ 3: Xóa những giáo viên có lương hơn 5000 và mã số giáo viên <15
DELETE dbo.GIAOVIEN WHERE LUONG > 5000 AND MAGV < 15
--Ví dụ 4: Xóa những học sinh có điểm TB là 1; 8; 9.
DELETE dbo.HOCSINH WHERE DIEMTB IN (1,8,9)
--Ví dụ 5: Xóa những học sinh có mã học sinh thuộc danh sách FD001, FD002, FD003
DELETE FROM dbo.HOCSINH WHERE MAHS IN ('FD002','FD001', 'FD003')
--Ví dụ 6: Xóa những học sinh có điểm trong khoảng 1 đến 8
DELETE dbo.HOCSINH WHERE DIEMTB BETWEEN 1 AND 8
--Ví dụ 7: Xóa những học sinh có địa chỉ không phải ở Đà Lạt.
DELETE dbo.HOCSINH WHERE DIACHI NOT LIKE 'DALAT'

--Update Record
--Ví dụ 1: Cập nhập Lương của tất cả giáo viên thành 10000
UPDATE dbo.GIAOVIEN SET LUONG = 10000
--Ví dụ 2: Cập nhập lương của tất cả giáo viên thành 10000 và địa chỉ tại DALAT
UPDATE dbo.GIAOVIEN SET LUONG = 10000, DIACHI ='DALAT'
--Ví dụ 3: Cập nhập lương của những giáo viên nam thành 1
UPDATE dbo.GIAOVIEN SET LUONG = 1
WHERE Nam='1'