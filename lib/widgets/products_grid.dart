import 'package:flutter/material.dart';

import 'product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductsGrid extends StatelessWidget {

  final bool showfavorites;
  ProductsGrid(this.showfavorites);
  @override
  Widget build(BuildContext context) {
    final productsdata = Provider.of<ProductsProvider>(context);
    final products = showfavorites? productsdata.onlyfavorite :productsdata.items;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 5,
          mainAxisSpacing: 10,
          childAspectRatio: 3 / 2,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value:products[index],
              child: ProductItem(),
            )
        // ProductItem(
        //   products[index].id,
        //   products[index].title,
        //   products[index].imageUrl,
        // ),
        );
  }
}
