class Product {
  String ean;
  String name;
  String description;
  double price;
  String image;
  int quantity;
  bool readed = false;

  Product({
    this.ean,
    this.name,
    this.description,
    this.price,
    this.image,
    this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var object = new Product(
      ean: json["ean"],
      name: json["name"],
      description: json["description"],
      price: json["price"] as double,
      image: json["image"],
      quantity: json["pivot"]["quantity"] as int,
    );

    return object;
  }

  static List<Product> fromList(List json) {
    return json.map((e) => Product.fromJson(e)).toList();
  }
}
