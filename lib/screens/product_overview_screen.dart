import 'package:flutter/material.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showfavorites = false;
  var _isloading = false;

  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchproducts()
        .then((_) {
      setState(() {
        _isloading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final itemno = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (selected) {
              setState(() {
                if (selected == 0) {
                  _showfavorites = true;
                } else {
                  _showfavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("My Favourites"),
                value: 0,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: 1,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartcount, ch) => Badge(
              child: ch,
              value: cartcount.itemcount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routename);
              },
            ),
          ),
        ],
        title: Text("MyShop"),
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProductsGrid(_showfavorites),
            ),
      drawer: AppDrawer(),
    );
  }
}
