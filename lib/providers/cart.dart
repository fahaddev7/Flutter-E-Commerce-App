import 'package:flutter/material.dart';

class CartItems {
  final String id;
  final String title;
  final double quantity;
  final double price;

  CartItems({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItems> _items = {};

  Map<String, CartItems> get items {
    return {..._items};
  }

  int get itemcount {
    return _items.length;
  }

  double get totalamount {
    var total = 0.0;
    _items.forEach((key, cart) {
      total += cart.price * cart.quantity;
    });
    return total;
  }

  void deleteitem(String productid) {
    _items.remove(productid);
    notifyListeners();
  }

  void addcart(String productid, double price, String title) {
    if (_items.containsKey(productid)) {
      _items.update(
          productid,
          (value) => CartItems(
              id: value.id,
              title: value.title,
              quantity: value.quantity + 1,
              price: value.price));
    } else {
      _items.putIfAbsent(
        productid,
        () => CartItems(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price),
      );
    }
    notifyListeners();
  }

  void clearcart() {
    _items = {};
    notifyListeners();
  }

  void removeitem(String productid) {
    if (!_items.containsKey(productid)) {
      return;
    }
    if (_items[productid].quantity > 1) {
      _items.update(
          productid,
          (existing) => CartItems(
              id: existing.id,
              title: existing.title,
              quantity: existing.quantity - 1,
              price: existing.price));
    } else {
      _items.remove(productid);
    }
    notifyListeners();
  }
}
