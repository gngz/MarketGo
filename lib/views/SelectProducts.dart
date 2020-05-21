import 'package:flutter/material.dart';
import 'package:marketgo/bloc/ProductsBloc.dart';
import 'package:marketgo/models/Product.dart';

class SelectProducts extends StatefulWidget {
  @override
  _SelectProductsState createState() => _SelectProductsState();
}

class _SelectProductsState extends State<SelectProducts> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorDarkBlue,
        automaticallyImplyLeading: false,
        title: Text("As minhas listas"),
        leading: null,
      ),
      body: StreamBuilder<Product>(
        stream: ProductsBloc().stream,
        builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
          if(snapshot.hasData) {

          }
          else return Center(child: CircularProgressIndicator());
          return Container(
            child: Text("Joao joao borges do conguito")
          );
        }
      ),
      )
  }
  
}
