import 'package:marketgo/models/Transaction.dart';
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

  Future<Map<String, dynamic>> getTransactions(int page) async {
    try {
      var response = await ApiService()
          .getAuthHttp()
          .get("/payments", queryParameters: {"page": page});

      if (response.statusCode == 200) {
        return {
          "hasMore": page < response.data['lastPage'],
          "data": Transaction.fromList(response.data['data'])
        };

        //return Transaction.fromList(response.data['data']);
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}
