import 'package:flutter/material.dart';
import 'package:marketgo/bloc/ListsBloc.dart';
import 'package:marketgo/bloc/UserBloc.dart';
import 'package:marketgo/models/ListModel.dart';
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

  _addList(String name) {
    ListsBloc().addList(new ListModel(name: name));
  }

  Widget _inputDialog() {
    String listName = "";

    return AlertDialog(
      content: TextField(
        autofocus: true,
        decoration: new InputDecoration(
            labelText: "Nome da Lista",
            hintText: "e.g: Lista para Festa do João"),
        onChanged: (value) {
          listName = value;
        },
        onSubmitted: (value) {
          _addList(value);
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
        FlatButton(
            onPressed: () {
              _addList(listName);
              Navigator.pop(context);
            },
            child: Text("Adicionar"))
      ],
    );
  }

  void _showInputDialog() async {
    await showDialog(context: context, child: _inputDialog());
  }

  Future<bool> _confirmDelete(listName) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Eliminar a lista $listName."),
            content:
                const Text("Tem a certeza de que deseja eliminar esta lista?"),
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
        child: StreamBuilder<List<ListModel>>(
            stream: ListsBloc().stream,
            initialData: List<ListModel>(),
            builder: (BuildContext context,
                AsyncSnapshot<List<ListModel>> snapshot) {
              if (snapshot.data.isEmpty) {
                return Center(
                  child: Text(
                    "Que tal criar uma lista?",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              return ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Dismissible(
                    background: Padding(
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
                    ),
                    direction: DismissDirection.endToStart,
                    key: ObjectKey(snapshot.data[index]),
                    confirmDismiss: (direction) async {
                      return _confirmDelete(snapshot.data[index].name);
                    },
                    onDismissed: (direction) {
                      ListsBloc().removeList(snapshot.data[index]);
                    },
                    child: ListTile(
                      title: Text(snapshot.data[index].name),
                      onTap: () {},
                      trailing: Icon(Icons.chevron_right),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Container(color: Colors.grey, height: 1),
              );
            }),
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
          onPressed: () => {_showInputDialog()},
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
