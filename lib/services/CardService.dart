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
}
