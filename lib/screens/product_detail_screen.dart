// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routename = "/productdetailscreen";
  @override
  Widget build(BuildContext context) {
    final productid = ModalRoute.of(
      context,
    ).settings.arguments as String;
    final loadedproduct =
        Provider.of<ProductsProvider>(context).findmyid(productid);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedproduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Hero(tag: loadedproduct.id,
                child: Image.network(loadedproduct.imageUrl,fit: BoxFit.cover,)),
            ),
            SizedBox(height: 10,),
            Text("Tk ${loadedproduct.price}", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(loadedproduct.description),
            )
          ],
        ),
      ),
    );
  }
}
