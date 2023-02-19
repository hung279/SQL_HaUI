use master
go

create database QLBH
go

use QLBH
go

create table SANPHAM (
	MaSP char(5) not null primary key,
	TenSP nvarchar(30),
	SoLuong int,
	DonGia money,
	MauSac nvarchar(20)
)

create table NHAP (
	SoHDN char(5) not null,
	MaSP char(5) not null,
	NgayN date,
	SoLuongN int,
	DonGiaN money,
	constraint PK_SoHDN_MaSP primary key(SoHDN, MaSP),
	constraint FK_Nhap_MaSP foreign key(MaSP)
		references SANPHAM(MaSP)
)

create table XUAT (
	SoHDX char(5) not null,
	MaSP char(5) not null,
	NgayX date,
	SoLuongX int,
	constraint PK_SoHDX_MaSP primary key(SoHDX, MaSP),
	constraint FK_Xuat_MaSP foreign key(MaSP)
		references SANPHAM(MaSP)
)

insert into SANPHAM values
	('SP01', 'F1 Plus', 100, 7000000, N'Xám'),
	('SP02', 'F2 Plus', 70, 2000000, N'Đen'),
	('SP03', 'F3 Plus', 50, 3000000, N'Đỏ'),
	('SP04', 'F4 Plus', 62, 5000000, N'Xám'),
	('SP05', 'F6 Plus', 105, 8000000, N'Xanh')

insert into NHAP values
	('N01', 'SP01', '2022/2/5', 100, 600000),
	('N02', 'SP03', '2021-12-25', 70, 100000),
	('N03', 'SP04', '2022-1-5', 80, 200000)

insert into XUAT values
	('X01', 'SP01', '2022-5-25', 13),
	('X02', 'SP02', '2022-1-25', 8),
	('X03', 'SP04', '2022-2-28', 10)
go

select * from SANPHAM
select * from NHAP
select * from XUAT
go

--Câu 2. Tạo hàm đưa ra masp,tensp,mausac,soluongX,Dongia, tienban
--(soluongX*Dongia) của các mặt hàng có ngày Xuất được nhập từ bàn phím.

create or alter function cau2 (@ngayx date)
returns @bang table (MaSP char(5), TenSP nvarchar(30),
					MauSac nvarchar(20), SoLuongX int,
					DonGia money, TienBan money)
as
begin
	insert into @bang 
		select SANPHAM.MaSP, TenSP, MauSac, SoLuongX, DonGia, SoLuongX*DonGia
		from XUAT
			inner join SANPHAM ON SANPHAM.DonGia = XUAT.MaSP
		where NgayX = @ngayx
	return
end
go

select * from cau2('2022-5-25')
go

--Câu 3. Tạo thủ tục Cập nhật dữ liệu cho bảng Nhập với các tham biến truyền vào là
--SoHDN, MaSP, SoluongN, DonGiaN. Hãy kiểm tra xem MaSP có trong bảng SanPham
--hay không? Nếu không thì trả về 1, ngược lại cho phép cập nhật theo SoHDN và trả về 0.
create proc Cau3 (@sohdn char(5), @masp char(5), @soluongn int, @dongian money, @kq int output)
as
begin
	if(exists (select * from SANPHAM where MaSP = @masp))
		begin
			update NHAP
			set SoLuongN = @soluongn, DonGiaN = @dongian
			where SoHDN = @sohdn
			set @kq = 0
		end
	else
		begin
			set @kq = 1
		end
	return @kq
end
go

--cong ty ton tai
declare @Ketqua1 int
EXEC Cau3 'N02', 'SP05', 69, 110000, @Ketqua1 output
select @Ketqua1

--cong ty chua ton tai
declare @Ketqua2 int
EXEC Cau3 'N02', 'SP06', 69, 110000, @Ketqua2 output
select @Ketqua2
go

--Câu 4. Tạo trigger kiểm soát việc Nhập, Hãy kiểm tra xem Masp cần nhập có trong bảng
--SanPham hay không? kiểm tra xem DongiaN < dongia hay không? Nếu không đưa ra TB,
--ngược lại cho phép nhập và cập nhật lại soluong trong bảng sanpham.

create or alter trigger cau4
on NHAP
for insert
as
begin
	declare @masp char(5)
	declare @dongia money
	declare @dongian money

	set @masp = (select MaSP from inserted)
	if(not exists (select * from SANPHAM where MaSP =@masp))
		begin
			raiserror('Khong co trong bang sp', 2, 1)
			rollback transaction
		end
	else
		begin
			set @dongia = (select DonGia from SANPHAM where MaSP =@masp)
			set @dongian = (select DonGiaN from inserted)
			declare @soluongn int
			set @soluongn = (select SoLuongN from inserted)
			if(@dongian > @dongia)
				begin
					update SANPHAM
					set SoLuong = SoLuong + @soluongn
					where MaSP = @masp
				end
			else
				begin
					raiserror(N'KHÔNG NHẬP ĐƯỢC VÌ DONGIAN < DONGIA', 16, 1)
					rollback transaction
				end
		end
end


alter table NHAP nocheck constraint FK_Nhap_MaSP
insert into NHAP values
	('N05', 'SP07', '2022-3-8', 100, 40000000)
select * from SANPHAM
select * from NHAP