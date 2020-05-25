import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketgo/bloc/CardsBloc.dart';
import 'package:marketgo/models/CardModel.dart';

class CardList extends StatefulWidget {
  @override
  _CardListState createState() => _CardListState();
}

void _addCard() {}

class _CardListState extends State<CardList> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cartões de Pagamento"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.add), onPressed: _addCard)
          ],
        ),
        body: StreamBuilder<List<CardModel>>(
            stream: CardsBloc().stream,
            initialData: CardsBloc().cards,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var card = snapshot.data[index];

                    return Dismissible(
                      key: ObjectKey(card),
                      background: removeBackground(),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await _confirmDelete(card);
                      },
                      child: Card(
                          child: ListTile(
                        leading: SizedBox(
                          child: _getImageByCardBrand(card.brand),
                          width: 80,
                        ),
                        title: Text(card.cardHolder),
                        subtitle: Text("*${card.lastFour}"),
                      )),
                    );
                  });
            }));
  }
}
