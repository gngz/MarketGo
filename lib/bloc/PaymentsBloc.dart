import 'dart:async';

import 'package:marketgo/models/Transaction.dart';
import 'package:marketgo/services/PaymentsService.dart';

class PaymentsBloc {
  static final PaymentsBloc _singleton = PaymentsBloc._internal();

  List<Transaction> transactions;
  int _page = 1;
  bool _hasMore = true;
  get hasMore => _hasMore;

  factory PaymentsBloc() {
    return _singleton;
  }

  PaymentsBloc._internal() {
    transactions = new List<Transaction>();
    _paymentsBlocController.sink.add(transactions);
  }

  final _paymentsBlocController =
      StreamController<List<Transaction>>.broadcast();

  Stream<List<Transaction>> get stream => _paymentsBlocController.stream;

  Future<void> getMore() async {
    if (_hasMore) {
      var result = await PaymentsService().getTransactions(_page);
      if (result != null) {
        _hasMore = result["hasMore"];
        transactions.addAll(result["data"]);
        _paymentsBlocController.sink.add(transactions);
        _page++;
      }
    }
  }

  void reset() {
    _page = 1;
    _hasMore = true;
    transactions.clear();
  }

  void dispose() {
    _paymentsBlocController.close();
  }
}
