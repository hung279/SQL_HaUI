create database quan_ly_sinh_vien
CREATE TABLE Sach (
  masach char(4) not NULL,
  tensach nvarchar(10) not NULL,
  slco int not null,
  PRIMARY KEY(masach)
)

CREATE TABLE PN (
  SoPN char(4) not NULL,
  MaCH char(4) not null,
  PRIMARY KEY(SoPN)
)

CREATE TABLE Chitiet (
  SoPN char(4) not NULL,
  masach char(4) not NULL,
  slnhap int not NULL,
  gia int not null,
  PRIMARY KEY(SoPN, masach)
)

INSERT INTO Sach
VALUES
('S01', 'Đinh', 15),
('S02', 'Lê', 8),
('S03', 'Nguyễn', 12),
('S04', 'Đinh', 15)

INSERT INTO PN
VALUES
('PN01', 'CH01'),
('PN02', 'CH02'),
('PN03', 'CH01'),
('PN04', 'CH03'),
('PN05', 'CH02')

INSERT INTO Chitiet
VALUES
('PN01','S01', 2, 100),
('PN01','S02', 1, 200),
('PN02','S03', 4, 100),
('PN01','S04', 2, 300),
('PN02','S01', 1, 100),
('PN03','S01', 2, 300),
('PN04','S01', 2, 200),
('PN05','S01', 4, 800),
('PN02','S02', 1, 300),
('PN03','S02', 6, 400),
('PN04','S02', 2, 300),
('PN05','S02', 2, 300)

SELECT * from Sach
WHERE slco = (SELECT MAX(slco) from Sach)
GROUP by  tensach