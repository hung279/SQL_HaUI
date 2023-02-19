--SanPham(MaSP, MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa)
--HangSX(MaHangSX, TenHang, DiaChi, SoDT, Email)
--NhanVien(MaNV, TenNV, GioiTinh, DiaChi, SoDT, Email, TenPhong)
--Nhap(SoHDN, MaSP, SoLuongN, DonGiaN)
--PNhap(SoHDN,NgayNhap,MaNV)
--Xuat(SoHDX, MaSP, SoLuongX)
--PXuat(SoHDX,NgayXuat,MaNV)

use master
go

create database QLBanHang
go

use QLBanHang

create table HangSX(
	MaHangSX nchar(10) not null primary key,
	TenHang nvarchar(20) not null,
	DiaChi nvarchar(30),
	soDT nvarchar(20),
	Email nvarchar(30)
)

create table SanPham(
	MaSP nchar(10) not null primary key,
	MaHangSX nchar(10) not null,
	TenSP nvarchar(20) not null,
	SoLuong int,
	MauSac nvarchar(20),
	GiaBan money,
	DonViTinh nchar(10),
	MoTa nvarchar(max),
	constraint FK_SP_MaHangSX foreign key(MaHangSX)
		references HangSX(MaHangSX)
)

create table NhanVien(
	MaNV nchar(10) not null primary key,
	TenNV nvarchar(20) not null,
	GioiTinh nchar(10),
	DiaChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(30),
	TenPhong nvarchar(30)
)

create table PNhap(
	SoHDN nchar(10) not null primary key,
	NgayNhap date,
	MaNV nchar(10) not null,
	constraint FK_PN_MaNV foreign key(MaNV)
		references NhanVien(MaNV)
)

create table Nhap(
	SoHDN nchar(10) not null,
	MaSP nchar(10) not null,
	SoLuongN int,
	DonGiaN money,
	constraint PK_SoHDN_MaSP primary key(SoHDN, MaSP),
	constraint FK_Nhap_SoHDN foreign key(SoHDN)
		references PNhap(SoHDN),
	constraint FK_Nhap_MaSP foreign key(MaSP)
		references SanPham(MaSP)
)

create table PXuat(
	SoHDX nchar(10) not null primary key,
	NgayXuat date,
	MaNV nchar(10) not null,

	constraint FK_PX_MaNV foreign key(MaNV)
		references NhanVien(MaNV)
)

create table Xuat(
	SoHDX nchar(10) not null,
	MaSP nchar(10) not null,
	SoLuongX int,

	constraint PK_SoHDX_MaSP primary key(SoHDX, MaSP),
	constraint FK_Xuat_SoHDX foreign key(SoHDX)
		references PXuat(SoHDX),
	constraint FK_Xuat_MaSP foreign key(MaSP)
		references SanPham(MaSP)
)

go

insert into HangSX values
	('H01', 'Samsung', N'Korea', '011-08271717', 'ss@gmail.com.kr'),
	('H02', 'OPPO', N'China', '081-08626262', 'oppo@gmail.com.cn'),
	('H03', 'Vinfone', N'Việt nam', '084-098262626', 'vf@gmail.com.vn')

insert into SanPham values
	('SP01', 'H02', 'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp'),
	('SP02', 'H01', 'Galaxy Note11', 50, N'Đỏ', 19000000, N'Chiếc', N'Hàng cao cấp'),
	('SP03', 'H02', 'F3 lite', 200, N'Nâu', 3000000, N'Chiếc', N'Hàng phổ thông'),
	('SP04', 'H03', 'Vjoy3', 200, N'Xám', 1500000, N'Chiếc', N'Hàng phổ thông'),
	('SP05', 'H01', 'Galaxy V21', 500, N'Nâu', 8000000, N'Chiếc', N'Hàng cận cao cấp')

insert into NhanVien values
	('NV01', N'Nguyễn Thị Thu', N'Nữ', N'Hà Nội', '0982626521', 'thu@gmail.com', N'Kế toán'),
	('NV02',N'Lê Văn Nam',N'Nam',N'Bắc Ninh','0972525252','nam@gmail.com',N'Vật tư'),
	('NV03',N'Trần Hòa Bình',N'Nữ',N'Hà Nội','0328388388','hb@gmail.com',N'Kế toán')

insert into PNhap values
	('N01', '2019-2-5', 'NV01'),
	('N02', '2020-4-7', 'NV02'),
	('N03', '2019-5-17', 'NV02'),
	('N04', '2019-3-22', 'NV03'),
	('N05', '2019-7-7', 'NV01')


