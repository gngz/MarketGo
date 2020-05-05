import 'dart:async';

import 'package:marketgo/models/ListModel.dart';

class ListsBloc {
  static final ListsBloc _singleton = ListsBloc._internal();

  List<ListModel> lists = new List<ListModel>();

  factory ListsBloc() {
    return _singleton;
  }

  ListsBloc._internal();

  final _listBlocController = StreamController<List<ListModel>>.broadcast();

  Stream<List<ListModel>> get stream => _listBlocController.stream;

  addList(ListModel list) {
    lists.add(list);
    _listBlocController.sink.add(lists);
  }

  removeList(ListModel list) {
    lists.remove(list);
    _listBlocController.sink.add(lists);
  }

  void dispose() {
    _listBlocController.close();
  }
}
