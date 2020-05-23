import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketgo/bloc/ProductsBloc.dart';
import 'package:marketgo/models/ListModel.dart';
import 'package:marketgo/models/Product.dart';
import 'package:numberpicker/numberpicker.dart';

class ListViewer extends StatefulWidget {
  ListModel list;

  ListViewer({this.list});

  @override
  _ListViewerState createState() => _ListViewerState();
}

class _ListViewerState extends State<ListViewer> {
  final ColorDarkBlue = Color(0xFF0083B0);
  final ColorLightBlue = Color(0xFF000B4DB);

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    ProductsBloc().getFromServer(this.widget.list.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
          child: FaIcon(FontAwesomeIcons.shoppingCart), onPressed: () {}),
      appBar: AppBar(
        backgroundColor: ColorDarkBlue,
        title: Text(widget.list.name),
        actions: <Widget>[IconButton(icon: Icon(Icons.add), onPressed: () {})],
      ),
      body: StreamBuilder<List<Product>>(
          stream: ProductsBloc().stream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.hasData) {
              var products = snapshot.data;
              if (products.length == 0)
                return Center(child: Text("Ainda não adicionou produtos!"));
              return Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [ColorDarkBlue, ColorLightBlue])),
                    child: ListTile(
                      title: Text("TOTAL",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          "${_calculateTotal(products).toStringAsFixed(2)}€ ",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          var product = snapshot.data[index];
                          return Dismissible(
                            background: _dismissibleBackground(),
                            direction: DismissDirection.endToStart,
                            key: ObjectKey(product),
                            confirmDismiss: (direction) async {
                              return await _confirmDelete(product.name);
                            },
                            onDismissed: (direction) async {
                              var isDeleted = await ProductsBloc()
                                  .removeProduct(product, widget.list.id);
                              if (!isDeleted)
                                _showSnackBar("Não foi possível apagar.");
                            },
                            child: ListTile(
                              leading: Image.network(product.image),
                              title: Text(product.name),
                              subtitle: Text("${product.price}€"),
                              trailing: Text("QTY ${product.quantity}"),
                              onTap: () {
                                _editQuantity(product);
                              },
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: snapshot.data.length),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget _dismissibleBackground() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.red[300],
          ),
          Text(
            "Remover",
            style: TextStyle(color: Colors.red[300]),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmDelete(productName) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Eliminar o produto $productName."),
            content: const Text(
                "Tem a certeza de que deseja eliminar este produto?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Eliminar")),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancelar"),
              ),
            ],
          );
        });
  }

  Future<int> _editQuantity(Product product) async {
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          minValue: 0,
          maxValue: 100,
          step: 1,
          initialIntegerValue: product.quantity,
        );
      },
    ).then((num value) {
      if (value != null) {}
    });
  }

  //return NumberPicker.integer(initialValue: 1, minValue: 1, maxValue: 100, onChanged: () => {});
  double _calculateTotal(List<Product> productList) {
    return productList.fold(
        0.00, (value, element) => value + (element.price * element.quantity));
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        action: new SnackBarAction(
          label: "OK",
          onPressed: () => {},
          textColor: Colors.cyan,
        ),
        content: Text(text)));
  }
}
