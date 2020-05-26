import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketgo/bloc/CardsBloc.dart';
import 'package:marketgo/components/MenuDrawer.dart';
import 'package:marketgo/models/CardModel.dart';
import 'package:marketgo/models/ListModel.dart';
import 'package:marketgo/views/AddCard.dart';

class PaymentList extends StatefulWidget {
  ListModel list;
  PaymentList({this.list});
  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  get ColorDarkBlue => Color(0xFF0083B0);

  void _addCard() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddCardView()));
  }

  @override
  void initState() {
    super.initState();
    CardsBloc().getFromServer();
  }

  Future<bool> _confirmDelete(CardModel card) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Eliminar o cartão ${card.brand} *${card.lastFour}."),
            content:
                const Text("Tem a certeza de que deseja eliminar este cartão?"),
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

  Image _getImageByCardBrand(String brand) {
    switch (brand.toLowerCase()) {
      case "visa":
        return Image.asset("assets/cards/visa.png");
      case "mastercard":
        return Image.asset("assets/cards/mastercard.png");
      case "american express":
        return Image.asset("assets/cards/amex.png");
      case "diners club":
        return Image.asset("assets/cards/diners.png");
      case "discover":
        return Image.asset("assets/cards/discovery.png");
      case "jcb":
        return Image.asset("assets/cards/jcb.png");
      case "unionpay":
        return Image.asset("assets/cards/union.png");
      default:
        return Image.asset("assets/cards/visa.png");
    }
  }

  Widget removeBackground() {
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

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuDrawer(
        selected: SELECTED_MENU.CARDS,
      ),
      appBar: AppBar(
        backgroundColor: ColorDarkBlue,
        automaticallyImplyLeading: false,
        title: Text("Cartões de Pagamento"),
      ),
      body: StreamBuilder<List<CardModel>>(
        stream: CardsBloc().stream,
        initialData: CardsBloc().cards,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          if (snapshot.data.length == 0)
            return Center(
              child: Text(
                "Não possui nenhum cartão de pagamentos.",
                style: TextStyle(color: Colors.grey),
              ),
            );

          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var card = snapshot.data[index];

                return Dismissible(
                  key: ObjectKey(card),
                  background: removeBackground(),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    var confirm = await _confirmDelete(card);
                    if (confirm) {
                      return await CardsBloc().removeCard(card);
                    }
                    return false;
                  },
                  child: Card(
                      child: ListTile(
                    leading: SizedBox(
                      child: _getImageByCardBrand(card.brand),
                      width: 80,
                    ),
                    title: Text(card.cardHolder),
                    subtitle: Text("*${card.lastFour}"),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      _doPayment();
                    },
                  )),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorDarkBlue,
        onPressed: _addCard,
        tooltip: "Adicionar Cartão",
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
    );
  }

  _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  void _doPayment() {
    var listId = this.widget.list.id;
    listId;
  }
}
