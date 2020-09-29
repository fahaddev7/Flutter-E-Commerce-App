import 'package:flutter/material.dart';
import '../providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItemsingle extends StatelessWidget {
  final OrderItem order;

  OrderItemsingle(this.order);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Tk ${order.amount}"),
            subtitle: Text(DateFormat.MMMEd().format(order.datetime)),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
