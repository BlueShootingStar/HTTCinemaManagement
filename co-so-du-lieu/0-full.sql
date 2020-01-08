/*
	Môn học: Dự án 1 - Ngành Ứng dụng phần mềm
	Nhóm 3: Đinh Đạt Thông, Lê Long Thành
	Chủ đề: Quản lý rạp phim

	Mục lục:
	- line 014 - /* 1 tạo bảng */
	- line 143 - /* 2 nhập dữ liệu */
	- line 470 - /* 3 tạo thủ tục */
	- line 771 - /* 4 tạo trigger */
	- line 828 - /* 5 tạo người dùng */
*/

/* 1 tạo bảng */

use master
if db_id('QuanLyRapPhim') is not null
	begin
		drop database QuanLyRapPhim
	end
go

create database QuanLyRapPhim
go

use QuanLyRapPhim
go

-- 1. Bảng VaiTro
create table VaiTro (
	maVaiTro varchar(5),
	tenVaiTro nvarchar(20),
	moTa nvarchar(100),

	primary key (maVaiTro)
)
go

-- 2. Bảng TaiKhoan
create table TaiKhoan (
	tenDangNhap varchar(30),
	matKhau varchar(30),
	hoTen nvarchar(50),
	gioiTinh bit,
	ngaySinh date,
	diaChi nvarchar(100),
	soDienThoai varchar(12),
	hinh varchar(34),
	maVaiTro varchar(5),
	
	primary key (tenDangNhap),
	foreign key (maVaiTro) references VaiTro(maVaiTro)
)
go

-- 3. Bảng TheLoaiPhim
create table TheLoaiPhim (
	maTheLoai int,
	tenTheLoai nvarchar(15),

	primary key (maTheLoai)
)
go

-- 4. Bảng Phim
create table Phim (
	maPhim int identity(1,1),
	tenPhim nvarchar(50),
	maTheLoai int,
	nhaSanXuat nvarchar(30),
	doTuoi tinyint,
	thoiLuong smallint,
	ngayCongChieu date,
	trailer varchar(100) unique,
	hinh varchar(30),

	primary key (maPhim),
	foreign key (maTheLoai) references TheLoaiPhim(maTheLoai) on delete set null
)
go

-- 5. Bảng PhongChieu
create table PhongChieu (
	maPhongChieu int,
	tenPhongChieu nvarchar(15), 

	primary key (maPhongChieu)
)
go

-- 6. Bảng LichChieu
create table LichChieu (
	maLichChieu int identity(1,1),
	maPhim int,
	maPhongChieu int,
	ngayChieu date,
	gioChieu time,

	primary key (maLichChieu),
	foreign key (maPhim) references Phim(maPhim) on delete cascade,
	foreign key (maPhongChieu) references PhongChieu(maPhongChieu)
)
go

-- 7. Bảng Ghe
create table Ghe (
	maGhe varchar(5),

	primary key (maGhe)
)
go

-- 8. Bảng GiaVe
create table GiaVe (
	maGiaVe int identity(1,1),
	giaVe money,
	moTa nvarchar(100) unique,

	primary key (maGiaVe)
)
go

-- 9. Bảng Ve
create table Ve (
	maVe int identity(1,1),
	maLichChieu int,
	maGhe varchar(5),
	tenDangNhap varchar(30),
	ngayTao datetime default getdate(),
	maGiaVe int,
	giaVe money,

	primary key (maVe, maLichChieu, maGhe),
	foreign key (maGiaVe) references GiaVe(maGiaVe) on delete set null,
	foreign key (tenDangNhap) references TaiKhoan(tenDangNhap) on delete set null,
	foreign key (maGhe) references Ghe(maGhe),
	foreign key (maLichChieu) references LichChieu(maLichChieu) on delete cascade
)
go

/* hết phần 1 tạo bảng */

/* 2 nhập dữ liệu */

use master
go

use QuanLyRapPhim
go

-- 1. Bảng VaiTro
insert into VaiTro 
values 
--	maVaiTro	tenVaiTro		vaiTro --
	('NV',		N'Nhân viên',	N'Nhân viên bán vé'),
	('QL',		N'Quản lý',		N'Quản lý nhân viên bán vé')
go

