import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketgo/bloc/ProductsBloc.dart';
import 'package:marketgo/models/ListModel.dart';
import 'package:marketgo/models/Product.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:marketgo/views/CategoryList.dart';
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

  bool isShopMode = false;

  @override
  void initState() {
    super.initState();

    ProductsBloc().getFromServer(this.widget.list.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: _getFAB(),
      appBar: AppBar(
        backgroundColor: ColorDarkBlue,
        title: Text(widget.list.name),
        actions: <Widget>[
          IconButton(
              tooltip: "Adicionar Produto",
              icon: Icon(Icons.add),
              onPressed: () {
                _goCategoryListView();
              })
        ],
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
                      trailing: _showPayButton(),
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
                              child: _productTile(product));
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

  Widget _productTile(Product product) {
    return ListTile(
      leading: SizedBox(
        child: Image.network(product.image),
        width: 56,
      ),
      trailing: _getTrailingIcon(product),
      title: Text(product.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Quantidade: ${product.quantity}"),
          Text("Preço Unitário: ${product.price.toStringAsFixed(2)}€"),
        ],
      ),
      onTap: () async {
        var newQuantity = await _showEditQuantity(product);

        if (newQuantity != null) {
          await ProductsBloc()
              .updateQuantity(widget.list.id, product, newQuantity);
        }
      },
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

  Future<int> _showEditQuantity(Product product) async {
    return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          confirmWidget: Text("Ok"),
          cancelWidget: Text("Cancelar"),
          title: new Text("Selecione uma nova quantidade:"),
          minValue: 1,
          maxValue: 100,
          step: 1,
          initialIntegerValue: product.quantity,
        );
      },
    );
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

  Widget _getFAB() {
    if (isShopMode) {
      return FloatingActionButton(
          tooltip: "Scan de Produto",
          child: Image.asset("assets/barcode-icon.png", height: 32, width: 32),
          onPressed: () async {
            String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                "#FF0000", "Cancelar", false, ScanMode.BARCODE);

            print("BARCODE: $barcodeScanRes");

            if (barcodeScanRes != "-1") {
              try {
                if (await ProductsBloc()
                    .setReaded(barcodeScanRes, widget.list.id)) {
                  _showSnackBar("Produto adicionado com sucesso");
                } else {
                  _showSnackBar("O produto não está disponível!");
                }
              } catch (e) {
                _showSnackBar("O produto já está no carrinho");
              }
            } else {}
          });
    } else {
      return FloatingActionButton(
          tooltip: "Iniciar Compra",
          child: FaIcon(FontAwesomeIcons.shoppingCart),
          onPressed: () {
            setState(() {
              this.isShopMode = true;
            });
          });
    }
  }

  Widget _getTrailingIcon(Product product) {
    if (isShopMode) {
      if (product.readed) {
        return Image.asset(
          "assets/barcode-green.png",
          height: 32,
          width: 32,
        );
      }
      return Image.asset("assets/barcode-red.png",
          height: 32, width: 32, color: Color.fromARGB(50, 0, 0, 0));
    }

    return null;
  }

  _goCategoryListView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryList(
          list: this.widget.list,
        ),
      ),
    );
  }

  _showPayButton() {
    if (_hasScannedProducts())
      return RaisedButton(
        onPressed: () {
          _doPayment();
        },
        child: Text("PAGAR"),
        color: Colors.white,
        textColor: Color(0xff00AFD7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );
  }

  bool _hasScannedProducts() {
    for (var product in ProductsBloc().product) {
      if (product.readed) return true;
    }
    return false;
  }

  void _doPayment() {}
}
