--Cau1
CREATE TRIGGER trg_xoadonhang
On hoadon
FOR DELETE
AS
	BEGIN
		UPDATE hang SET soluong = soluong+ deleted.soluongban FROM hang INNER JOIN
		deleted ON hang.mahang = deleted.mahang WHERE hang.mahang =
		deleted.mahang
	END
--Gọi trigger
 SELECT * FROM hang
 SELECT * FROM hoadon
 DELETE FROM hoadon WHERE mahd=1
 SELECT * FROM hang
 SELECT * FROM hoadon

--Câu 2.
 CREATE TRIGGER trg_capnhathoadon
 ON hoadon
 FOR UPDATE
 AS
	BEGIN
		 DECLARE @truoc int
		 DECLARE @sau int

		 SELECT @truoc = deleted.soluongban FROM deleted

		 SELECT @sau=inserted.soluongban FROM inserted

		UPDATE hang SET soluong=soluong -(@sau-@truoc)
		FROM hang INNER JOIN inserted ON hang.mahang = inserted.mahang
	END
--Gọi trigger
 SELECT * FROM hang
 SELECT * FROM hoadon
 UPDATE hoadon SET soluongban = soluongban-5 WHERE mahang=3
 SELECT * FROM hang
 SELECT * FROM hoadon