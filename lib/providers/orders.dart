import 'dart:convert';

import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItems> products;
  final DateTime datetime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.datetime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

final String authtoken;
final String userid;

Orders(this.authtoken,this.userid,this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchorders() async {
    final url = 'https://shop-59802.firebaseio.com/orders/$userid.json?auth=$authtoken';
    final response = await http.get(url);
    final List<OrderItem> loadedproducts = [];
    final extracteddata = json.decode(response.body) as Map<String, dynamic>;
    if(extracteddata==null){
      return;
    }
    extracteddata.forEach((orderid, orderdata) {
      loadedproducts.add(
        OrderItem(
          id: orderid,
          amount: orderdata['amount'],
          products: (orderdata['products'] as List<dynamic>)
              .map(
                (e) => CartItems(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price'],
                ),
              )
              .toList(),
          datetime: DateTime.parse(
            orderdata['datetime'],
          ),
        ),
      );
    });
    _orders = loadedproducts.reversed.toList();
    notifyListeners();
  }

  Future<void> addorders(List<CartItems> cartproducts, double total) async {
    final url = 'https://shop-59802.firebaseio.com/orders/$userid.json?auth=$authtoken';
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'products': cartproducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
          'datetime': timestamp.toIso8601String()
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartproducts,
        datetime: timestamp,
      ),
    );
    notifyListeners();
  }
}
