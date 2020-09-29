import 'package:flutter/material.dart';
import 'package:shop_app/widgets/drawer.dart';
import 'package:shop_app/widgets/order_item.dart';
import '../providers/orders.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/ordersscreen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isloading = false;

  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
     Provider.of<Orders>(context,listen: false).fetchorders().then((_) {
       setState(() {
         _isloading= false;
       });
     });
     
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body:_isloading? Center(child: CircularProgressIndicator()) :ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (context,i)=>OrderItemsingle(ordersData.orders[i]),
      ),
    );
  }
}