insert into Nhap values
	('N01', 'SP02', 10, 17000000),
	('N02', 'SP01', 30,  6000000),
	('N03', 'SP04', 20, 1200000),
	('N04', 'SP01', 10, 6200000),
	('N05', 'SP05', 20, 7000000)


insert into PXuat values
	('X01', '2020-6-14', 'NV02'),
	('X02', '2019-3-5', 'NV03'),
	('X03', '2019-12-12', 'NV01'),
	('X04', '2019-6-2', 'NV02'),
	('X05', '2019-5-18', 'NV01')


insert into Xuat values
	('X01', 'SP03', 5),
	('X02', 'SP01', 3),
	('X03', 'SP02', 1),
	('X04', 'SP03', 2),
	('X05', 'SP05', 1)

go

use QLBanHang
go
--a

select * from HangSX
select * from SanPham
select * from NhanVien
select * from PNhap
select * from Nhap
select * from PXuat
select * from Xuat

go


--Hãy tạo các Trigger kiểm soát ràng buộc toàn vẹn và kiểm tra ràng buộc dữ liệu sau:
--a (1đ). Tạo Trigger cho việc cập nhật lại số lượng xuất trong bảng xuất, hãy kiểm tra xem
--số lượng xuất thay đổi có nhỏ hơn SoLuong trong bảng SanPham hay ko? số bản ghi thay
--đổi >1 bản ghi hay không? nếu thỏa mãn thì cho phép Update bảng xuất và Update lại
--SoLuong trong bảng SanPham.

create trigger trg_update_sl_xuat
on Xuat
for update
as
	begin
		if(@@ROWCOUNT > 1)
			begin
				raiserror('Chi cap nhat 1 ban ghi', 16,1 )
				rollback transaction
			end
		else
			begin
				declare @masp nchar(10)
				declare @soluongco int
				declare @soluongtruoc int
				declare @soluongsau int
				set @masp = (select SanPham.MaSP From SanPham inner join inserted on inserted.MaSP = SanPham.MaSP)
				set @soluongco = (select SoLuong from SanPham where MaSP = @masp)
				set @soluongtruoc = (select SoLuongX from deleted)
				set @soluongsau = (select SoLuongX from inserted)
				if(@soluongco >= (@soluongsau-@soluongtruoc))
					begin
						update SanPham
						set SoLuong = SoLuong - (@soluongsau-@soluongtruoc)
						from SanPham
						where MaSP = @masp
					end
			end
	end

select * from SanPham
select * from Xuat

update Xuat
set SoLuongX = 3
where SoHDX = 'X01'

select * from SanPham
select * from Xuat
go
--b (1đ). Tạo Trigger kiểm soát việc nhập dữ liệu cho bảng nhập, hãy kiểm tra các ràng buộc
--toàn vẹn: MaSP có trong bảng sản phẩm chưa? Kiểm tra các ràng buộc dữ liệu: SoLuongN
--và DonGiaN>0? Sau khi nhập thì SoLuong ở bảng SanPham sẽ được cập nhật theo.

create or alter trigger trg_insert_nhap
on Nhap
for insert
as
	begin
		declare @masp nchar(10)
		declare @soluongnhap int, @dongianhap money
		select @masp = MaSP, @soluongnhap = SoLuongN, @dongianhap = DonGiaN From inserted
		if(not exists(Select * from SanPham where MaSP = @masp))
			begin
				raiserror('Khong co san pham trong bang san pham', 2, 1)
				rollback transaction
			end
		else
			if(@soluongnhap <= 0 or @dongianhap <= 0)
				begin
					raiserror('Nhap so luong > 0 hoac don gia > 0', 2 ,1)
					rollback transaction
				end
			else
				update SanPham
				set SoLuong = SoLuong + @soluongnhap
				where MaSP = @masp
	end


Select * From SanPham
Select * From NhanVien
Select * From Nhap
-- Nhập sai:
alter table Nhap nocheck constraint FK_Nhap_SoHDN, FK_Nhap_MaSP
Insert Into Nhap Values('N06','SP07', 2, 1500000)

-- Nhập đúng:
Insert Into Nhap Values('N06','SP01', 300,1500000)
Select * From nhap
Select * From SanPham
go
--c (2đ). Tạo Trigger kiểm soát việc nhập dữ liệu cho bảng xuất, hãy kiểm tra các ràng buộc
--toàn vẹn: MaSP có trong bảng sản phẩm chưa? kiểm tra các ràng buộc dữ liệu: SoLuongX
--< SoLuong trong bảng SanPham? Sau khi xuất thì SoLuong ở bảng SanPham sẽ được cập
--nhật theo.

