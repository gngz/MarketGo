import 'dart:async';

import 'package:marketgo/models/CardModel.dart';
import 'package:marketgo/services/CardService.dart';

class CardsBloc {
  static final CardsBloc _singleton = CardsBloc._internal();

  List<CardModel> cards;

  factory CardsBloc() {
    return _singleton;
  }

  CardsBloc._internal() {
    cards = new List<CardModel>();
    _listBlocController.sink.add(cards);
  }

  final _listBlocController = StreamController<List<CardModel>>.broadcast();

  Stream<List<CardModel>> get stream => _listBlocController.stream;

  void getFromServer() async {
    var cards = await CardService().getCards();
    this.cards = cards;
    _listBlocController.sink.add(cards);
  }

  void dispose() {
    _listBlocController.close();
  }
}
