class Product {
  String ean;
  String name;
  String description;
  double price;
  String image;
  int quantity;
  String location;
  bool readed = false;

  Product({
    this.ean,
    this.name,
    this.description,
    this.price,
    this.image,
    this.quantity,
    this.location,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var object = new Product(
      ean: json["ean"],
      name: json["name"],
      description: json["description"],
      price: json["price"].toDouble(),
      image: json["image"],
      location: json["location"],
      quantity: json["pivot"] == null ? null : json["pivot"]["quantity"] as int,
    );

    return object;
  }

  static List<Product> fromList(List json) {
    return json.map((e) => Product.fromJson(e)).toList();
  }
}
