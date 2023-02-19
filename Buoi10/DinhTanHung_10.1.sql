CREATE DATABASE DONHANG
go

USE DONHANG
GO

CREATE TABLE HANG (
	MAH CHAR(10) NOT NULL PRIMARY KEY,
	TENH NVARCHAR(30),
	SOLUONG INT,
	GIABAN MONEY
)

CREATE TABLE HOADON (
	MAHD CHAR(10) PRIMARY KEY,
	MAH CHAR(10) NOT NULL,
	SOLUONGB INT,
	NGAYBAN DATE,
	CONSTRAINT FK_HD FOREIGN KEY(MAH)
	REFERENCES HANG(MAH)
)

INSERT INTO HANG VALUES
('H01', 'A', 12, 300000),
('H02', 'B', 15, 100000),
('H03', 'C', 16, 200000)

INSERT INTO HOADON VALUES
('HD01', 'H02', 5, '2021-06-07'),
('HD02', 'H01', 3, '2021-04-09'),
('HD03', 'H03', 6, '2021-12-21')
go

--Hãy tạo 1 trigger insert HoaDon, hãy kiểm tra xem mahang cần mua có tồn
--tại trong bảng HANG không, nếu không hãy đưa ra thông báo.
-- - Nếu thỏa mãn hãy kiểm tra xem: soluongban <= soluong? Nếu không hãy đưa
--ra thông báo.
-- - Ngược lại cập nhật lại bảng HANG với: soluong = soluong - soluongban
CREATE TRIGGER trg_insert_hoadon
ON HoaDon
FOR INSERT 
AS 
	BEGIN
		DECLARE @MAH char(10)
		SET @MAH = (SELECT MAH FROM inserted)

		IF(NOT EXISTS(SELECT * FROM HANG WHERE MAH = @MAH))
			BEGIN 
				RAISERROR('loi 0 co hang', 16, 1)
				ROLLBACK TRANSACTION  -- KHÔI PHỤC TRANG THÁI BAN ĐẦU
			END
		ELSE
			BEGIN
				DECLARE @soluong int
				DECLARE @soluongban int
				SELECT @soluong = soluong FROM HANG WHERE MAH = @MAH
				select @soluongban = inserted.SOLUONGB from inserted

				IF(@soluong < @soluongban)
					BEGIN
						RAISERROR('ban ko du hang', 16,1)
						ROLLBACK TRANSACTION
					END
				ELSE
					UPDATE hang SET soluong = @soluong - @soluongban
					WHERE MAH = @MAH
			END
	END

DROP TRIGGER trg_insert_hoadon
SELECT * FROM HANG
SELECT * FROM HOADON
INSERT INTO HOADON VALUES('HD04', 'H02', 3,'2021-06-07')
GO
--Câu 1 (5đ). Viết trigger kiểm soát việc Delete bảng HOADON, Hãy cập nhật lại
--soluong trong bảng HANG với: SOLUONG =SOLUONG +
--DELETED.SOLUONGBAN

CREATE TRIGGER trg_delete_hoadon
ON HOADON
FOR DELETE
AS
	BEGIN
		DECLARE @MAH char(10)
		SET @MAH = (SELECT MAH FROM deleted)
		DECLARE @SOLUONGBAN INT
		SET @SOLUONGBAN = (SELECT SOLUONGB FROM deleted)

		UPDATE HANG
		SET SOLUONG = SOLUONG + @SOLUONGBAN
		WHERE MAH = @MAH
	END

SELECT * FROM HANG
SELECT * FROM HOADON
DELETE FROM HOADON WHERE MAHD = 'HD04'
GO
--Câu 2 (5đ). Hãy viết trigger kiểm soát việc Update bảng HOADON. Khi đó hãy
--update lại soluong trong bảng HANG.

--Hóa đơn mua 100 cái, nhưng cần trả lại 30 cái,
--inserted.soluongban = 70 (sau)
--deleted.soluongban = 100 (truoc)
--sanpham.soluong = sanpham.soluong + 30

--Hóa đơn mua 70 cái nhưng cần mua thêm 50 cái,
--inserted.soluongban = 120 (sau)
--deleted.soluongban = 70 (truoc)
--sanpham.soluong = sanpham.soluong - 50

--sanpham.soluong = sanpham.soluong - (sau - truoc)
CREATE TRIGGER trg_update_hoadon
ON HOADON
FOR UPDATE
AS
	BEGIN
		DECLARE @MAH CHAR(10)
		DECLARE @SOLUONGCO INT
		DECLARE @SOLUONGTRUOC INT
		DECLARE @SOLUONGSAU INT

		SET @MAH = (SELECT MAH FROM inserted)
		SET @SOLUONGCO = (SELECT SOLUONG FROM HANG WHERE MAH = @MAH)
		SET @SOLUONGTRUOC = (SELECT SOLUONGB FROM deleted)
		SET @SOLUONGSAU = (SELECT SOLUONGB FROM inserted)
		--PRINT(@SOLUONGTRUOC)
		--PRINT(@SOLUONGSAU)
		IF(@SOLUONGCO >= (@SOLUONGSAU - @SOLUONGTRUOC))
			BEGIN
				UPDATE HANG
				SET SOLUONG = SOLUONG - (@SOLUONGSAU-@SOLUONGTRUOC)
				WHERE MAH = @MAH
			END
		ELSE
			BEGIN
				RAISERROR(N'KHÔNG ĐỦ HÀNG', 16, 1)
				ROLLBACK TRANSACTION
			END
	END


DROP TRIGGER trg_update_hoadon
SELECT * FROM HANG
SELECT * FROM HOADON
UPDATE HOADON
SET SOLUONGB = 1 WHERE MAHD = 'HD03'