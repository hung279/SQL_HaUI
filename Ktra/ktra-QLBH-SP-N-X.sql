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
	NgayN date,
	SoLuongN int,
	DonGiaN money,
	MaSP char(5) not null,
	constraint PK_SoHDN_MaSP primary key(SoHDN, MaSP),
	constraint FK_Nhap_MaSP foreign key(MaSP)
		references SANPHAM(MaSP)
)

create table XUAT (
	SoHDX char(5) not null,
	NgayX date,
	SoLuongX int,
	MaSP char(5) not null,
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
	('N01', '2022/2/5', 100, 600000, 'SP01'),
	('N02', '2021-12-25', 70, 100000, 'SP03'),
	('N03', '2022-1-5', 80, 200000, 'SP04')

insert into XUAT values
	('X01', '2022-5-25', 13, 'SP01'),
	('X02', '2022-1-25', 8, 'SP02'),
	('X03', '2022-2-28', 10, 'SP04')
go
create function Cau2(@tensp nvarchar(30), @ngayx date)
returns float
as
begin
	declare @tong float
		set @tong = (select SUM(SoLuongX*DonGia) from Xuat
						inner join SANPHAM on SANPHAM.MaSP = XUAT.MaSP
					where TenSP = @tensp and NgayX = @ngayx)
		return @tong
end
go

select dbo.Cau2('F2 Plus', '2022-1-25')
go
--cau3
create proc Cau3 (@sohdn char(5), @masp char(5), @soluongn int, @dongian money)
as
begin
	if(exists (select * from SANPHAM where MaSP = @masp))
		begin
			update NHAP
			set SoLuongN = @soluongn, DonGiaN = @dongian
			where SoHDN = @sohdn
		end
	else
		begin
			print N'Không có mã sp ' + @masp + ' trong bản SANPHAM'
		end
end
go

exec Cau3 'N02', 'SP05', 69, 110000
select * from NHAP

--cau4
create trigger trg_cau4
on Xuat
for update
as
begin
	declare @masp char(5)
	declare @soluongco int
	declare @soluongtrc int
	declare @soluongsau int

	set @masp = (select MaSP from inserted)
	if(not exists (select * from SANPHAM where MaSP =@masp))
		begin
			raiserror('Khong co trong bang sp', 2, 1)
			rollback transaction
		end
	else
		begin
			set @soluongco = (select SoLuong from SANPHAM where MaSP = @masp)
			set @soluongtrc = (select SoLuongX from deleted)
			set @soluongsau = (select SoLuongX from inserted)
			if(@soluongco >= (@soluongsau - @soluongtrc))
				begin
					update SANPHAM
					set SoLuong = @soluongco - (@soluongsau - @soluongtrc)
					where MaSP = @masp
				end
			else
				begin
					raiserror(N'KHÔNG ĐỦ HÀNG', 16, 1)
					rollback transaction
				end
		end
end

--khong thanh cong
update XUAT
set SoLuongX = 40
where SoHDX = 'X03' and MaSP = 'SP06'
--thanh cong
update XUAT
set SoLuongX = 40
where SoHDX = 'X03' and MaSP = 'SP04'

select * from SANPHAM
select * from XUAT