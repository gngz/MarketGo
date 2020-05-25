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
                      child: Text(card.brand),
                    );
                  });
            }));
  }
}
