import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/cart_badge_icon.dart';
import '../widgets/category_strip.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner_carousel.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.onGoToTab}) : super(key: key);

  final ValueChanged<int> onGoToTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _appBarSolid = false;
  double _appBarBlend = 0;
  String? _selectedCategory;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().initialFetch();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = context.read<ProductProvider>();
    final offset = _scrollController.hasClients ? _scrollController.offset : 0;
    final blend = (offset / 90).clamp(0.0, 1.0);
    final shouldSolid = blend > 0.22;

    if (shouldSolid != _appBarSolid || (blend - _appBarBlend).abs() > 0.02) {
      setState(() {
        _appBarSolid = shouldSolid;
        _appBarBlend = blend;
      });
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 320) {
      provider.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarColor = Color.lerp(
      Colors.transparent,
      const Color(0xFF0AA9D8),
      _appBarBlend,
    );

    return Consumer2<ProductProvider, CartProvider>(
      builder: (context, productProvider, cartProvider, _) {
        final categories =
            (productProvider.categories.isEmpty
                    ? const [
                        'Sneaker chạy bộ',
                        'Sneaker lifestyle',
                        'Jordan hot',
                        'Retro cổ điển',
                        'Giá tốt',
                        'Phối đồ',
                        'Đế êm',
                      ]
                    : productProvider.categories.take(7).toList())
                .toList();

        final productsByCategory = _selectedCategory == null
            ? productProvider.products
            : productProvider.products
                  .where((p) => p.category == _selectedCategory)
                  .toList();

        final query = _searchQuery.trim().toLowerCase();
        final products = query.isEmpty
            ? productsByCategory
            : productsByCategory.where((p) {
                return p.title.toLowerCase().contains(query) ||
                    p.description.toLowerCase().contains(query) ||
                    p.category.toLowerCase().contains(query);
              }).toList();

        return RefreshIndicator(
          onRefresh: productProvider.refresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 112,
                title: const Text(
                  'TH4 - Nhóm 2',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                backgroundColor: appBarColor,
                elevation: _appBarSolid ? 2 : 0,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: ColoredBox(
                  color: appBarColor ?? Colors.transparent,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: CartBadgeIcon(
                      count: cartProvider.uniqueItemCount,
                      onTap: () => widget.onGoToTab(1),
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    color: appBarColor,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: _appBarSolid ? 1 : 0.96,
                        ),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 9,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Tìm sản phẩm, thương hiệu, danh mục',
                          hintStyle: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF6B7280),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 40,
                          ),
                          prefixIcon: const Icon(Icons.search, size: 20),
                          suffixIcon: _searchQuery.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                  icon: const Icon(Icons.close, size: 18),
                                ),
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            right: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PromoBannerCarousel(),
                      const SizedBox(height: 14),
                      CategoryStrip(
                        categories: categories,
                        selectedCategory: _selectedCategory,
                        onCategoryTap: (category) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        'Gợi ý hôm nay',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (productProvider.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (productProvider.errorMessage != null)
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(productProvider.errorMessage!),
                    ),
                  ),
                )
              else if (products.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 52,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Không tìm thấy sản phẩm phù hợp',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Thử từ khóa khác hoặc chọn lại mục Tất cả.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(
                                product: product,
                                onGoToCart: () => widget.onGoToTab(1),
                              ),
                            ),
                          );
                        },
                      );
                    }, childCount: products.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.78,
                        ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Visibility(
                  visible: productProvider.isLoadingMore,
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