-- 2. Bảng TaiKhoan
insert into TaiKhoan 
values 
--	tenDangNhap		matKhau		hoTen					gioiTinh	ngaySinh		diaChi									soDienThoai		hinh			maVaiTro --
	('thanh',		'123',		N'Lê Long Thành',		'true',		'12/13/1995',	N'Thanh Đa, Quận Bình Thạnh, TP.HCM',	'0123456789',	'thanh.jpg',	'QL'),
	('thong',		'123',		N'Đinh Đạt Thông',		'true',		'09/18/1997',	N'Thanh Đa, Quận Bình Thạnh, TP.HCM',	'0123456789',	'thong.jpg',	'QL'),
	('huy',			'123',		N'Nguyễn Quang Huy',	'true',		'01/15/1993',	N'Thanh Đa, Quận Bình Thạnh, TP.HCM',	'0123456789',	'huy.jpg',		'NV'),
	('hao',			'123',		N'Nguyễn Đại Hào',		'true',		'09/09/1999',	N'Thanh Đa, Quận Bình Thạnh, TP.HCM',	'0124578939',	'hao.jpg',		'NV'),
	('duong',		'123',		N'Nguyễn Đại Dương',	'false',	'01/14/1992',	N'Thanh Đa, Quận Bình Thạnh,TP.HCM',	'0123456789',	'duong.jpg',	'NV'),
	('bien',		'123',		N'Phạm Duy Biên',		'false',	'07/17/1992',	N'Thanh Đa, Quận Bình Thạnh,TP.HCM',	'0123456789',	'bien.jpg',		'NV')
go

-- 3. Bảng TheLoaiPhim
insert into TheLoaiPhim 
values 
--	maTheLoai	tenTheLoai --
	('1',		N'Chiến tranh'),
	('2',		N'Cổ trang'),
	('3',		N'Hành động'),
	('4',		N'Hoạt hình'),
	('5',		N'Tâm lý')
go

-- 4. Bảng Phim
insert into Phim 
values 
--	tenPhim												maTheLoai	nhaSanXuat					doTuoi		thoiLuong	ngayCongChieu	trailer				hinh --
	(N'The Red Sea Diving Resort',						'1',		N'BRON Studios',			'18',		'129',		'06/15/2019',	'80WflPMzAcw',		'80WflPMzAcw.jpg'),
	(N'The Photographer Of Mauthausen',					'1',		N'FilmTeam',				'18',		'110',		'06/15/2019',	'aqXBQcO_Qa8',		'aqXBQcO_Qa8.jpg'),
	(N'Tankers',										'1',		N'Mosfim',					'16',		'90',		'07/15/2019',	'yoEIpLeLZLk',		'yoEIpLeLZLk.jpg'),
	(N'Hotel Mumbai',									'1',		N'Mosfim',					'16',		'123',		'07/15/2019',	'gVQpbp54ljA',		'gVQpbp54ljA.jpg'),
	(N'Fa Hai',											'2',		N'Mosfim',					'01',		'94',		'07/16/2019',	'cLHWIjWgnoY',		'cLHWIjWgnoY.jpg'),
	(N'The Great Battle',								'2',		N'Chya-ra',					'01',		'135',		'07/16/2019',	'tp7lK5oCmjA',		'tp7lK5oCmjA.jpg'),
	(N'Detective Dee',									'2',		N'China Film',				'01',		'119',		'08/17/2019',	'x5tknmJfYU8',		'x5tknmJfYU8.jpg'),
	(N'Saving General Yang',							'2',		N'Pegasus Motion',			'01',		'102',		'08/17/2019',	'PZetLV7i6Fc',		'PZetLV7i6Fc.jpg'),
	(N'Bala',											'3',		N'Canana Films',			'01',		'104',		'08/17/2019',	'e-kPf-n4Mto',		'e-kPf-n4Mto.jpg'),
	(N'Fast & Furious Presents: Hobbs & Shaw',			'3',		N'Universal Pictures',		'01',		'90',		'08/18/2019',	'HZ7PAyCDwEg',		'HZ7PAyCDwEg.jpg'),
	(N'The Kings Man',									'3',		N'Marv Studios',			'01',		'120',		'08/18/2019',	'e82JHkkPw54',		'e82JHkkPw54.jpg'),
	(N'Bond 25',										'3',		N'Eon Productions',			'01',		'120',		'08/18/2019',	'k1CFAckaAp8',		'k1CFAckaAp8.jpg'),
	(N'Sonic the Hedgehog',								'4',		N'Paramount Pictures',		'01',		'120',		'09/19/2019',	'FvvZaBf9QQI',		'FvvZaBf9QQI.jpg'),
	(N'Star Wars',										'4',		N'Lucasfilm',				'16',		'100',		'09/19/2019',	'adzYW5DZoWs',		'adzYW5DZoWs.jpg'),
	(N'The Addams Family',								'4',		N' BermanBraun',			'16',		'125',		'09/19/2019',	'F7Ug863S8dQ',		'F7Ug863S8dQ.jpg'),
	(N'Shaun the Sheep Movie: Farmageddon',				'4',		N'Anton',					'16',		'125',		'09/20/2019',	'RecHCOkgOvI',		'RecHCOkgOvI.jpg'),
	(N'A Beautiful Day in the Neighborhood',			'5',		N'Big Beach Films',			'01',		'160',		'10/20/2019',	'-VLEPhfEN2M',		'-VLEPhfEN2M.jpg'),
	(N'Playing with Fire',								'5',		N'Paramount Players',		'01',		'145',		'10/20/2019',	'fd5GlZUpfaM',		'fd5GlZUpfaM.jpg'),
	(N'The Good Liar',									'5',		N'BRON Studios',			'01',		'160',		'10/21/2019',	'ljKzFGpPHhw',		'ljKzFGpPHhw.jpg'),
	(N'A Rainy Day in New York',						'5',		N'Chya-ra',					'01',		'120',		'10/21/2019',	'Bc9Hi-12Bio',		'Bc9Hi-12Bio.jpg')
