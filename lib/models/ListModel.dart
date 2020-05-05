class ListModel {
  int id;
  String name;

  ListModel({this.id, this.name});

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return new ListModel(id: json['id'], name: json['name']);
  }
}
