create database BanHangontap1
use BanHangontap1
go

create table DocGia(
	MaDG char(10) not null primary key,
	TenDG nvarchar(50),
	Diachi nvarchar(50),
	SoDT char(20)
)

create table Sach(
	MaS char(10) not null primary key,
	TenS nvarchar(50),
	soluong int,
	nhaXB nvarchar(50),
	namXB char(20)
)

create table Phieumuon(
	MaPM char(10) not null primary key,
	MaS char(10) not null,
	MaDG char(10) not null,
	SoluongMuon int,
	ngayM char(50),
	constraint fk_DG foreign key (MaDG)
		references DocGia(MaDG),
	constraint fk_Sach foreign key (MaS)
		references Sach(MaS)
)

insert into DocGia values
('DG001',N'Nguyễn Văn A', N'Hà Nội', '0123456789'),
('DG002',N'Nguyễn Văn B', N'Bắc Giang', '0123456789'),
('DG003',N'Nguyễn Văn C', N'Hải Phòng', '0123456789')

insert into Sach values
('MS001', N'Đắc nhân tâm1', 20,N'Kim Đồng', '2012'),
('MS002', N'Đắc nhân tâm2',15,N'Nhã Nam', '2018'),
('MS003', N'Đắc nhân tâm3', 50,N'SKYBOOKS', '2020')

insert into Phieumuon values
('PM001', 'MS001', 'DG002', 10,'2012-20-02' ),
('PM002', 'MS002', 'DG002', 30,'2019-15-02' ),
('PM003', 'MS002', 'DG003', 15,'2012-30-01' ),
('PM004', 'MS003', 'DG001', 15,'2019-20-01' ),
('PM005', 'MS001', 'DG003', 20,'2015-10-02' )
go
--c2-

create or alter Function fn_ThongKe (@MaDG char(10))
returns int
as
begin
	declare @tong int
	set @tong = (select SUM(SoLuongMuon) from Phieumuon
					where MaDG = @MaDG
					group by MaDG)
	return @tong
end
go

select dbo.fn_ThongKe('DG003') as N'Số lượng';
go
--c3--
ALTER PROC sp_themPM(@maPM nchar(10), @tenSach nvarchar(30), @tenDG nvarchar(30), @soLuongM int, @ngayM date)
AS
BEGIN
    if(not exists(select*from DOCGIA where tenDG = @tenDG))
        print N'Độc giả không tồn tại'
    else if(not exists(select*from SACH where tenSach = @tenSach))
        print N'Sách không tồn tại'
    else 
        BEGIN
            DECLARE @maS nchar(10)
            DECLARE @maDG nchar(10)
            SET @maS = (select maSach from SACH where tenSach = @tenSach)
            SET @maDG = (select maDG from DOCGIA where tenDG = @tenDG)
            INSERT into PhieuMuon VALUES(@maPM, @maS, @maDG,@soLuongM,@ngayM)
        END
END

exec sp_themPM 'PM01','D','Nguyen Van A', 12, '02/20/2022'
select*from PhieuMuon
		
--cau4--

create or alter trigger trg_delete_phieumuon
on Phieumuon
for delete
as
	begin
			begin
				declare @mas nchar(10), @soluongmuon int
				set @soluongmuon = (select SoLuongMuon from deleted)
				set @mas = (select MaS from deleted)

				update Sach
				set soluong = soluong + @soluongmuon
				where MaS = @mas
			end
	end

--test tirgger
Select * From Sach
Select * From Phieumuon

delete from Phieumuon where MaPM = 'PM002'
Select * From Sach
Select * From Phieumuon
