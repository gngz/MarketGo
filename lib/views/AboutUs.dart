import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketgo/components/MenuDrawer.dart';

class AboutUs extends StatelessWidget {
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
        selected: SELECTED_MENU.ABOUT,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Sobre nós"),
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
      body: ListView(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
            child: Image.asset(
              "assets/logo.png",
              height: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "MarketGo é a aplicação mais recente do mercado que permite ir às compras de uma forma rápida e eficaz. Sem qualquer custo e  sem demoras, já pode preparar as suas listas em casa e começar a comprar.",
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }
}
