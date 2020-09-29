import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productid;
  final String title;
  final double quantity;
  final double price;

  CartItem(this.id,this.productid, this.title, this.quantity, this.price);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (d){
        
        return showDialog(context: context,builder: (context)=> AlertDialog(
          title: Text("Are you sure?"),
          content: Text("Do you want to remove the item?"),
          actions: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(context).pop(false);
            }, child: Text("No"),),
            FlatButton(onPressed: (){
              Navigator.of(context).pop(true);
            }, child: Text("Yes"),),
          ],
        ));
      },
      onDismissed: (d) {
        Provider.of<Cart>(context, listen: false).deleteitem(productid);
      },
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        child: Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,),
          padding: EdgeInsets.only(right: 20),
        color: Theme.of(context).errorColor,
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
        child: ListTile(
          leading: CircleAvatar(

            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(
                  child: Text("$price")),
            ),
          ),
          title: Text(title),
          subtitle: Text("Total: Tk ${quantity * price}"),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
