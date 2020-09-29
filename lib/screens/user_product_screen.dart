import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products_provider.dart';

class UserScreen extends StatelessWidget {
  static const routename = '/userscreen';

  Future<void> _refreshprod(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchproducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productdata = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Your Products"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProduct.routeName);
              }),
        ],
      ),
      body: FutureBuilder(
        future: _refreshprod(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshprod(context),
                    child: Consumer<ProductsProvider>(
                                          builder:(context,productdata,_)=> Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productdata.items.length,
                          itemBuilder: (context, i) => Column(
                            children: [
                              UserProductitem(
                                productdata.items[i].id,
                                productdata.items[i].title,
                                productdata.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
