import 'package:flutter/material.dart';
import 'package:marketgo/models/User.dart';
import 'package:marketgo/services/Auth/Auth.dart';

class MyListsView extends StatefulWidget {
  @override
  _MyListsViewState createState() => _MyListsViewState();
}

class _MyListsViewState extends State<MyListsView> {
  final ColorDarkBlue = Color(0xFF0083B0);
  final ColorLightBlue = Color(0xFF000B4DB);

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: LoginDrawer(),
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

class LoginDrawer extends StatefulWidget {
  LoginDrawer({
    Key key,
  }) : super(key: key);

  @override
  _LoginDrawerState createState() => _LoginDrawerState();
}

class _LoginDrawerState extends State<LoginDrawer> {
  _LoginDrawerState() {
    _getUserData();
  }

  _getUserData() async {
    User user = await Auth.getUser();
    setState(() {
      userEmail = user.email;
      userName = user.name;
      userAvatar = user.avatar;
    });
  }

  Widget _getAvatar() {
    if (userAvatar != null) {
      return Image.network(userAvatar);
    }
    return Image.asset("assets/avatar.png");
  }

  logout() async {
    await Auth.logout();
    Navigator.pushNamed(context, "/");
  }

  String userName = "";
  String userEmail = "";
  String userAvatar;

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      UserAccountsDrawerHeader(
        accountEmail: Text(userEmail),
        accountName: Text(userName),
        currentAccountPicture: ClipRRect(
          borderRadius: BorderRadius.circular(110),
          child: _getAvatar(),
        ),
      ),
      ListTile(
        leading: Icon(Icons.list),
        selected: true,
        title: Text("Listas"),
        onTap: () => {},
      ),
      ListTile(
        leading: Icon(Icons.payment),
        title: Text("Pagamentos"),
        onTap: () => {},
      ),
      ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text("Logout"),
        onTap: () async {
          await logout();
        },
      ),
    ]);
  }
}
