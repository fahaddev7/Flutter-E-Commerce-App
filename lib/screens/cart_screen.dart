import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routename = "/cart-screen";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart Items"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total",
                      style: TextStyle(fontSize: 20),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Spacer(),
                    Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        "\Tk ${cart.totalamount.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    OrderButton(cart: cart)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cart.itemcount,
            itemBuilder: (context, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].title,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].price),
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalamount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addorders(
                  widget.cart.items.values.toList(), widget.cart.totalamount);
              setState(() {
                _isLoading = false;
              });
              widget.cart.clearcart();
            },
      child: _isLoading? CircularProgressIndicator():Text("Order Now"),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
