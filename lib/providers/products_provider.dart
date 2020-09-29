// import 'dart:html';

import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authtoken;
  final String userid;

  ProductsProvider(
    this.authtoken,
    this.userid,
    this._items,
  );

  List<Product> get items {
    return [..._items];
  }

  List<Product> get onlyfavorite {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findmyid(String id) {
    return _items.firstWhere((e) => e.id == id);
  }

  Future<void> fetchproducts([bool filterbyuser = false]) async {
    final filterprod= filterbyuser? 'orderBy="creatorid"&equalTo="$userid"': '';
    var url =
        'https://shop-59802.firebaseio.com/products.json?auth=$authtoken&$filterprod';
    try {
      final response = await http.get(url);
      final extracteddata = json.decode(response.body) as Map<String, dynamic>;
      if (extracteddata == null) {
        return;
      }
      url =
          'https://shop-59802.firebaseio.com/userfavorites/$userid.json?auth=$authtoken';
      final responsefav = await http.get(url);
      final favdata = json.decode(responsefav.body);

      final List<Product> loadedproducts = [];
      extracteddata.forEach((prodId, prodbody) {
        loadedproducts.add(Product(
          id: prodId,
          title: prodbody['title'],
          description: prodbody['description'],
          price: prodbody['price'],
          isFavorite: favdata == null ? false : favdata[prodId] ?? false,
          imageUrl: prodbody['imageUrl'],
        ));
      });
      _items = loadedproducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addproduct(Product product) async {
    final url =
        'https://shop-59802.firebaseio.com/products.json?auth=$authtoken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'creatorid': userid,
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
      final newproduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newproduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateproduct(String id, Product newproduct) async {
    final productindex = _items.indexWhere((e) => e.id == id);
    if (productindex >= 0) {
      final url =
          'https://shop-59802.firebaseio.com/products/$id.json?auth=$authtoken';
      await http.patch(url,
          body: json.encode({
            'title': newproduct.title,
            'description': newproduct.description,
            'price': newproduct.price,
            'imageUrl': newproduct.imageUrl,
          }));
      _items[productindex] = newproduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteproduct(String id) {
    final url =
        'https://shop-59802.firebaseio.com/products/$id.json?auth=$authtoken';

    _items.removeWhere((e) => e.id == id);
    http.delete(url);
    notifyListeners();
  }
}
