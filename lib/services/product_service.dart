import '../models/product.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    return <Product>[
      Product(
        id: 1,
        title: 'Nike Air Force 1 Trắng Full Da',
        price: 2890000,
        description:
            'Mẫu sneaker quốc dân tại Việt Nam, dễ phối đồ và cực kỳ bền form.',
        category: 'Sneaker lifestyle',
        image: 'assets/images/nike1.png',
        rating: 4.8,
        ratingCount: 3200,
      ),
      Product(
        id: 2,
        title: 'Nike Dunk Low Panda Hot Trend',
        price: 3290000,
        description:
            'Phối màu trắng đen kinh điển, đang rất hot ở giới trẻ Hà Nội và TP.HCM.',
        category: 'Sneaker phối đồ',
        image: 'assets/images/nike2.png',
        rating: 4.7,
        ratingCount: 2800,
      ),
      Product(
        id: 3,
        title: 'Adidas Samba OG Bản Việt Nam',
        price: 2990000,
        description:
            'Thiết kế gọn, đế bám tốt, phù hợp đi học và đi làm hằng ngày.',
        category: 'Sneaker retro',
        image: 'assets/images/nike3.png',
        rating: 4.6,
        ratingCount: 1900,
      ),
      Product(
        id: 4,
        title: 'Jordan 1 Low Wolf Grey',
        price: 4190000,
        description:
            'Mẫu Jordan tông xám được cộng đồng sneakerhead Việt săn đón mạnh.',
        category: 'Jordan hot',
        image: 'assets/images/nike4.png',
        rating: 4.9,
        ratingCount: 1550,
      ),
      Product(
        id: 5,
        title: 'New Balance 550 Sea Salt',
        price: 3650000,
        description:
            'Phong cách vintage thể thao, lên chân đẹp và êm khi đi lâu.',
        category: 'Sneaker retro',
        image: 'assets/images/nike5.png',
        rating: 4.7,
        ratingCount: 1300,
      ),
      Product(
        id: 6,
        title: 'Puma Palermo Đen Trắng',
        price: 2490000,
        description:
            'Phù hợp thời tiết Việt Nam, nhẹ chân, dễ vệ sinh, giá tốt.',
        category: 'Sneaker giá tốt',
        image: 'assets/images/nike6.png',
        rating: 4.5,
        ratingCount: 1100,
      ),
      Product(
        id: 7,
        title: 'Nike Zoom Vomero 5 Silver',
        price: 3990000,
        description:
            'Dad shoes cá tính, đệm êm và phối đồ đường phố cực nổi bật.',
        category: 'Sneaker chạy bộ',
        image: 'assets/images/nike7.png',
        rating: 4.8,
        ratingCount: 980,
      ),
      Product(
        id: 8,
        title: 'Asics Gel-Kayano 14 Cream',
        price: 4290000,
        description:
            'Mẫu chạy bộ cao cấp, được giới runner Việt đánh giá rất tốt.',
        category: 'Sneaker chạy bộ',
        image: 'assets/images/nike8.png',
        rating: 4.9,
        ratingCount: 860,
      ),
      Product(
        id: 9,
        title: 'Nike Air Max 97 Triple Black',
        price: 3890000,
        description: 'Đệm Air êm ái, phối màu all-black hợp đi làm và đi chơi.',
        category: 'Sneaker lifestyle',
        image: 'assets/images/nike1.png',
        rating: 4.6,
        ratingCount: 1450,
      ),
      Product(
        id: 10,
        title: 'Jordan 4 Military Black',
        price: 5490000,
        description: 'Hàng hot trend trên thị trường resale Việt Nam năm nay.',
        category: 'Jordan hot',
        image: 'assets/images/nike2.png',
        rating: 4.9,
        ratingCount: 1220,
      ),
      Product(
        id: 11,
        title: 'Adidas Campus 00s Core Black',
        price: 2790000,
        description: 'Phom dày xu hướng Y2K, phối cùng quần ống rộng rất hợp.',
        category: 'Sneaker phối đồ',
        image: 'assets/images/nike3.png',
        rating: 4.7,
        ratingCount: 1760,
      ),
      Product(
        id: 12,
        title: 'Converse Run Star Motion',
        price: 2690000,
        description:
            'Đế chunky phá cách, là item được ưa chuộng tại các campus.',
        category: 'Sneaker phối đồ',
        image: 'assets/images/nike4.png',
        rating: 4.5,
        ratingCount: 1330,
      ),
      Product(
        id: 13,
        title: 'Vans Knu Skool Black White',
        price: 2390000,
        description:
            'Phong cách skate cổ điển, chất liệu bền, rất được học sinh chọn mua.',
        category: 'Sneaker giá tốt',
        image: 'assets/images/nike5.png',
        rating: 4.4,
        ratingCount: 2010,
      ),
      Product(
        id: 14,
        title: 'New Balance 9060 Rain Cloud',
        price: 4690000,
        description:
            'Thiết kế tương lai, đệm dày êm chân, hợp streetwear Việt.',
        category: 'Sneaker lifestyle',
        image: 'assets/images/nike6.png',
        rating: 4.8,
        ratingCount: 920,
      ),
      Product(
        id: 15,
        title: 'Nike Cortez Vintage Green',
        price: 2590000,
        description:
            'Mẫu retro quay trở lại mạnh, nhẹ và thoải mái cho di chuyển hằng ngày.',
        category: 'Sneaker retro',
        image: 'assets/images/nike7.png',
        rating: 4.6,
        ratingCount: 1170,
      ),
      Product(
        id: 16,
        title: 'Onitsuka Tiger Mexico 66',
        price: 3190000,
        description:
            'Phong cách tối giản Nhật Bản, rất hợp khí hậu nóng ẩm ở Việt Nam.',
        category: 'Sneaker tối giản',
        image: 'assets/images/nike8.png',
        rating: 4.7,
        ratingCount: 1400,
      ),
    ];
  }
}
