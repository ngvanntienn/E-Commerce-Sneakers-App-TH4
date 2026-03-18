import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PromoBannerCarousel extends StatefulWidget {
  const PromoBannerCarousel({Key? key}) : super(key: key);

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  int currentIndex = 0;

  final List<_PromoBannerData> banners = const [
    _PromoBannerData(
      imagePath: 'assets/images/nike1.png',
      title: 'Giày Sneaker giảm đến 40%',
      subtitle: 'Nike, Adidas, Puma chính hãng',
      tag: 'Sneaker',
      accentColor: Color(0xFF1D4ED8),
    ),
    _PromoBannerData(
      imagePath: 'assets/images/nike3.png',
      title: 'BST Giày mới 2026',
      subtitle: 'Cập nhật xu hướng thời trang mới nhất',
      tag: 'New',
      accentColor: Color(0xFFDC2626),
    ),
    _PromoBannerData(
      imagePath: 'assets/images/nike6.png',
      title: 'Giày chạy bộ siêu nhẹ',
      subtitle: 'Êm ái, thoáng khí, phù hợp mọi địa hình',
      tag: 'Running',
      accentColor: Color(0xFF059669),
    ),
    _PromoBannerData(
      imagePath: 'assets/images/nike8.png',
      title: 'Freeship toàn quốc',
      subtitle: 'Đơn từ 199K - Nhận hàng nhanh chóng',
      tag: 'Sale',
      accentColor: Color(0xFF7C3AED),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          itemBuilder: (context, index, realIndex) {
            final banner = banners[index];
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x29000000),
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(banner.imagePath, fit: BoxFit.cover),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xBF0B132B),
                            banner.accentColor.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: -24,
                      top: -20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -18,
                      bottom: -24,
                      child: Container(
                        width: 92,
                        height: 92,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              banner.tag,
                              style: const TextStyle(
                                color: Color(0xFF0B132B),
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.28),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.24),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  banner.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  banner.subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFFE5ECFF),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 132,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeOutCubic,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => Container(
              width: currentIndex == index ? 18 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: currentIndex == index
                    ? const Color(0xFF0B132B)
                    : const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PromoBannerData {
  const _PromoBannerData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.accentColor,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final String tag;
  final Color accentColor;
}