go

-- 5. Bảng PhongChieu
insert into PhongChieu 
values 
--	maPhongChieu	tenPhongChieu --
	('1',			N'01'),
	('2',			N'02'),
	('3',			N'03')
go

-- 6. Bảng LichChieu
insert into LichChieu 
values
--	maPhim	maPhongChieu	ngayChieu		gioChieu --

/* THỨ 2 */
	--PC 1--
	('1',	'1',			'07/15/2019',	'08:30'),
	('4',	'1',			'07/15/2019',	'11:00'),
	('3',	'1',			'07/15/2019',	'13:30'),
	('2',	'1',			'07/15/2019',	'15:00'),
	('1',	'1',			'07/15/2019',	'17:30'),
	('4',	'1',			'07/15/2019',	'20:00'),
	('3',	'1',			'07/15/2019',	'22:30'),
	--PC 2--
	('2',	'2',			'07/15/2019',	'08:30'),
	('1',	'2',			'07/15/2019',	'11:00'),
	('4',	'2',			'07/15/2019',	'13:30'),
	('3',	'2',			'07/15/2019',	'15:00'),
	('2',	'2',			'07/15/2019',	'17:30'),
	('1',	'2',			'07/15/2019',	'20:00'),
	('4',	'2',			'07/15/2019',	'22:30'),
	--PC 3--
	('3',	'3',			'07/15/2019',	'08:30'),
	('2',	'3',			'07/15/2019',	'11:00'),
	('1',	'3',			'07/15/2019',	'13:30'),
	('4',	'3',			'07/15/2019',	'15:00'),
	('3',	'3',			'07/15/2019',	'17:30'),
	('2',	'3',			'07/15/2019',	'20:00'),
	('1',	'3',			'07/15/2019',	'22:30'),

/* THỨ 3 */
	--PC 1--
	('3',	'1',			'07/16/2019',	'08:30'),
	('6',	'1',			'07/16/2019',	'11:00'),
	('5',	'1',			'07/16/2019',	'13:30'),
	('4',	'1',			'07/16/2019',	'15:00'),
	('3',	'1',			'07/16/2019',	'17:30'),
	('6',	'1',			'07/16/2019',	'20:00'),
	('5',	'1',			'07/16/2019',	'22:30'),
	--PC 2--
	('4',	'2',			'07/16/2019',	'08:30'),
	('3',	'2',			'07/16/2019',	'11:00'),
	('6',	'2',			'07/16/2019',	'13:30'),
	('5',	'2',			'07/16/2019',	'15:00'),
	('4',	'2',			'07/16/2019',	'17:30'),
	('3',	'2',			'07/16/2019',	'20:00'),
	('6',	'2',			'07/16/2019',	'22:30'),
	--PC 3--
	('5',	'3',			'07/16/2019',	'08:30'),
	('4',	'3',			'07/16/2019',	'11:00'),
	('3',	'3',			'07/16/2019',	'13:30'),
	('6',	'3',			'07/16/2019',	'15:00'),
	('5',	'3',			'07/16/2019',	'17:30'),
	('4',	'3',			'07/16/2019',	'20:00'),
	('3',	'3',			'07/16/2019',	'22:30'),

/* THỨ 4 */
	--PC 1--
	('3',	'1',			'07/17/2019',	'08:30'),
	('6',	'1',			'07/17/2019',	'11:00'),
	('5',	'1',			'07/17/2019',	'13:30'),
	('4',	'1',			'07/17/2019',	'15:00'),
	('3',	'1',			'07/17/2019',	'17:30'),
	('6',	'1',			'07/17/2019',	'20:00'),
	('5',	'1',			'07/17/2019',	'22:30'),
	--PC 2--
	('4',	'2',			'07/17/2019',	'08:30'),
	('3',	'2',			'07/17/2019',	'11:00'),
	('6',	'2',			'07/17/2019',	'13:30'),
	('5',	'2',			'07/17/2019',	'15:00'),
	('4',	'2',			'07/17/2019',	'17:30'),
	('3',	'2',			'07/17/2019',	'20:00'),
	('6',	'2',			'07/17/2019',	'22:30'),
	--PC 3--
	('5',	'3',			'07/17/2019',	'08:30'),
	('4',	'3',			'07/17/2019',	'11:00'),
	('3',	'3',			'07/17/2019',	'13:30'),
	('6',	'3',			'07/17/2019',	'15:00'),
	('5',	'3',			'07/17/2019',	'17:30'),
	('4',	'3',			'07/17/2019',	'20:00'),
	('3',	'3',			'07/17/2019',	'22:30'),

