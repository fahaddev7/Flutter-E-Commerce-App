// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import '../providers/product.dart';

class EditProduct extends StatefulWidget {
  static const routeName = '/editproduct';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _pricefocus = FocusNode();
  final _descfocus = FocusNode();
  final imagecontroller = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _newproduct = Product(
    id: null,
    title: "",
    description: "",
    price: 0,
    imageUrl: "",
  );

  var _initvalues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": "",
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productid = ModalRoute.of(context).settings.arguments as String;
      if (productid != null) {
        _newproduct = Provider.of<ProductsProvider>(context, listen: false)
            .findmyid(productid);

        _initvalues = {
          "title": _newproduct.title,
          "description": _newproduct.description,
          "price": _newproduct.price.toString(),
          "imageUrl": "",
        };
        imagecontroller.text = _newproduct.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveform() async {
    final isvalid = _form.currentState.validate();
    if (!isvalid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_newproduct.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateproduct(_newproduct.id, _newproduct);
      
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addproduct(_newproduct);
      } catch (error) {
        await showDialog<Null>(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('An error occured'),
                  content: Text('Something went wrong'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
      } 
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _pricefocus.dispose();
    _descfocus.dispose();
    imagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveform,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initvalues["title"],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Cant be Empty!';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _newproduct = Product(
                          id: _newproduct.id,
                          isFavorite: _newproduct.isFavorite,
                          title: value,
                          price: _newproduct.price,
                          imageUrl: _newproduct.imageUrl,
                          description: _newproduct.description,
                        );
                      },
                      autofocus: true,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_pricefocus);
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Title",
                      ),
                    ),
                    TextFormField(
                      initialValue: _initvalues["price"],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Cant be Empty!';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Cant be zero';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newproduct = Product(
                          id: _newproduct.id,
                          isFavorite: _newproduct.isFavorite,
                          title: _newproduct.title,
                          price: double.parse(value),
                          imageUrl: _newproduct.imageUrl,
                          description: _newproduct.description,
                        );
                      },
                      focusNode: _pricefocus,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descfocus);
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Price",
                      ),
                    ),
                    TextFormField(
                      initialValue: _initvalues["description"],
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Cant be Empty!';
                        }
                        if (value.length < 10) {
                          return 'should be more than 10 characters';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _newproduct = Product(
                          id: _newproduct.id,
                          isFavorite: _newproduct.isFavorite,
                          title: _newproduct.title,
                          price: _newproduct.price,
                          imageUrl: _newproduct.imageUrl,
                          description: value,
                        );
                      },
                      maxLines: 3,
                      focusNode: _descfocus,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: "Description",
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          height: 50,
                          width: 50,
                          margin: EdgeInsets.only(top: 15, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: imagecontroller.text.isEmpty
                              ? Text("Upload Image")
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.network(imagecontroller.text)),
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: _initvalues["imageUrl"],
                            onSaved: (value) {
                              _newproduct = Product(
                                id: _newproduct.id,
                                isFavorite: _newproduct.isFavorite,
                                title: _newproduct.title,
                                price: _newproduct.price,
                                imageUrl: value,
                                description: _newproduct.description,
                              );
                            },
                            controller: TextEditingController(),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) {
                              _saveform();
                            },
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(
                              labelText: "Image",
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
