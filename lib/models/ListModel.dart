class ListModel {
  int id;
  String name;

  ListModel({this.id, this.name});

  static List<ListModel> fromList(List json) {
    return json.map((e) => ListModel.fromJson(e)).toList();
  }

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return new ListModel(id: json['id'], name: json['name']);
  }
}
