import 'package:marketgo/models/CardModel.dart';
import 'package:marketgo/services/ApiService.dart';

class CardService {
  static CardService _instance = CardService._internal();

  CardService._internal();

  factory CardService() {
    return _instance;
  }

  Future<List<CardModel>> getCards() async {
    try {
      var response = await ApiService().getAuthHttp().get("/cards/");

      if (response.statusCode == 200) {
        return CardModel.fromList(response.data);
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> removeCard(String cardId) async {
    try {
      var response = await ApiService()
          .getAuthHttp()
          .delete("/cards/", data: {"id": cardId});

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<CardModel> addCard(CardModel card) async {
    try {
      var response = await ApiService().getAuthHttp().post("/cards/", data: {
        "name": card.cardHolder,
        "card_number": card.lastFour,
        "exp_month": card.expMonth,
        "exp_year": card.expYear,
        "cvc": card.cvc,
      });

      if (response.statusCode == 201) {
        return CardModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
