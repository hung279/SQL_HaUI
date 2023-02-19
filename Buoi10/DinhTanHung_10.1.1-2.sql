use master

create database QLBH
go

use QLBH
go

create table MatHang(
	MaHang nchar(10) primary key,
	TenHang nvarchar(30),
	SoLuong int
)

create table NhatKyBanHang(
	STT int not null primary key,
	Ngay datetime,
	NguoiMua nvarchar(30),
	MaHang nchar(10) not null,
	SoLuong int,
	GiaBan money

	constraint FK_MaHang foreign key(MaHang) references MatHang(MaHang)
)

insert into MatHang values(N'1', N'Keo', 100)
insert into MatHang values(N'2', N'Banh', 200)
insert into MatHang values(N'3', N'Thuoc', 100)

select * from MatHang
select * from NhatKyBanHang


--Câu 3 (7đ)Tạo các trigger:
--a. trg_nhatkybanhang_insert. Trigger này có chức năng tự động giảm số lượng
--hàng hiện có (Trong bảng MATHANG) khi một mặt hàng nào đó được bán (tức
--là khi câu lệnh INSERT được thực thi trên bảng NHATKYBANHANG).

create trigger trg_nhatkybanhang_insert
on NhatKyBanHang
for insert
as
	begin
		update MatHang
		set SoLuong = MatHang.SoLuong - inserted.SoLuong
		from MatHang
			inner join inserted
				on MatHang.MaHang = inserted.MaHang
	end

select * from MatHang
select * from NhatKyBanHang

insert into NhatKyBanHang values
(1, '2021-2-9','ab','2',30,50)

select * from MatHang
select * from NhatKyBanHang
go
--b. trg_nhatkybanhang_update_soluong được kích hoạt khi ta tiến hành cập nhật
--cột SOLUONG cho một bản ghi của bảng NHATKYBANHANG (lưu ý là chỉ
--cập nhật đúng một bản ghi).

create trigger trg_nhatkybanhang_update_soluong
on NhatKyBanHang
for update
as
	begin
		update MatHang
		set SoLuong = MatHang.SoLuong - (inserted.SoLuong - deleted.SoLuong)
		from inserted
			inner join deleted
				on deleted.MaHang = inserted.MaHang
			inner join MatHang
				on MatHang.MaHang = inserted.MaHang
	end

select * from MatHang
select * from NhatKyBanHang

update NhatKyBanHang
set SoLuong = 15
where MaHang = '2'

select * from MatHang
select * from NhatKyBanHang
--c. Trigger dưới đây được kích hoạt khi câu lệnh INSERT được sử dụng để bổ sung
--một bản ghi mới cho bảng NHATKYBANHANG. Trong trigger này kiểm tra
--điều kiện hợp lệ của dữ liệu là số lượng hàng bán ra phải nhỏ hơn hoặc bằng số
--lượng hàng hiện có. Nếu điều kiện này không thoả mãn thì huỷ bỏ thao tác bổ
--sung dữ liệu.

create trigger trg_dk_soluong_insert
on NhatKyBanHang
for insert
as
	begin
		declare @soluongco int
		declare @soluongban int

		set @soluongco = (select MatHang.SoLuong from MatHang
								inner join inserted on MatHang.MaHang = inserted.MaHang)
		set @soluongban = (select SoLuong from inserted)

		if(@soluongban > @soluongco)
			begin
				raiserror('Khong du so luong de ban', 16, 1)
				rollback transaction
			end
		else
			update MatHang
			set SoLuong = MatHang.SoLuong - inserted.SoLuong
			from MatHang
				inner join inserted on MatHang.MaHang = inserted.MaHang
	end

select * from MatHang
select * from NhatKyBanHang

insert into NhatKyBanHang values
(2, '2020-2-9','ab','3',20,100)

select * from MatHang
select * from NhatKyBanHang
go

--d. Trigger dưới đây nhằm để kiểm soát lỗi update bảng nhatkybanhang, nếu update
-->1 bản ghi thì thông báo lỗi(Trigger chỉ làm trên 1 bản ghi), quay trở về. Ngược
--lại thì update lại số lượng cho bảng mathang.

--e. Hãy tao Trigger xoa 1 ban ghi bang nhatkybanhang, neu xoa nhieu hon 1 record
--thi hay thong bao loi xoa ban ghi, nguoc lai hay update bang mathang voi cot so
--luong tang len voi ma hang da xoa o bang nhatkybanhang.
--f. Tạo Trigger cập nhật bảng nhật ký bán hàng, nếu cập nhật nhiều hơn 1 bản ghi
--thông báo lỗi và phục hồi phiên giao dịch, ngược lại kiểm tra xem nếu giá trị số
--lượng cập nhật <giá trị số lượng có thì thông báo lỗi sai cập nhật, ngược lại nếu nếu
--giá trị số lượng cập nhật =giá trị số lượng có thì thông báo không cần cập nhật ngược
--lại thì hãy cập nhật giá trị.

create trigger trg_update_nhatkybanhang
on NhatKyBanHang
for update
as
	begin
		if((select COUNT(*) from inserted) > 1)
			begin
				raiserror(N'Chỉ được phép cập nhật 1 bản ghi', 16, 1)
				rollback transaction
			end
		else
			begin
				declare @MaHang nchar(10)
				declare @SoLuongTruoc int
				declare @SoLuongSau int
				declare @SoLuongCo int

				set @MaHang = (select MaHang from inserted)
				set @SoLuongTruoc = (select SoLuong from deleted where MaHang = @MaHang)
				set @SoLuongSau = (select SoLuong from inserted where MaHang = @MaHang)
				set @SoLuongCo = (select SoLuong from MatHang where MaHang = @MaHang)

				if(@SoLuongCo >= (@SoLuongSau - @SoLuongTruoc))
					begin
						update MatHang
						set SoLuong = SoLuong - (@SoLuongSau - @SoLuongTruoc)
						where MaHang = @MaHang
					end
				else
					begin
						raiserror(N'Không đủ số lượng để xuất', 16, 1)
						rollback transaction
					end
			end
	end

select * from MatHang
select * from NhatKyBanHang
go
disable trigger trg_nhatkybanhang_update_soluong on NhatKyBanHang
update NhatKyBanHang
set SoLuong = 40
where MaHang = '2'
select * from MatHang
select * from NhatKyBanHang
go
--g. Viết thủ tục xóa 1 bản ghi trên bảng mathang, voi mahang được nhập từ bàn phím.
--Kiểm tra xem mahang co tồn tại hay không, nếu không đưa ra thông báo, ngược lại
--hãy xóa, có tác động đến 2 bảng.

create proc Proc_Delete_mathang(@mahang char(10))
as
begin
	if(not exists (Select * from MatHang where MaHang = @mahang))
		print 'Chua co ten hang ' + @mahang + ' trong csdl'
	else
		Begin
			DELETE FROM NhatKyBanHang where MaHang = @mahang
			DELETE FROM MatHang WHERE MaHang = @mahang
		End
end
go

drop proc Proc_Delete_mathang
EXEC Proc_Delete_mathang '3'

--h. Viết 1 hàm tính tổng tiền của 1 mặt hàng có tên hàng được nhập từ bàn phím.
