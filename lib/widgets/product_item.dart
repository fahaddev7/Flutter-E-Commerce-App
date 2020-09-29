import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Product>(
      context,
    );
    final cart = Provider.of<Cart>(context, listen: false);
    final authfav = Provider.of<Auth>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        child: GestureDetector(
          child: Hero(
            tag: products.id,
                      child: Image.network(
              products.imageUrl,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, ProductDetailScreen.routename,
                arguments: products.id);
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(
                products.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              products.togglefavorite(authfav.token,authfav.userId);
            },
            color: Theme.of(context).accentColor,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addcart(products.id, products.price, products.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(action: SnackBarAction(label: "UNDO", onPressed: (){
                  cart.removeitem(products.id);
                },),
                  content: Text("Added item to cart!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            products.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
