class CategoryModel {
  int id;
  String category;

  CategoryModel({
    this.id,
    this.category,
  });

  static List<CategoryModel> fromList(List json) {
    return json.map((e) => CategoryModel.fromJson(e)).toList();
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return new CategoryModel(
      id: json['id'],
      category: json['name'],
    );
  }
}
