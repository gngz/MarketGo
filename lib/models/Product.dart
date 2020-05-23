class Product {
  String ean;
  String name;
  String description;
  double price;
  String image;
  int quantity;
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
      price: json["price"],
      image: json["image"],
      quantity: json["pivot"]["quantity"],
    );

    return object;
  }

  static List<Product> fromList(List json) {
    return json.map((e) => Product.fromJson(e)).toList();
  }
}
