# SNEAKERS SHOP APP - UI/UX SPEC & IMPLEMENTATION GUIDE

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![State%20Management](https://img.shields.io/badge/State%20Management-Provider-0A7E8C?style=for-the-badge)
![Architecture](https://img.shields.io/badge/Architecture-MVVM%20or%20MVC-FF6B35?style=for-the-badge)
![Persistence](https://img.shields.io/badge/Persistence-SharedPreferences%20or%20Firebase-2E7D32?style=for-the-badge)

Tài liệu này mô tả chi tiết yêu cầu triển khai ứng dụng mua sắm gồm 4 màn hình chính, tập trung vào UI/UX hiện đại, state management chuẩn, và logic nghiệp vụ đầy đủ để nghiệm thu.

## 1. Mục Tiêu Dự Án

- Xây dựng app mua sắm với trải nghiệm tương tự các sàn thương mại điện tử.
- Tập trung vào 3 trụ cột:
	- UI/UX mượt, trực quan, phản hồi nhanh.
	- State management đúng chuẩn (không truyền list giỏ hàng bằng Navigator).
	- Logic tính toán giỏ hàng, thanh toán, đơn mua chính xác theo thời gian thực.

## 2. Feature Scope Bắt Buộc

## Màn Hình 1: Trang Chủ (Home Screen) - Tối ưu UI/UX

### AppBar + Scroll Behavior
- Dùng SliverAppBar.
- Search Bar đặt trên cùng và có sticky behavior.
- Khi cuộn xuống:
	- Search Bar dính đỉnh màn hình.
	- Nền Search/AppBar đổi màu từ trong suốt sang màu chủ đạo.
- Góc phải trên cùng có icon giỏ hàng + badge đỏ hiển thị tổng số loại sản phẩm trong giỏ.

### Banner Quảng Cáo (Carousel Slider)
- Slider tự động cuộn ngang (auto-play).
- Hiển thị 3-4 banner khuyến mãi.
- Có dots indicator thể hiện vị trí hiện tại.

### Danh Mục Sản Phẩm (Categories)
- Hiển thị dạng lưới icon 2 hàng cuộn ngang.
- Ví dụ: Thời trang, Điện thoại, Mỹ phẩm, Đồ gia dụng.

### Gợi Ý Hôm Nay (Daily Discover - Infinite Scroll)
- Dùng GridView 2 cột hoặc Masonry grid.
- Mỗi item là Product Card.

### Cấu Trúc Product Card
- Ảnh sản phẩm có hiệu ứng loading mờ khi chưa tải xong.
- Tên sản phẩm giới hạn 2 dòng, quá dài hiển thị dấu ba chấm.
- Tag nổi bật: Mall / Yêu thích / Giảm 50%.
- Giá tiền format chuẩn tiền tệ: 150.000đ hoặc $15.00.
- Lượt bán: ví dụ "Đã bán 1.2k".

### Logic Nâng Cao
- Pull to Refresh để làm mới dữ liệu.
- Infinite Scrolling + Pagination:
	- Cuộn tới đáy tự động gọi API tải trang tiếp theo.
	- Tránh gọi trùng API (chặn loading song song).

---

## Màn Hình 2: Chi Tiết Sản Phẩm (Product Detail Screen)

### Chuyển Cảnh
- Hero Animation từ ảnh sản phẩm ở Home sang Product Detail.

### Bố Cục Nội Dung
- Slider ảnh xem nhiều góc độ sản phẩm.
- Khối tên + giá:
	- Tên in đậm.
	- Giá bán màu đỏ, kích thước lớn.
	- Giá gốc màu xám, gạch ngang.
- Khối phân loại (Variations):
	- Hiển thị "Chọn Kích cỡ, Màu sắc".
	- Có icon mũi tên điều hướng.
- Mô tả chi tiết:
	- RichText hoặc văn bản dài.
	- Có cơ chế Xem thêm/Thu gọn nếu vượt quá 5 dòng.

### Bottom Action Bar (Cố định)
- Chia 2 nửa:
	- Nửa trái: icon Chat + icon Giỏ hàng.
	- Nửa phải: nút "Thêm vào giỏ hàng" + "Mua ngay".

### BottomSheet Logic (Trọng tâm)
- Khi bấm "Thêm vào giỏ" hoặc khối "Phân loại":
	- Không chuyển trang.
	- Mở BottomSheet từ dưới lên, nền phía sau tối lại.
- Trong BottomSheet cho phép chọn:
	- Size: S, M, L.
	- Màu sắc: Xanh, Đỏ.
	- Số lượng bằng nút +/-.
- Bấm "Xác nhận":
	- Đóng BottomSheet.
	- Hiện SnackBar: "Thêm thành công".
	- Badge giỏ hàng cập nhật ngay lập tức.

---

## Màn Hình 3: Giỏ Hàng (Cart Screen) - Trọng tâm State Management

### Cấu Trúc Danh Sách
- Dùng ListView hiển thị sản phẩm trong giỏ.
- Mỗi item có:
	- Checkbox chọn sản phẩm.
	- Ảnh thu nhỏ.
	- Tên sản phẩm.
	- Phân loại (Size/Màu).
	- Đơn giá.
	- Bộ đếm số lượng +/-.
- Hỗ trợ vuốt trái để xóa (Dismissible), nền đỏ + icon thùng rác.

### Sticky Bottom Bar
- Checkbox "Chọn tất cả" ở đáy màn hình.
- Thanh "Tổng thanh toán" chỉ tính các item đang được tick.

### Logic Toán Học & Liên Kết Trạng Thái
- Tổng tiền động:
	- Công thức: Tổng = Σ(đơn giá x số lượng) của item đang tick.
	- Bỏ tick item nào, tổng trừ ngay item đó.
- Logic chọn tất cả:
	- Tick "Chọn tất cả" -> tất cả item đều được tick.
	- Bỏ tick 1 item -> "Chọn tất cả" tự tắt.
	- Tick thủ công đủ 100% item -> "Chọn tất cả" tự bật.
- Logic tăng/giảm số lượng:
	- Nếu item đang tick, bấm +/- thì tổng tiền cập nhật realtime.
	- Giảm về 0 phải hỏi xác nhận xóa.

---

## Màn Hình 4: Thanh Toán & Đơn Mua (Checkout & Orders)

### Checkout
- Nhận danh sách sản phẩm đã tick từ giỏ hàng.
- UI gồm:
	- Nhập địa chỉ nhận hàng.
	- Chọn phương thức thanh toán: COD, Momo.
- Bấm "Đặt hàng":
	- Hiện dialog thành công.
	- Xóa các sản phẩm vừa đặt khỏi giỏ.
	- Điều hướng về Home Screen.

### Order History
- Dùng DefaultTabController + TabBar vuốt ngang.
- Các tab trạng thái:
	- Chờ xác nhận.
	- Đang giao.
	- Đã giao.
	- Đã hủy.
- Hiển thị đơn đã đặt thành công.
- Có thể lưu local hoặc Firebase.

## 3. Yêu Cầu Kỹ Thuật & Tổ Chức Source Code

### Kiến Trúc Thư Mục (Bắt buộc)
Tối thiểu phải có:

```text
lib/
	models/
	screens/
	widgets/
	services/
	providers/   (hoặc controllers/ nếu dùng GetX)
```

Khuyến nghị thêm:

```text
lib/
	data/
	theme/
	utils/
	view/
```

### State Management (Bắt buộc)
- Dùng Provider, GetX hoặc tương đương cho giỏ hàng.
- Không truyền nguyên list giỏ hàng bằng Navigator.push qua lại nhiều màn hình.

### Data Persistence (Điểm cộng)
- Lưu giỏ hàng offline bằng SharedPreferences hoặc đồng bộ Firebase.
- Khi tắt/bật app, dữ liệu giỏ hàng vẫn còn (hoặc có xử lý ngoại lệ rõ ràng).

## 4. Checklist Nghiệm Thu Nhanh

- [ ] Home có SliverAppBar sticky + đổi màu khi cuộn.
- [ ] Cart icon có badge số loại sản phẩm realtime.
- [ ] Có banner carousel auto-play + dots indicator.
- [ ] Có categories dạng lưới 2 hàng cuộn ngang.
- [ ] Daily Discover có pull-to-refresh + infinite scroll + pagination.
- [ ] Product Card đúng chuẩn: ảnh, tên 2 dòng, tag, giá format, lượt bán.
- [ ] Hero animation từ Home sang Product Detail.
- [ ] Product Detail có slider ảnh, giá bán/giá gốc, variation, mô tả xem thêm.
- [ ] BottomSheet chọn size/màu/số lượng hoạt động đúng.
- [ ] Thêm giỏ thành công có SnackBar và badge tăng ngay.
- [ ] Cart có checkbox từng item + chọn tất cả liên kết 2 chiều.
- [ ] Tổng tiền chỉ tính item tick, cập nhật realtime khi +/-.
- [ ] Vuốt trái xóa item hoạt động đúng.
- [ ] Checkout đặt hàng thành công xóa đúng item và về Home.
- [ ] Order History có TabBar 4 trạng thái và hiển thị dữ liệu.
- [ ] App dùng Provider/GetX đúng chuẩn kiến trúc.
- [ ] Có lưu giỏ hàng bằng SharedPreferences/Firebase.

## 5. Chạy Dự Án

```bash
flutter pub get
flutter run
```

Build release:

```bash
flutter build apk
```

## 6. Gợi Ý Package Nên Dùng

- `provider` hoặc `get`
- `carousel_slider`
- `cached_network_image`
- `intl` (format tiền tệ)
- `shared_preferences`
- `flutter_staggered_grid_view` (nếu dùng masonry)

## 7. Ghi Chú

- Ưu tiên UX mượt: loading state, empty state, error state.
- Tối ưu hiệu năng danh sách dài bằng lazy load và hạn chế rebuild không cần thiết.
- Toàn bộ logic giỏ hàng nên được test kỹ vì liên quan trực tiếp đến điểm thành phần nghiệp vụ.