/* THỨ 5 */
	--PC 1--
	('6',	'1',			'07/18/2019',	'08:30'),
	('5',	'1',			'07/18/2019',	'11:00'),
	('4',	'1',			'07/18/2019',	'13:30'),
	('3',	'1',			'07/18/2019',	'15:00'),
	('6',	'1',			'07/18/2019',	'17:30'),
	('5',	'1',			'07/18/2019',	'20:00'),
	('4',	'1',			'07/18/2019',	'22:30'),
	--PC 2--
	('3',	'2',			'07/18/2019',	'08:30'),
	('6',	'2',			'07/18/2019',	'11:00'),
	('5',	'2',			'07/18/2019',	'13:30'),
	('4',	'2',			'07/18/2019',	'15:00'),
	('3',	'2',			'07/18/2019',	'17:30'),
	('6',	'2',			'07/18/2019',	'20:00'),
	('5',	'2',			'07/18/2019',	'22:30'),
	--PC 3--
	('4',	'3',			'07/18/2019',	'08:30'),
	('3',	'3',			'07/18/2019',	'11:00'),
	('6',	'3',			'07/18/2019',	'13:30'),
	('5',	'3',			'07/18/2019',	'15:00'),
	('4',	'3',			'07/18/2019',	'17:30'),
	('3',	'3',			'07/18/2019',	'20:00'),
	('6',	'3',			'07/18/2019',	'22:30'),

/* THỨ 6 */
	--PC 1--
	('5',	'1',			'07/19/2019',	'08:30'),
	('4',	'1',			'07/19/2019',	'11:00'),
	('3',	'1',			'07/19/2019',	'13:30'),
	('6',	'1',			'07/19/2019',	'15:00'),
	('5',	'1',			'07/19/2019',	'17:30'),
	('4',	'1',			'07/19/2019',	'20:00'),
	('3',	'1',			'07/19/2019',	'22:30'),
	--PC 2--
	('6',	'2',			'07/19/2019',	'08:30'),
	('5',	'2',			'07/19/2019',	'11:00'),
	('4',	'2',			'07/19/2019',	'13:30'),
	('3',	'2',			'07/19/2019',	'15:00'),
	('6',	'2',			'07/19/2019',	'17:30'),
	('5',	'2',			'07/19/2019',	'20:00'),
	('4',	'2',			'07/19/2019',	'22:30'),
	--PC 3--
	('3',	'3',			'07/19/2019',	'08:30'),
	('6',	'3',			'07/19/2019',	'11:00'),
	('5',	'3',			'07/19/2019',	'13:30'),
	('4',	'3',			'07/19/2019',	'15:00'),
	('3',	'3',			'07/19/2019',	'17:30'),
	('6',	'3',			'07/19/2019',	'20:00'),
	('5',	'3',			'07/19/2019',	'22:30'),

/* THỨ 7 */
	--PC 1--
	('4',	'1',			'07/20/2019',	'08:30'),
	('3',	'1',			'07/20/2019',	'11:00'),
	('6',	'1',			'07/20/2019',	'13:30'),
	('5',	'1',			'07/20/2019',	'15:00'),
	('4',	'1',			'07/20/2019',	'17:30'),
	('3',	'1',			'07/20/2019',	'20:00'),
	('5',	'1',			'07/20/2019',	'22:30'),
	--PC 2--
	('5',	'2',			'07/20/2019',	'08:30'),
	('4',	'2',			'07/20/2019',	'11:00'),
	('3',	'2',			'07/20/2019',	'13:30'),
	('6',	'2',			'07/20/2019',	'15:00'),
	('5',	'2',			'07/20/2019',	'17:30'),
	('4',	'2',			'07/20/2019',	'20:00'),
	('3',	'2',			'07/20/2019',	'22:30'),
	--PC 3--
	('6',	'3',			'07/20/2019',	'08:30'),
	('5',	'3',			'07/20/2019',	'11:00'),
	('3',	'3',			'07/20/2019',	'13:30'),
	('4',	'3',			'07/20/2019',	'15:00'),
	('6',	'3',			'07/20/2019',	'17:30'),
	('5',	'3',			'07/20/2019',	'20:00'),
	('4',	'3',			'07/20/2019',	'22:30'),

