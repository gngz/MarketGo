import 'package:flutter/material.dart';
import 'package:marketgo/bloc/UserBloc.dart';
import 'package:marketgo/models/User.dart';
import 'package:marketgo/services/Auth/Auth.dart';

class MyListsView extends StatefulWidget {
  @override
  _MyListsViewState createState() => _MyListsViewState();
}

class _MyListsViewState extends State<MyListsView> {
  final ColorDarkBlue = Color(0xFF0083B0);
  final ColorLightBlue = Color(0xFF000B4DB);
  final LoginDrawer loginDrawer = LoginDrawer();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: loginDrawer,
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
  Widget _getAvatar(avatar) {
    if (avatar != null) {
      return Image.network(avatar);
    }
    return Image.asset("assets/avatar.png");
  }

  logout() async {
    await Auth.logout();
    Navigator.pushNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      StreamBuilder<User>(
          stream: UserBloc().stream,
          initialData: UserBloc().user,
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            return UserAccountsDrawerHeader(
              accountEmail: Text(snapshot.data.email),
              accountName: Text(snapshot.data.name),
              currentAccountPicture: ClipRRect(
                borderRadius: BorderRadius.circular(110),
                child: _getAvatar(snapshot.data.avatar),
              ),
            );
          }),
      ListTile(
        leading: Icon(Icons.list),
        selected: true,
        title: Text("Listas"),
        onTap: () => {},
      ),
      ListTile(
        leading: Icon(Icons.payment),
        title: Text("Pagamentos"),
        onTap: () => {
          UserBloc().setUser(new User(
              avatar: null, name: "Josefino", email: "emai@dojose.fino"))
        },
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
