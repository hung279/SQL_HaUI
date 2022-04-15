create database Lession1

use Lession1
create table sinh_vien(
	masv nvarchar(10) NOT NULL primary key,
	hodem nvarchar(20) NOT NULL,
	ten nvarchar(10) NOT NULL,
	ngaysinh datetime NULL,
	gioitinh bit NOT NULL,
	noisinh nvarchar(50) NULL,
	malop nvarchar(6) NOT NULL
)

create table lop(
	malop nvarchar(6) NOT NULL primary key,
	tenlop nvarchar(20) NOT NULL,
	khoa int NOT NULL,
	hedaotao nvarchar(20) NOT NULL,
	namnhaphoc int NOT NULL,
	siso int NULL,
	makhoa nvarchar(5) NOT NULL
)

create table khoa(
	makhoa nvarchar(5) NOT NULL primary key,
	tenkhoa nvarchar(50) NOT NULL,
	dienthoai nchar(10) NOT NULL
)
