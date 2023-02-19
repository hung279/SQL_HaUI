--a.
CREATE TRIGGER trg_nhatkybanhang_insert
ON nhatkybanhang
FOR INSERT
AS
	UPDATE MATHANG
	SET mathang.soluong=mathang.soluong-inserted.soluong
	FROM mathang INNER JOIN inserted
	ON mathang.mahang=inserted.mahang
--Test:
select * from mathang
select * from nhatkybanhang
insert into nhatkybanhang(ngay, nguoimua, mahang, soluong, giaban)
values('2/9/1999','ab','2',30,50)
select * from mathang
select * from nhatkybanhang
--b.
CREATE TRIGGER trgnhatkybanhangupdatesoluong
ON nhatkybanhang
FOR UPDATE
AS
	 IF UPDATE(soluong)
		 UPDATE mathang
		 SET mathang.soluong = mathang.soluong –
								(inserted.soluong-deleted.soluong)
		 FROM (deleted INNER JOIN inserted ON
				 deleted.stt = inserted.stt) INNER JOIN mathang
				 ON mathang.mahang = deleted.mahang

--c.
CREATE TRIGGER trg_nhatkybanhang_insert
ON NHATKYBANHANG
FOR INSERT
AS begin
	 DECLARE @sl_co int /*Số lượng hàng hiện có*/
	 DECLARE @sl_ban int /* Số lượng hàng được bán*/
	 DECLARE @mahang nvarchar(5) /* Mã hàng được bán*/
	 SELECT @mahang=mahang,@sl_ban=soluong FROM inserted
	 SELECT @sl_co = soluong FROM mathang where mahang=@mahang
	 /*Nếu số lượng hiện có nhỏ hơn SL bán thì huỷ bỏ thao tác thêm dữ liệu */
	 IF @sl_co<@sl_ban
		ROLLBACK TRANSACTION
	 /* Nếu dữ liệu hợp lệ thì giảm số lượng hàng hiện có */
	 ELSE
		UPDATE mathang SET soluong=soluong-@sl_ban WHERE
	mahang=@mahang
	 end
--Test: sinh viên tự làm bộ test cho trigger này.
--d.
create trigger trg_updatenhatkybanhang
on nhatkybanhang
for update
as
	 begin
		 declare @mahang nvarchar(5)
		 declare @truoc int
		 declare @sau int
		 --Kiem tra lenh update tren bao nhieu record, neu >1 thi bao loi

		 if(select COUNT(*) from inserted)>1
			 begin
				 raiserror('Khong duoc sua qua 1 dong lenh',16,1)
				 rollback transaction
				 return
			 end
		 else
			 if UPDATE(soluong)
			 begin
				 select @truoc=soluong from deleted
				 select @sau=soluong from inserted
				 select @mahang=mahang from inserted
				update mathang set soluong=soluong-(@sau-@truoc) where mahang=@mahang
			 end
	 end