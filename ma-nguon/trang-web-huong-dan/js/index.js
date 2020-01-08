
var contents = [
	"Quản lý và nhân viên có thể sử dụng chức năng bán vé cho khách, chọn suất chiếu, chọn ghế, in vé.",
	"Hiện thông tin tất cả các phim đã, đang và sắp được chiếu tại rạp, quản lý không có quyền sửa, xóa phim, chỉ được thêm phim (Vì ảnh hưởng đến các dữ liệu khác, ví dụ: các vé được mua trước suất chiếu sẽ bị ảnh hưởng).",
	"Hiện thông tin các loại giá vé, quản lý toàn quyền thêm, xóa, sửa.",
	"Hiện thông tin toàn bộ lịch chiếu của rạp, quản lý chỉ được thêm, không được xóa hay sửa lịch chiếu. Lịch chiếu khi đã trùng ngày và trùng giờ, thì không được phép trùng rạp hay trùng phim.",
	"Hiện thông tin toàn bộ vé đã được bán, quản lý không được quyền thêm, xóa, sửa bât kì vé nào.",
	"Hiện thông tin các nhân viên hiện tại trong rạp, quản lý có thể thêm xóa sửa nhân viên, và không được thêm xóa sửa một quản lý khác.",
	"Hiện các bảng thông kê như thống kê doanh thu theo phim trong năm, ..."
	];


function loadContent(index) {
	$("p").text(contents[index]);
}