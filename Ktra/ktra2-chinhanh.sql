use master
go

CREATE DATABASE QLBanHang
go

use QLBanHang
go

--cau1
create table ChiNhanh (
	MaChiNhanh char(10) not null primary key,
	TenChiNhanh nvarchar(50) not null,
	DiaChi nvarchar(30)
)

create table SanPham(
	MaSanPham char(10) not null primary key,
	TenSanPham nvarchar(30) not null,
	MauSac nvarchar(20),
	SoLuongCo int,
	GiaBan money
)

CREATE TABLE CungUng(
	MaChiNhanh char(10) NOT NULL,
	MaSanPham char(10) NOT NULL,
	SoLuongCungUng int,
	NgayCungUng date,
	Constraint PK_CungUng primary key (MaChiNhanh, MaSanPham),
	Constraint FK_CungUng_ChiNhanh foreign key (MaChiNhanh) references ChiNhanh(MaChiNhanh),
	Constraint FK_CungUng_SanPham foreign key (MaSanPham) references SanPham(MaSanPham),
)

INSERT INTO ChiNhanh VALUES
('CN01', 'CONG TY A', N'Hà Nội'),
('CN02', 'CONG TY B', N'Yên Bái'),
('CN03', 'CONG TY C', N'Hà Nội')

INSERT INTO SanPham VALUES
('SP01', 'Tivi', N'Đen', 15, 300000),
('SP02', N'Tủ lạnh', N'Trắng', 9, 200000),
('SP03', N'Điện thoại', N'Đỏ', 18, 500000)

INSERT INTO CungUng VALUES
('CN01', 'SP03', 8, '2021-8-9'),
('CN02', 'SP03', 6, '2021-12-9'),
('CN02', 'SP01', 10, '2022-1-2'),
('CN03', 'SP02', 4, '2022-1-15'),
('CN03', 'SP01', 5, '2022-1-29')

select * from ChiNhanh
select * from SanPham
select * from CungUng
go


--cau2
create proc cau2(@macn char(10), @tencn nvarchar(30), @diachi nvarchar(50), @kq int output)
as
begin
	if(exists (select * from ChiNhanh where TenChiNhanh = @tencn))
		begin
			set @kq = 1
			print 'Ten chi nhanh da ton tai'
		end
	else
		begin
			insert into ChiNhanh values
			(@macn, @tencn, @diachi)
			set @kq = 0
		end
	return @kq
end

--cong ty ton tai
declare @Ketqua1 int
EXEC cau2 'CN04', N'CONG TY B', N'Hà Nam', @Ketqua1 output
select @Ketqua1

--cong ty chua ton tai
declare @Ketqua2 int
EXEC cau2 'CN05', N'CONG TY E', N'Hà Nam', @Ketqua2 output
select @Ketqua2
go


--cau3
create or alter trigger cau3
on CungUng
for update
as
begin
	declare @masp char(10)
	declare @soluongco int
	declare @soluongtruoc int
	declare @soluongsau int

	set @masp = (select MaSanPham from inserted)
	set @soluongco = (select SoLuongCo from SanPham where MaSanPham = @masp)
	set @soluongtruoc = (select SoLuongCungUng from deleted)
	set @soluongsau = (select SoLuongCungUng from inserted)

	if(@soluongco >= (@soluongsau - @soluongtruoc))
		begin
			update SanPham
			set SoLuongCo = @soluongco - (@soluongsau - @soluongtruoc)
			where MaSanPham = @masp
		end
	else
		begin
			raiserror(N'KHÔNG ĐỦ HÀNG', 16, 1)
			rollback transaction
		end
end

--khong thanh cong
update CungUng
set SoLuongCungUng = 40
where MaChiNhanh = 'CN01' and MaSanPham = 'SP03'

--thanh cong
update CungUng
set SoLuongCungUng = 12
where MaChiNhanh = 'CN02' and MaSanPham = 'SP01'

select * from SanPham
select * from CungUng
