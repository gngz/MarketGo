import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketgo/bloc/CardsBloc.dart';
import 'package:marketgo/models/CardModel.dart';

class CardList extends StatefulWidget {
  @override
  _CardListState createState() => _CardListState();
}

void _addCard() {}

Image _getImageByCardBrand(String brand) {
  switch (brand.toLowerCase()) {
    case "visa":
      return Image.asset("assets/cards/visa.png");
    case "mastercard":
      return Image.asset("assets/cards/mastercard.png");
    case "amex":
      return Image.asset("assets/cards/amex.png");
    case "discover":
      return Image.asset("assets/cards/discovery.png");
    default:
      return Image.asset("assets/cards/visa.png");
  }
}

class _CardListState extends State<CardList> {
  @override
  void initState() {
    super.initState();
    CardsBloc().getFromServer();
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

                    return Card(
                        child: ListTile(
                      leading: _getImageByCardBrand(card.brand),
                      title: Text(card.cardHolder),
                      subtitle: Text("*${card.lastFour}"),
                    ));
                  });
            }));
  }
}