/* Chủ Nhật */
	--PC 1--
	('3',	'1',			'07/21/2019',	'08:30'),
	('4',	'1',			'07/21/2019',	'11:00'),
	('5',	'1',			'07/21/2019',	'13:30'),
	('6',	'1',			'07/21/2019',	'15:00'),
	('3',	'1',			'07/21/2019',	'17:30'),
	('4',	'1',			'07/21/2019',	'20:00'),
	('5',	'1',			'07/21/2019',	'22:30'),
	--PC 2--
	('4',	'2',			'07/21/2019',	'08:30'),
	('5',	'2',			'07/21/2019',	'11:00'),
	('6',	'2',			'07/21/2019',	'13:30'),
	('3',	'2',			'07/21/2019',	'15:00'),
	('4',	'2',			'07/21/2019',	'17:30'),
	('5',	'2',			'07/21/2019',	'20:00'),
	('6',	'2',			'07/21/2019',	'22:30'),
	--PC 3--
	('5',	'3',			'07/21/2019',	'08:30'),
	('6',	'3',			'07/21/2019',	'11:00'),
	('3',	'3',			'07/21/2019',	'13:30'),
	('4',	'3',			'07/21/2019',	'15:00'),
	('5',	'3',			'07/21/2019',	'17:30'),
	('6',	'3',			'07/21/2019',	'20:00'),
	('3',	'3',			'07/21/2019',	'22:30')
go

-- 7. Bảng Ghe
insert into Ghe 
values 
--	maGhe --
	('A1'),
	('A2'),
	('A3'),
	('A4'),
	('A5'),
	('A6'),

	('B1'),
	('B2'),
	('B3'),
	('B4'),
	('B5'),
	('B6'),

	('C1'),
	('C2'),
	('C3'),
	('C4'),
	('C5'),
	('C6'),

	('D1'),
	('D2'),
	('D3'),
	('D4'),
	('D5'),
	('D6'),

	('E1'),
	('E2'),
	('E3'),
	('E4'),
	('E5'),
	('E6')
go

-- 8. Bảng GiaVe
insert into GiaVe 
values
--	giaVe		moTa --
	('45000',	N'Ngày thường'),
	('55000',	N'Cuối tuần'),
	('40000',	N'Happy day'),
	('35000',	N'Dưới 16 tuổi')
go

-- 9. Bảng Ve
insert into Ve 
values
--	maLichChieu		maGhe	tenDangNhap		ngayTao			maGiaVe		giaVe --
	('1',			'A1',	'thanh',		'07/15/2019',	'1',		'45000'),
	('3',			'D1',	'huy',			'07/15/2019',	'1',		'45000'),
	('3',			'D2',	'thong',		'07/15/2019',	'1',		'45000'),
	('28',			'D2',	'thong',		'07/15/2019',	'1',		'45000'),
	('28',			'D3',	'thong',		'07/15/2019',	'1',		'45000'),
	('28',			'D1',	'thong',		'07/15/2019',	'1',		'45000'),
	('27',			'D2',	'thong',		'07/16/2019',	'1',		'45000')
go

/* hết phần 2 nhập dữ liệu */

/* 3 tạo thủ tục */
-- 1. tìm phim được chiếu trong ngày
if (object_id('sp_TimPhimTrongNgay') is not null)
	drop procedure sp_TimPhimTrongNgay
go
create procedure sp_TimPhimTrongNgay
	@ngay date
as
	-- nếu ngày chiếu truyền vào là sau ngày 15/7 (hoặc hôm nay), thì hiện toàn bộ phim trong ngày đó
	-- if (@ngayChieu > getdate())
	if (@ngay > '07/15/2019') 
		begin
			select distinct Phim.*
			from Phim join LichChieu on LichChieu.maPhim = Phim.maPhim
			where ngayChieu = @ngay
			order by Phim.maPhim
		end
	else
		begin
			select distinct Phim.*
			from Phim join LichChieu on LichChieu.maPhim = Phim.maPhim
			where ngayChieu = @ngay
				and gioChieu >= (select DATEADD(MINUTE, -30, convert(time, CURRENT_TIMESTAMP))) -- chỉ hiện những phim còn giờ chiếu
			order by Phim.maPhim
		end
go

-- 2. tìm tất cả giờ chiếu của một phim trong ngày
if (object_id('sp_TimTatCaGioChieuCuaPhimTrongNgay') is not null)
	drop procedure sp_TimTatCaGioChieuCuaPhimTrongNgay
go
create procedure sp_TimTatCaGioChieuCuaPhimTrongNgay
	@maPhim int,
	@ngayChieu date
