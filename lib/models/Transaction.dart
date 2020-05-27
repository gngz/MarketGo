class Transaction {
  String list;
  double total;
  DateTime date;

  Transaction({this.total, this.list, this.date});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return new Transaction(
      list: json['list_name'],
      total: double.tryParse(json['total']),
      date: DateTime.parse(json['created_at']),
    );
  }

  static List<Transaction> fromList(List json) {
    return json.map((e) => Transaction.fromJson(e)).toList();
  }
}
