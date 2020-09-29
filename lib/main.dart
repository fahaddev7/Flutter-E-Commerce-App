// import 'dart:js';

// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import "package:shop_app/providers/products_provider.dart";
import 'package:provider/provider.dart';
import 'package:shop_app/screens/splash_screen.dart';
import './providers/cart.dart';
import 'screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, ProductsProvider>(
            update: (context, auth, previousproduct) => ProductsProvider(
                auth.token,
                auth.userId,
                previousproduct == null ? [] : previousproduct.items),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (context, auth, previousorders) => Orders(
              auth.token,
              auth.userId,
              previousorders == null ? [] : previousorders.orders,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.autologin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routename: (context) => ProductDetailScreen(),
              CartScreen.routename: (context) => CartScreen(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              UserScreen.routename: (context) => UserScreen(),
              EditProduct.routeName: (context) => EditProduct(),
            },
          ),
        ));
  }
}
