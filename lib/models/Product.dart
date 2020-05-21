class Product {
  String ean;
  String name;
  String description;
  double price;
  String image;
  Product({this.ean, this.name, this.description, this.price, this.image});

  factory Product.fromJson(Map<String, dynamic> json) {
    var object = new Product(
        ean: json["ean"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        image: json["image"]);
    return object;
  }
}
