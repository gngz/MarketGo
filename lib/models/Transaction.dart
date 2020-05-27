class Transaction {
  String list;
  double total;
  DateTime date;
  String cardBrand;
  String cardLastFour;

  Transaction(
      {this.total, this.list, this.date, this.cardBrand, this.cardLastFour});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return new Transaction(
      list: json['list_name'],
      total: double.tryParse(json['total']),
      date: DateTime.parse(json['created_at']),
      cardBrand: json['card_brand'],
      cardLastFour: json['card_last4'],
    );
  }

  static List<Transaction> fromList(List json) {
    return json.map((e) => Transaction.fromJson(e)).toList();
  }
}