as
	-- nếu ngày chiếu truyền vào là sau ngày 15/7 (hoặc hôm nay), thì hiện toàn bộ giờ chiếu
	-- if (@ngayChieu > getdate())
	if (@ngayChieu > '07/15/2019')
		begin
			select *
			from LichChieu
			where maPhim = @maPhim
				and ngayChieu = @ngayChieu
				and maLichChieu
					not in (select maLichChieu -- chỉ hiện những lịch chiếu còn ghế trống
							from Ve
							group by maLichChieu
							having count(*) = (select count(*) from Ghe)
					)
			order by gioChieu
		end
	else
		begin
			select *
			from LichChieu
			where maPhim = @maPhim
				and ngayChieu = @ngayChieu
				and maLichChieu
					not in (select maLichChieu -- chỉ hiện những lịch chiếu còn ghế trống
							from Ve
							group by maLichChieu
							having count(*) = (select count(*) from Ghe)
					)
				--  chỉ hiển thị những giờ chiếu còn lại trong ngày, sau giờ chiếu 30 phút sẽ không được mua vé nữa
				and gioChieu >= (select DATEADD(MINUTE, -30, convert(time, CURRENT_TIMESTAMP)))
			order by gioChieu
		end
go

-- 3. tìm các ghế đã được mua dựa vào mã lịch chiếu
if (object_id('sp_TimGheDaMua') is not null)
	drop procedure sp_TimGheDaMua
go
create procedure sp_TimGheDaMua
	@maLichChieu int
as
	select Ghe.*
	from Ghe join Ve on Ghe.maGhe = Ve.maGhe
	where maLichChieu = @maLichChieu
go

-- 4. tìm vé dựa vào một giai đoạn thời gian và loại vé
if (object_id('sp_HoaDonVeDuaTheoNgay') is not null)
	drop procedure sp_HoaDonVeDuaTheoNgay
go
create procedure sp_HoaDonVeDuaTheoNgay
	@ngayBatDau date, -- từ ngày muốn tìm
	@ngayKetThuc date, -- đến ngày muốn tìm
	@maGiaVe int
as
	if (@maGiaVe = 0)
		begin
			select *
			from Ve
			where	ngayTao >= @ngayBatDau
				and ngayTao < dateadd(day, 1, @ngayKetThuc)
			order by ngayTao desc
		end
	else
		begin
			select *
			from Ve 
			where	ngayTao >= @ngayBatDau
				and ngayTao < dateadd(day, 1, @ngayKetThuc)
				and maGiaVe = @maGiaVe
			order by ngayTao desc
		end
go

-- 5. xuất vé dựa theo mã vé
if (object_id('sp_XuatVe') is not null)
	drop procedure sp_XuatVe
go
create procedure sp_XuatVe
	@maVe int
as
	select	
			Ve.maVe,
			tenPhim, 
			tenPhongChieu,
			maGhe,
			ngayChieu,
			gioChieu,
			moTa,
			Ve.giaVe,
			Ve.ngayTao
	from 
		LichChieu	join Ve on Ve.maLichChieu = LichChieu.maLichChieu
					join Phim on LichChieu.maPhim = Phim.maPhim
					join PhongChieu on LichChieu.maPhongChieu = PhongChieu.maPhongChieu
					join GiaVe on GiaVe.maGiaVe = Ve.maGiaVe
	where maVe = @maVe
go

-- 6. thủ tục kiểm tra lịch chiếu đã được mua hay chưa (dựa vào mã lịch chiếu)
if (object_id('sp_KiemTraLichChieuDaDuocMua') is not null)
	drop procedure sp_KiemTraLichChieuDaDuocMua
go
create procedure sp_KiemTraLichChieuDaDuocMua
	@maLichChieu int
as
	select distinct LichChieu.*
	from Ve 
		join LichChieu on Ve.maLichChieu = LichChieu.maLichChieu
	where LichChieu.maLichChieu = @maLichChieu
go

-- 7. thủ tục kiểm tra phim đã được mua hay chưa (dựa vào mã phim)
if (object_id('sp_KiemTraPhimDaDuocMua') is not null)
	drop procedure sp_KiemTraPhimDaDuocMua
go
create procedure sp_KiemTraPhimDaDuocMua
	@maPhim int
as
	select distinct Phim.*
	from Ve
		join LichChieu on Ve.maLichChieu = LichChieu.maLichChieu
		join Phim on LichChieu.maPhim = Phim.maPhim
	where Phim.maPhim = @maPhim
go

-- 8. thủ tục tìm lịch chiếu dựa theo mã lịch chiếu, mã phim, ngày chiếu, giờ chiếu
if (object_id('sp_TruyVanLichChieuDuaTheoMaPhimNgayGio') is not null)
	drop procedure sp_TruyVanLichChieuDuaTheoMaPhimNgayGio
