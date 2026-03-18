import 'package:flutter/material.dart';

class CategoryStrip extends StatelessWidget {
  const CategoryStrip({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryTap,
  }) : super(key: key);

  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.dashboard_customize_outlined,
      Icons.checkroom,
      Icons.phone_android,
      Icons.face,
      Icons.kitchen,
      Icons.sports_esports,
      Icons.watch,
      Icons.chair,
      Icons.more_horiz,
    ];

    return SizedBox(
      height: 190,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: categories.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          mainAxisExtent: 86,
        ),
        itemBuilder: (context, index) {
          final isAllItem = index == 0;
          final category = isAllItem ? null : categories[index - 1];
          final isSelected = isAllItem
              ? selectedCategory == null
              : selectedCategory == category;
          final displayName = isAllItem
              ? 'Tất cả'
              : category!.replaceFirst('Sneaker ', '');

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onCategoryTap(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE6F3FB) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF003049)
                      : const Color(0x22000000),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons[index % icons.length],
                    size: 20,
                    color: const Color(0xFF003049),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    displayName,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
