import 'package:flutter/material.dart';

class MyListsView extends StatefulWidget {
  @override
  _MyListsViewState createState() => _MyListsViewState();
}

class _MyListsViewState extends State<MyListsView> {
  final ColorDarkBlue = Color(0xFF0083B0);
  final ColorLightBlue = Color(0xFF000B4DB);

  Widget drawerChild() {
    return ListView(children: <Widget>[
      UserAccountsDrawerHeader(
        accountEmail: Text("mail@diogopassos.pt"),
        accountName: Text("Gonçalo Passos"),
        currentAccountPicture: ClipRRect(
          borderRadius: BorderRadius.circular(110),
          child: Image.network(
              "https://lh3.googleusercontent.com/a-/AOh14GgCJUUOwtQSo9GhwLHRo1Bg_luKTY2pqjZqxVmxuQ"),
        ),
      ),
      ListTile(
        leading: Icon(Icons.payment),
        title: Text("Pagamentos"),
        trailing: Icon(Icons.arrow_forward),
        onTap: () => {},
      )
    ]);
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: drawerChild(),
      ),
      appBar: AppBar(
        backgroundColor: ColorDarkBlue,
        automaticallyImplyLeading: false,
        title: Text("As minhas listas"),
        leading: null,
      ),
      body: Container(
        child: Center(),
      ),
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: ColorDarkBlue,
          child: Row(
            children: <Widget>[
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.menu),
                tooltip: "Menu",
                onPressed: () => {_openDrawer()},
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
          backgroundColor: ColorDarkBlue,
          onPressed: () => {},
          tooltip: "A new button",
          child: Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
