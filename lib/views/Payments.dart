import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketgo/components/MenuDrawer.dart';

class Payments extends StatefulWidget {
  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  static const ColorDarkBlue = Color(0xFF0083B0);

  _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuDrawer(
        selected: SELECTED_MENU.PAYMENTS,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Pagamentos"),
        backgroundColor: ColorDarkBlue,
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
        ),
      ),
      body: ListView(),
    );
  }
}