create or alter trigger trg_insert_xuat
on Xuat
for insert
as
	begin
		declare @masp nchar(10), @soluongxuat int, @soluongco int
		set @masp = (select MaSp from inserted)
		set @soluongxuat = (select SoLuongX from inserted)
		set @soluongco = (select SoLuong from SanPham where MaSP = @masp)
		if(not exists(Select * from SanPham where MaSP = @masp))
			begin
				raiserror('Khong co san pham trong bang san pham', 2, 1)
				rollback transaction
			end
		else
			if(@soluongxuat > @soluongco)
				begin
					raiserror('Khong du so luong de xuat', 2 ,1)
					rollback transaction
				end
			else
				update SanPham
				set SoLuong = SoLuong - @soluongxuat
				where MaSP = @masp
	end
Select * From SanPham
Select * From Xuat
-- Nhập sai:
alter table Xuat nocheck constraint FK_Xuat_SoHDX, FK_Xuat_MaSP
Insert Into Xuat Values('X06','SP07', 2)

-- Nhập đúng:
Insert Into Xuat Values('X06','SP05', 300)
Select * From Xuat
Select * From SanPham
go
--d (2đ). Tạo Trigger kiểm soát việc xóa phiếu xuất, khi phiếu xuất xóa thì số lượng hàng
--trong bảng SanPham sẽ được cập nhật tăng lên.

create or alter trigger trg_delete_xuat
on Xuat
for delete
as
	begin
		declare @sohdx nchar(10)
		set @sohdx = (select SoHDX from deleted)
		if(not exists(select * from Xuat where SoHDX = @sohdx))
			begin
				raiserror('Khong co phieu xuat nay trong bang xuat', 2, 1)
				rollback transaction
			end
		else
			begin
				declare @masp nchar(10), @soluongxuat int
				set @soluongxuat = (select SoLuongX from deleted)
				set @masp = (select MaSP from deleted)

				update SanPham
				set SoLuong = SoLuong + @soluongxuat
				where MaSP = @masp
			end
	end


-- Nhập đúng:
delete from Xuat where SoHDX = 'X06'
Select * From Xuat
Select * From SanPham
go
--e (2đ). Tạo Trigger cho việc cập nhật lại số lượng Nhập trong bảng Nhập, Hãy kiểm tra
--xem số bản ghi thay đổi >1 bản ghi hay không? nếu thỏa mãn thì cho phép Update bảng
--Nhập và Update lại SoLuong trong bảng SanPham.

create or alter trigger trg_update_sl_Nhap
on Nhap
for update
as
	begin
		if(@@ROWCOUNT > 1)
			begin
				raiserror('Chi cap nhat 1 ban ghi', 16,1 )
				rollback transaction
			end
		else
			begin
				declare @masp nchar(10)
				declare @soluongco int
				declare @soluongtruoc int
				declare @soluongsau int
				set @masp = (select SanPham.MaSP From SanPham inner join inserted on inserted.MaSP = SanPham.MaSP)
				set @soluongco = (select SoLuong from SanPham where MaSP = @masp)
				set @soluongtruoc = (select SoLuongN from deleted)
				set @soluongsau = (select SoLuongN from inserted)
				if(@soluongco >= (@soluongsau-@soluongtruoc))
					begin
						update SanPham
						set SoLuong = SoLuong + (@soluongsau-@soluongtruoc)
						from SanPham
						where MaSP = @masp
					end
			end
	end

update Nhap
set SoLuongN = 120
where SoHDN = 'N02'
select * from SanPham
select * from Nhap
go
--f (2đ). Tạo Trigger kiểm soát việc xóa phiếu nhập, khi phiếu nhập xóa thì số lượng hàng
--trong bảng SanPham sẽ được cập nhật giảm xuống.

create or alter trigger trg_delete_nhap
on Nhap
for delete
as
	begin
		
				declare @masp nchar(10), @soluongnhap int
				set @soluongnhap = (select SoLuongN from deleted)
				set @masp = (select MaSP from deleted)

				update SanPham
				set SoLuong = SoLuong - @soluongnhap
				where MaSP = @masp
			
	end


-- Nhập đúng:
delete from Nhap where SoHDN = 'N05'
Select * From Nhap
Select * From SanPham