go
create procedure sp_TruyVanLichChieuDuaTheoMaPhimNgayGio
	@maLichChieu varchar(25),
	@maPhim int,
	@ngayChieu varchar(11),
	@gioChieu varchar(10)
as
	if (@maPhim = 0)
		begin
			select *
			from LichChieu
			where maLichChieu like @maLichChieu
				and ngayChieu like @ngayChieu
				and gioChieu like @gioChieu
		end
	else
		begin
			select *
			from LichChieu
			where maLichChieu like @maLichChieu
				and maPhim = @maPhim
				and ngayChieu like @ngayChieu
				and gioChieu like @gioChieu
		end
go

-- Thống kê --
-- 1. đếm số lượng phim, lịch chiếu, vé, nhân viên
if (object_id('sp_DemSoLuongPhimLichChieuVeNhanVien') is not null)
	drop procedure sp_DemSoLuongPhimLichChieuVeNhanVien
go
create procedure sp_DemSoLuongPhimLichChieuVeNhanVien
as
	select 
		(select count(*) from Phim) as [soLuongPhim],
		(select count(*) from LichChieu) as [soLuongLichChieu],
		(select count(*) from Ve) as [soLuongVe],
		(select count(*) from TaiKhoan) as [soLuongNhanVien]
go

-- 2. thống kế doanh thu của phim trong năm
if (object_id('sp_ThongKeTongTienTheoPhim_DuaTheoNam') is not null)
	drop procedure sp_ThongKeTongTienTheoPhim_DuaTheoNam
go
create procedure sp_ThongKeTongTienTheoPhim_DuaTheoNam
	@nam int, -- năm cần tìm
	@maPhim int -- mã phim cần tìm
as
	if (@maPhim != 0) -- nếu mã phim khác 0 thì tìm tất cả các phim có trong năm 
		begin
			select	Phim.maPhim,
					Phim.tenPhim,
					(select count(*) from LichChieu where maPhim = Phim.maPhim) as [soLuongSuatChieu],
					count(Phim.maPhim) as [soLuongVeMua], 
					sum(Ve.giaVe) as [doanhThuCuaPhim]
			from Ve 
				join LichChieu on Ve.maLichChieu = LichChieu.maLichChieu
				join Phim on LichChieu.maPhim = Phim.maPhim
			where	(year(Ve.ngayTao) = @nam)	
				and (Phim.maPhim = @maPhim)
			group by Phim.maPhim, Phim.tenPhim
			order by [doanhThuCuaPhim] desc
		end
	else	--tìm mã phim theo năm
		begin
			select	Phim.maPhim,
					Phim.tenPhim,
					(select count(*) from LichChieu where maPhim = Phim.maPhim) as [soLuongSuatChieu],
					count(Phim.maPhim) as [soLuongVeMua], 
					sum(Ve.giaVe) as [doanhThuCuaPhim]
			from Ve 
				join LichChieu on Ve.maLichChieu = LichChieu.maLichChieu
				join Phim on LichChieu.maPhim = Phim.maPhim
			where	(year(Ve.ngayTao) = @nam)
			group by Phim.maPhim, Phim.tenPhim
			order by [doanhThuCuaPhim] desc
		end
go

-- 3. Thống kê doanh thu của phòng chiếu theo năm
if (object_id('sp_ThongKeTongTienTheoPhongChieu_DuaTheoNam') is not null)
	drop procedure sp_ThongKeTongTienTheoPhongChieu_DuaTheoNam
go
create procedure sp_ThongKeTongTienTheoPhongChieu_DuaTheoNam
	@nam int, -- năm cần tìm
	@maPhongChieu int --mã phòng chiếu cần tìm
