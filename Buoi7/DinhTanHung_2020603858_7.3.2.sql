use QLBanHang
go
--a (1đ). Hãy tạo hàm Đưa ra danh sách các hãng sản xuất có địa chỉ nhập vào từ bàn phím
--(Lưu ý – Dùng hàm Like để lọc).
CREATE FUNCTION DSSP_NhapTheoNgay(@x date, @y date)
RETURNS @bang table (
					MaSP nchar(10),
					TenSP nvarchar(20),
					TenHang nvarchar(20),
					NgayNhap date,
					SoLuongN int,
					DonGiaN money
					)
AS
BEGIN
	INSERT INTO @bang
		SELECT SanPham.MaSP, TenSP, TenHang, NgayNhap, SoLuongN, DonGiaN
		FROM Nhap
			INNER JOIN SanPham on SanPham.MaSP = Nhap.MaSP
			INNER JOIN HangSX on HangSX.MaHangSX = SanPham.MaHangSX
			INNER JOIN PNhap on PNhap.SoHDN = Nhap.SoHDN
		WHERE NgayNhap between @x and @y
	RETURN
END
go

CREATE FUNCTION DSHangSX(@diachi nvarchar(30))
RETURNS table
AS
	RETURN
		SELECT * FROM HangSX
		WHERE DiaChi = @diachi
go

SELECT * FROM dbo.DSHangSX('Korea')
go
--b (1đ). Hãy viết hàm Đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được
--xuất từ năm x đến năm y, với x,y nhập từ bàn phím.
CREATE FUNCTION DSSP_HSX(@x int, @y int)
RETURNS @bang table (
					MaSP nchar(10),
					TenSP nvarchar(20),
					TenHang nvarchar(20),
					NgayXuat date,
					SoLuongX int,
					GiaBan money
					)
AS
BEGIN
	INSERT INTO @bang	
		SELECT SanPham.MaSP, TenSP, TenHang, NgayXuat, SoLuongX, GiaBan
		FROM Xuat
			INNER JOIN SanPham on SanPham.MaSP = Xuat.MaSP
			INNER JOIN PXuat on PXuat.SoHDX = Xuat.SoHDX
			INNER JOIN HangSX on HangSX.MaHangSX = SanPham.MaHangSX
		WHERE YEAR(NgayXuat) between @x and @y
	RETURN
END
go

SELECT * FROM dbo.DSSP_HSX(2019, 2020)
go
--c (2đ). Hãy xây dựng hàm Đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa
--chọn, nếu lựa chọn = 0 thì Đưa ra danh sách các sản phẩm đã được nhập, ngược lại lựa
--chọn = 1 thì Đưa ra danh sách các sản phẩm đã được xuất.
CREATE FUNCTION DSSP_NhapTheoLuaChon(@tenhang nvarchar(20) , @choose int)
RETURNS @bang table (
					MaSP nchar(10),
					TenSP nvarchar(20),
					TenHang nvarchar(20),
					SoLuong int,
					MauSac nvarchar(20),
					GiaBan money,
					DonViTinh nchar(10),
					MoTa nvarchar(max)
					)
AS
BEGIN
	IF(@choose = 0)
		INSERT INTO @bang
			SELECT SanPham.MaSP, TenSP, TenHang,SoLuong,MauSac,GiaBan,DonViTinh,MoTa
			FROM SanPham
				INNER JOIN HangSX on HangSX.MaHangSX = SanPham.MaHangSX
			WHERE TenHang = @tenhang and SoLuong = 0
	ELSE IF(@choose = 1)
		INSERT INTO @bang
			SELECT SanPham.MaSP, TenSP, TenHang,SoLuong,MauSac,GiaBan,DonViTinh,MoTa
			FROM SanPham
				INNER JOIN HangSX on HangSX.MaHangSX = SanPham.MaHangSX
			WHERE TenHang = @tenhang and SoLuong > 0
	RETURN
END
go

SELECT * FROM dbo.DSSP_NhapTheoLuaChon('OPPO', 1)
go
--d (2đ). Hãy xây dựng hàm Đưa ra danh sách các nhân viên đã nhập hàng vào ngày được
--đưa vào từ bàn phím.
CREATE FUNCTION DSNVnhap(@ngaynhap date)
RETURNS table
AS
RETURN
	SELECT NhanVien.* FROM NhanVien
		INNER JOIN PNhap on NhanVien.MaNV = PNhap.MaNV
	WHERE NgayNhap = @ngaynhap
go

SELECT * FROM dbo.DSNVnhap('2020-04-07')
--e (2đ). Hãy xây dựng hàm Đưa ra danh sách các sản phẩm có giá bán từ x đến y, do công
--ty z sản xuất, với x,y,z nhập từ bàn phím.
--f (2đ). Hãy xây dựng hàm không tham biến Đưa ra danh sách các sản phẩm và hãng sản
--xuất tương ứng.