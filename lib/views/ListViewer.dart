import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketgo/bloc/ProductsBloc.dart';
import 'package:marketgo/models/ListModel.dart';
import 'package:marketgo/models/Product.dart';

class ListViewer extends StatefulWidget {
  ListModel list;

  ListViewer({this.list});

  @override
  _ListViewerState createState() => _ListViewerState();
}

class _ListViewerState extends State<ListViewer> {
  final ColorDarkBlue = Color(0xFF0083B0);
  final ColorLightBlue = Color(0xFF000B4DB);

  @override
  void initState() {
    super.initState();

    ProductsBloc().getFromServer(this.widget.list.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              return ListView.separated(
                  itemBuilder: (context, index) {
                    var product = snapshot.data[index];
                    return ListTile(
                      leading: Image.network(product.image),
                      title: Text(product.name),
                      subtitle: Text("${product.price}€"),
                      trailing: Text("QTY ${product.quantity}"),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: snapshot.data.length);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
