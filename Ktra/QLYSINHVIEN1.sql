use master
go

create database QLSinhVien
go

use QLSinhVien
go

create table Khoa (
	MaKhoa char(5) not null primary key,
	TenKhoa nvarchar(30),
	Diachi nvarchar(50),
	SoDT varchar(15)
)

create table Lop (
	MaLop char(5) not null primary key,
	TenLop nvarchar(30),
	Siso int,
	MaKhoa char(5) foreign key (MaKhoa) references Khoa(MaKhoa)
)

create table SinhVien(
	MaSV char(5) not null primary key,
	HoTen nvarchar(30),
	NgaySinh date,
	Gioitinh bit,
	MaLop char(5) foreign key (MaLop) references Lop(MaLop)
)

insert into Khoa values
('K01', 'Khoa CNTT', 'Hà Nội', '0913245678'),
('K02', 'Khoa Dien', 'Hà Nội', '0913222678')

insert into Lop values
('L01', 'CNTT01', 70, 'K01'),
('L02', 'DIEN1', 65, 'K02')

insert into SinhVien values
('SV01', 'Nguyen Van A', '2002-02-01', 1, 'L01'),
('SV02', 'Nguyen Van B', '2002-09-07', 1, 'L01'),
('SV03', 'Nguyen Van C', '2002-03-15', 0, 'L02'),
('SV04', 'Nguyen Van D', '2002-05-29', 1, 'L02'),
('SV05', 'Nguyen Van E', '2002-06-11', 0, 'L01')

select * from Khoa
select * from Lop
select * from SinhVien
go

create or alter function fn_cau2 (@tenkhoa nvarchar(30))
returns @bang table(MaSV char(5),
					HoTen nvarchar(30),
					Tuoi int)
as
begin
	insert into @bang
	select MaSV, HoTen,  Tuoi = YEAR(GETDATE()) - YEAR(NgaySinh)
	from SinhVien
	inner join Lop
	on Lop.MaLop = SinhVien.MaLop
	inner join Khoa
	on Khoa.MaKhoa = Lop.MaKhoa
	where TenKhoa = @tenkhoa

	return
end

select * from dbo.fn_cau2('Khoa CNTT')
go

create function cau2_2 (@tenlop nvarchar(30))
returns int
as
begin
	declare @sl int
	set @sl = (select Siso from Lop where TenLop = @tenlop)
	return @sl
end

select dbo.cau2_2('CNTT01')

---cau3
create proc cau3(@tutuoi int, @dentuoi int, @tenlop nvarchar(30))
as
begin
	select MaSV, HoTen, NgaySinh, TenLop, TenKhoa, Tuoi = YEAR(GETDATE()) - YEAR(NgaySinh)
	from SinhVien
	inner join Lop
	on Lop.MaLop = SinhVien.MaLop
	inner join Khoa
	on Khoa.MaKhoa = Lop.MaKhoa
	where TenLop = @tenlop and YEAR(GETDATE()) - YEAR(NgaySinh) between @tutuoi and @dentuoi
end
go
exec cau3 19, 21, 'DIEN1'

create proc cau3_2(@tutuoi int, @dentuoi int, @tenlop nvarchar(30), @kq int output)
as
begin
	if(not exists (select * from Lop where TenLop = @tenlop))
		begin
			print('Khong co lop nay')
			set @kq = 0
		end
	else
		begin
			set @kq = 1
			select MaSV, HoTen, NgaySinh, TenLop, TenKhoa, Tuoi = YEAR(GETDATE()) - YEAR(NgaySinh)
			from SinhVien
			inner join Lop
			on Lop.MaLop = SinhVien.MaLop
			inner join Khoa
			on Khoa.MaKhoa = Lop.MaKhoa
			where TenLop = @tenlop and YEAR(GETDATE()) - YEAR(NgaySinh) between @tutuoi and @dentuoi
		end
	return @kq
end

declare @ketqua1 int
exec cau3_2 19, 21, 'DIEN1', @ketqua1 output
select @ketqua1


---cau4
create or alter trigger trg_cau4
on SinhVien
for insert
as
begin
	declare @malop char(5)
	set @malop = (select MaLop from inserted)
	declare @siso int
	set @siso = (select Siso from Lop where MaLop = @malop)
	if(@siso > 70)
		begin
			raiserror('Khong them dc sinh vien', 16, 1)
			rollback transaction
		end
	else
		begin
			update lop
			set Siso = Siso + 1
			where MaLop = @malop
		end
end

--thanh cong
insert into SinhVien values
('SV06', 'Nguyen Van F', '2002-09-01', 1, 'L01')
select * from Lop
select * from SinhVien

--that bai
insert into SinhVien values
('SV07', 'Nguyen Van G', '2002-10-01', 1, 'L02')
select * from Lop
select * from SinhVien