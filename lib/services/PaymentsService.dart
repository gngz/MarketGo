import 'package:marketgo/services/ApiService.dart';

class PaymentsService {
  static PaymentsService _instance = PaymentsService._internal();

  PaymentsService._internal();

  factory PaymentsService() {
    return _instance;
  }

  Future<bool> pay(List<String> productIds, String cardId, int listId) async {
    try {
      var response = await ApiService().getAuthHttp().post("/payments/",
          data: {"products": productIds, "card_id": cardId, "list_id": listId});
      if (response.statusCode == 200) return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
