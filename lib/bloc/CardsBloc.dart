import 'dart:async';

import 'package:marketgo/models/CardModel.dart';
import 'package:marketgo/services/CardService.dart';

class CardsBloc {
  static final CardsBloc _singleton = CardsBloc._internal();

  List<CardModel> cards = new List<CardModel>();

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
    if (cards != null) {
      this.cards = cards;
      _listBlocController.sink.add(cards);
    }
  }

  Future<bool> removeCard(CardModel card) async {
    var removed = await CardService().removeCard(card.id);
    if (removed) {
      cards.remove(card);
      _listBlocController.sink.add(cards);
      return true;
    }

    return false;
  }

  Future<bool> addCard(CardModel card) async {
    var createdCard = await CardService().addCard(card);

    if (createdCard != null) {
      cards.add(createdCard);
      _listBlocController.sink.add(cards);
      return true;
    }

    return false;
  }

  void dispose() {
    _listBlocController.close();
  }
}
