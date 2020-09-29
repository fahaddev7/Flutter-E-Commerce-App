import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import '../screens/orders_screen.dart';
import '../screens/user_product_screen.dart';


class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("User"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: (){
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.storage),
            title: Text("Orders"),
            onTap: (){
              Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.storage),
            title: Text("Manage Products"),
            onTap: (){
              Navigator.pushReplacementNamed(context, UserScreen.routename);
            },
          ),
          Divider(),
          
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("LogOut"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context,listen: false).logout();
            },
          ),
        ],
      ),
    );
      
    
  }
}