as
	if (@maPhongChieu != 0) --(mã phòng chiếu # 0) Tìm tất cả các phòng chiếu có trong năm 
		begin
			select	PhongChieu.maPhongChieu,
					PhongChieu.tenPhongChieu,
					(select count(*) from LichChieu where maPhongChieu = PhongChieu.maPhongChieu) as [soLuongSuatChieu],
					count(PhongChieu.maPhongChieu) as [soLuongVeMua], 
					sum(Ve.giaVe) as [doanhThuCuaPhongChieu]
			from Ve 
				join LichChieu on Ve.maLichChieu = LichChieu.maLichChieu
				join PhongChieu on LichChieu.maPhongChieu = PhongChieu.maPhongChieu
			where	(year(Ve.ngayTao) = @nam)	
				and (PhongChieu.maPhongChieu = @maPhongChieu)
			group by PhongChieu.maPhongChieu, PhongChieu.tenPhongChieu
		end
	else	--tìm mã phòng chiếu theo năm
		begin
			select	PhongChieu.maPhongChieu,
					PhongChieu.tenPhongChieu,
					(select count(*) from LichChieu where maPhongChieu = PhongChieu.maPhongChieu) as [soLuongSuatChieu],
					count(PhongChieu.maPhongChieu) as [soLuongVeMua], 
					sum(Ve.giaVe) as [doanhThuCuaPhongChieu]
			from Ve 
				join LichChieu on Ve.maLichChieu = LichChieu.maLichChieu
				join PhongChieu on LichChieu.maPhongChieu = PhongChieu.maPhongChieu
			where	(year(Ve.ngayTao) = @nam)
			group by PhongChieu.maPhongChieu, PhongChieu.tenPhongChieu
		end
go 

-- 4. Thống kê doanh thu giờ chiếu theo ngày
if (object_id('sp_ThongKeTongTienTheoGioChieu_DuaTheoNgay') is not null)
	drop procedure sp_ThongKeTongTienTheoGioChieu_DuaTheoNgay
go
create procedure sp_ThongKeTongTienTheoGioChieu_DuaTheoNgay
	@ngayBatDau date, -- từ ngày muốn tìm
	@ngayKetThuc date -- đến ngày muốn tìm
as
	select	LichChieu.gioChieu,
			count(LichChieu.gioChieu) as [soLuongVeMua], 
			sum(Ve.giaVe) as [doanhThuCuaGioChieu]
	from Ve 
		join LichChieu on Ve.maLichChieu = LichChieu.maLichChieu
	where	(Ve.ngayTao >= @ngayBatDau)
		and	(Ve.ngayTao < dateadd(day, 1, @ngayKetThuc))
	group by LichChieu.gioChieu
	order by LichChieu.gioChieu desc
go

/* hết phần 3 tạo thủ tục */

/* 4 tạo trigger */ -- Lê Long Thành
-- tạo trigger bảng LichChieu	
	-- 1. trigger insert
if (object_id('ITG_ThemLichChieu') is not null)
	drop trigger ITG_ThemLichChieu
go
create trigger ITG_ThemLichChieu on dbo.LichChieu for insert
as
	-- tạo biến
	declare @count int = 0 -- dùng để đếm có hàng nào trùng không

	declare @maLichChieu int
	declare @maPhim int
	declare @maPhongChieu int
	declare @ngayChieu date
	declare @gioChieu time

	-- gán biến, các giá trị lấy từ bảng trung gian khi thêm
	set @maLichChieu = (select maLichChieu from inserted)
	set	@maPhim = (select maPhim from inserted)
	set @ngayChieu = (select ngayChieu from inserted)
	set @maPhongChieu = (select maPhongChieu from inserted)
	set @gioChieu = (select gioChieu from inserted)

	-- select LichChieu khi trùng
	set @count = (
		select count(*) from LichChieu
		where	(@ngayChieu = ngayChieu and @gioChieu = gioChieu) 
				and
				(@maPhongChieu = maPhongChieu or @maPhim = maPhim)
				and
				@maLichChieu != maLichChieu
	)

	set @maLichChieu = (select maLichChieu from LichChieu
						where	(@ngayChieu = ngayChieu and @gioChieu = gioChieu) 
								and
								(@maPhongChieu = maPhongChieu or @maPhim = maPhim)
								and
								@maLichChieu != maLichChieu)

	-- nếu trùng thì rollback lại trước khi INSERT
	if (@count > 0)
	begin
		declare @msg nvarchar(2048) = concat(N'', @maLichChieu)

		begin try
			THROW 50000, @msg, 1
		end try
		begin catch
			THROW 50000, @msg, 1
		end catch
	end
go

/* hết phần 4 tạo Trigger */

/* 5 tạo người dùng */

-- 1. quản trị viên của cơ sở dữ liệu QuanLyRapPhim

	-- 1.1 tạo tên đăng nhập
	use master
	if exists (select name from master.sys.server_principals where name = 'QuanLyRapPhim_QTV')
		begin
			drop login QuanLyRapPhim_QTV
		end
	go
	create login QuanLyRapPhim_QTV with password = '123', default_database = QuanLyRapPhim

	-- 1.2 tạo người dùng cho tên đăng nhập trên
	use QuanLyRapPhim
	if exists (select name from sys.database_principals where name = 'QuanLyRapPhim_QTV')
		begin
			drop user QuanLyRapPhim_QTV
		end
	go
	create user QuanLyRapPhim_QTV for login QuanLyRapPhim_QTV

	-- 1.3 thêm vai trò cho người dùng trên
	use QuanLyRapPhim
	alter role [db_owner] add member QuanLyRapPhim_QTV;

/* hết phần 5 tạo người dùng */