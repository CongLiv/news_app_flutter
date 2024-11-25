import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/categories.dart' as cat;
import './category_item.dart';

class Categories extends ConsumerWidget{
  const Categories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(cat.categoriesProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        itemCount: categories.categoryList.length,
        itemBuilder: (ctx, index) => CategoryItem(
          name: categories.categoryList[index].name,
          imageUrl: categories.categoryList[index].imageUrl,
        ),
      ),
    );
  }
}
