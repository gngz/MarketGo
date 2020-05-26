class CategoryModel {
  int id;
  String category;
  String image;
  CategoryModel({
    this.id,
    this.category,
    this.image,
  });

  static List<CategoryModel> fromList(List json) {
    return json.map((e) => CategoryModel.fromJson(e)).toList();
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return new CategoryModel(
        id: json['id'], category: json['name'], image: json['image']);
  }
}
