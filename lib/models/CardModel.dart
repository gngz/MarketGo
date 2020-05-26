class CardModel {
  String id;
  String brand;
  int expMonth;
  int expYear;
  String lastFour;
  String cardHolder;
  int cvc;

  CardModel({
    this.id,
    this.brand,
    this.expMonth,
    this.expYear,
    this.lastFour,
    this.cardHolder,
    this.cvc,
  });

  static List<CardModel> fromList(List json) {
    return json.map((e) => CardModel.fromJson(e)).toList();
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return new CardModel(
      id: json['id'],
      brand: json['brand'],
      expMonth: json['exp_month'] as int,
      expYear: json['exp_year'] as int,
      lastFour: json['last4'],
      cardHolder: json['name'],
    );
  }
}
