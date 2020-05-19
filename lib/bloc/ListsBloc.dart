import 'dart:async';

import 'package:marketgo/models/ListModel.dart';

class ListsBloc {
  static final ListsBloc _singleton = ListsBloc._internal();

  List<ListModel> lists;

  factory ListsBloc() {
    return _singleton;
  }

  ListsBloc._internal() {
    lists = new List<ListModel>();
    _listBlocController.sink.add(lists);
  }

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

  clear() {
    lists.clear();
    _listBlocController.sink.add(lists);
  }

  void dispose() {
    _listBlocController.close();
  }
}
