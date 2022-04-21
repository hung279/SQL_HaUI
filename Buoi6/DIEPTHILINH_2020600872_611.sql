USE MASTER 
GO

CREATE DATABASE QLKHO
ON PRIMARY (
	NAME = 'QLKHO_mdf',
	SIZE = 2MB,
	MAXSIZE = 10MB,
	FILEGROWTH = 20%
	)

LOG ON (
	NAME = 'QLKHO_log',
	FILENAME = 'D:\QLKHO.ldf',
	SIZE = 1MB,
	MAXSIZE = 10MB,
	FILEGROWTH = 20%
	)

GO USE QLKHO

GO
CREATE TABLE TON(
	MAVT INT NOT NULL PRIMARY KEY,
	TENVT NVARCHAR(30),
	SOLUONGT INT
	)

GO
CREATE TABLE XUAT(
	SOHDX INT NOT NULL,
	MAVT INT ,
	SOLUONGX INT,
	DONGIAX INT,
	MGAYX DATE,
	CONSTRAINT PK_XUAT PRIMARY KEY (SOHDX, MAVT),
	CONSTRAINT FK_XUAT_TON FOREIGN KEY (MAVT) REFERENCES TON(MAVT)

	)

GO
CREATE TABLE NHAP(
	SOHDN INT NOT NULL,
	MAVT INT ,
	SOLUONGN INT,
	DONGIAN INT,
	MGAYN DATE,
	CONSTRAINT PK_NHAP PRIMARY KEY (SOHDN, MAVT),
	CONSTRAINT FK_NHAP_TON FOREIGN KEY (MAVT) REFERENCES TON(MAVT)

	)



INSERT INTO TON VALUES
	(9, 'BUT CHI', 7),
	(11, 'BUT MAY', 4),
	(12, 'THUOC KE', 4),
	(13, 'TAY', 4),
	(14, 'BUT MAU', 4)
	
INSERT INTO NHAP VALUES 
	(1, 10, 5, 4000, '2/6/2002'),
	(2, 10, 4, 6000, '6/6/2002'),
	(3, 10, 6, 2000, '3/6/2002')

INSERT INTO XUAT VALUES 
	(1, 10, 5, 4000, '8/8/2002'),
	(2, 10, 4, 6000, '9/8/2002'),
	(3, 10, 6, 2000, '4/9/2002')


SELECT * FROM TON

SELECT * FROM NHAP

SELECT * FROM XUAT

DELETE FROM TON
FROM TON INNER JOIN NHAP ON TON.MAVT = NHAP.MAVT
		 INNER JOIN XUAT ON NHAP.MAVT = XUAT.MAVT
WHERE DONGIAX < DONGIAN

UPDATE XUAT
SET MGAYX = MGAYN
FROM XUAT INNER JOIN NHAP ON XUAT.MAVT = NHAP.MAVT
WHERE MGAYX < MGAYN