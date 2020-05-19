import 'package:flutter/material.dart';
import 'package:marketgo/bloc/UserBloc.dart';
import 'package:marketgo/models/UserDTO.dart';
import 'package:marketgo/services/Auth/Auth.dart';

class MenuDrawer extends StatefulWidget {
  MenuDrawer({
    Key key,
  }) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
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
    return Drawer(
      child: ListView(children: <Widget>[
        StreamBuilder<UserDTO>(
            stream: UserBloc().stream,
            initialData: UserBloc().user,
            builder: (BuildContext context, AsyncSnapshot<UserDTO> snapshot) {
              return UserAccountsDrawerHeader(
                accountEmail: Text(snapshot.data.user.email),
                accountName: Text(snapshot.data.user.name),
                currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.circular(110),
                  child: _getAvatar(snapshot.data.user.avatar),
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
          onTap: () => {},
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Logout"),
          onTap: () async {
            await logout();
          },
        ),
      ]),
    );
  }
}
