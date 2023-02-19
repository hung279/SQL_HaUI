
CREATE TRIGGER trg_insert_hoadon
ON HoaDon
FOR INSERT 
AS 
	BEGIN
		IF(NOT EXISTS(SELECT * FROM hang INNER JOIN inserted
			ON hang.mahang = inserted.mahang))
			BEGIN 
				RAISERROR('loi 0 co hang', 16, 1
				ROLLBACK TRANSACTION
			END
		ELSE
			BEGIN
				DECLARE @soluong int
				DECLARE @soluongban int
				SELECT @soluong = soluong FROM hang INNER JOIN 
				inserted ON hang.mahang = inserted.soluongban
				FROM inserted

				IF(@soluong < @soluongban)
					BEGIN
						RAISERROR('ban ko du hang', 16,1)
						ROLLBACK TRANSACTION
					END
				ELSE
					UPDATE hang SET soluong = soluong - @soluongban
					FROM hang INNER JOIN inserted 
					ON hang.mahang = inserted.mahang
				END
			END

SELECT * FROM hang
SELECT * FROM hoadon
INSERT INTO hoadon VALUES(1,3,25,'2/9/1999')
