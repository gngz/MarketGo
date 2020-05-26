import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marketgo/bloc/UserBloc.dart';
import 'package:marketgo/models/UserDTO.dart';
import 'package:marketgo/services/Auth/Auth.dart';

enum SELECTED_MENU {
  LISTS,
  CARDS,
  PAYMENTS,
  ABOUT,
}

class MenuDrawer extends StatefulWidget {
  SELECTED_MENU selected;
  MenuDrawer({Key key, this.selected}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  get ColorDarkBlue => Color(0xFF0083B0);

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

  bool _checkCurrent(BuildContext drawerContext, SELECTED_MENU selected) {
    if (selected == widget.selected) {
      Navigator.pop(drawerContext);
      return true;
    }
    return false;
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
                decoration: BoxDecoration(color: ColorDarkBlue),
                accountEmail: Text(snapshot.data.user.email),
                accountName: Text(snapshot.data.user.name),
                currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.circular(110),
                  child: _getAvatar(snapshot.data.user.avatar),
                ),
              );
            }),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.solidListAlt),
          selected: widget.selected == SELECTED_MENU.LISTS,
          title: Text("Listas"),
          onTap: () {
            if (_checkCurrent(context, SELECTED_MENU.LISTS)) return;
            Navigator.pushReplacementNamed(context, "/lists");
          },
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.solidCreditCard),
          title: Text("Cartões de Pagamento"),
          selected: widget.selected == SELECTED_MENU.CARDS,
          onTap: () {
            if (_checkCurrent(context, SELECTED_MENU.CARDS)) return;
            Navigator.pushReplacementNamed(context, "/cards");
          },
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.receipt),
          title: Text("Pagamentos"),
          selected: widget.selected == SELECTED_MENU.PAYMENTS,
          onTap: () {
            if (_checkCurrent(context, SELECTED_MENU.PAYMENTS)) return;
            Navigator.pushReplacementNamed(context, "/payments");
          },
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.infoCircle),
          title: Text("Sobre Nós"),
          selected: widget.selected == SELECTED_MENU.ABOUT,
          onTap: () {
            if (_checkCurrent(context, SELECTED_MENU.ABOUT)) return;
            Navigator.pushReplacementNamed(context, "/about");
          },
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.signOutAlt),
          title: Text("Logout"),
          onTap: () async {
            await logout();
          },
        ),
      ]),
    );
  }
}
