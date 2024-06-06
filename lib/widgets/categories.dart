import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/categories.dart' as Cat;
import './category_item.dart';

class Categories extends ConsumerWidget{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(Cat.categoriesProvider);
    // return Container(
    //   padding: EdgeInsets.symmetric(horizontal: 15),
    //   child: Consumer<Cat.Categories>(
    //     builder: (ctx, categories, child) => ListView.builder(
    //       itemCount: categories.categoryList.length,
    //       itemBuilder: (ctx, index) => CategoryItem(
    //         name: categories.categoryList[index].name,
    //         imageUrl: categories.categoryList[index].imageUrl,
    //       ),
    //     ),
    //   ),
    // );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
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
