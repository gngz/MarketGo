import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:marketgo/bloc/CategoryBloc.dart';
import 'package:marketgo/bloc/ProductsBloc.dart';
import 'package:marketgo/config.dart';
import 'package:marketgo/models/CategoryModel.dart';
import 'package:marketgo/models/ListModel.dart';
import 'package:marketgo/models/Product.dart';
import 'package:marketgo/services/ProductService.dart';

class CategoryList extends StatefulWidget {
  ListModel list;

  CategoryList({this.list});
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final ColorDarkBlue = Color(0xFF0083B0); //TODO COLOCAR NUMA STATIC class
  final ColorLightBlue = Color(0xFF000B4DB);
  int selectedCategory = -1;
  bool searchMode = false;
  String searchQuery = "";
  @override
  void initState() {
    super.initState();
    CategoryBloc().getFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawer(),
      appBar: AppBar(
        title: searchMode ? _searchTextField() : Text("Procurar produtos"),
        actions: _actions(),
      ),
      body: _getProductsList(),
    );
  }

  List<Widget> _actions() {
    var actions = <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        tooltip: 'Procurar produtos',
        onPressed: () {
          setState(
            () {
              searchMode = !searchMode;
            },
          );
        },
      ),
    ];
    if (searchMode)
      actions.insert(
        0,
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _searchController.clear();
              searchQuery = "";
            });
          },
        ),
      );

    return actions;
  }

  var _searchController = TextEditingController();

  TextField _searchTextField() => TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Procurar produtos',
          hintStyle: TextStyle(color: Colors.white),
        ),
        style: TextStyle(color: Colors.white),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      );

  Widget _getProductsList() {
    Future service;
    if (selectedCategory == -1) {
      service = ProductService().getAll();
    } else {
      service = ProductService().getProductFromCategory(selectedCategory);
    }
    return FutureBuilder<List<Product>>(
        future: service,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data.isEmpty)
            return Center(child: Text("Erro ao carregar produtos"));
          var products =
              searchMode ? filter(searchQuery, snapshot.data) : snapshot.data;
          return ListView.builder(
              itemBuilder: (context, index) {
                var product = products[index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      _selectedProduct(product);
                      Navigator.pop(context);
                    },
                    title: Text(product.name),
                    leading: SizedBox(
                        child: Image.network(product.image), width: 56),
                    trailing: IconButton(
                        icon: Icon(Icons.chevron_right), onPressed: null),
                    subtitle: Text("${product.price.toStringAsFixed(2)} €"),
                  ),
                );
              },
              itemCount: products.length);
        });
  }

  void _selectedProduct(
    Product product,
  ) {
    ProductsBloc().addProduct(product.ean, this.widget.list.id);
  }

  List<Product> filter(String filterQuery, List<Product> list) {
    if (filterQuery == "") return list;
    return list.where((product) {
      return product.name.toLowerCase().contains(filterQuery.toLowerCase());
    }).toList();
  }

  Widget _drawer() {
    return Drawer(
      child: new StreamBuilder<List<CategoryModel>>(
          stream: CategoryBloc().stream,
          //initialData: CategoryBloc().categories,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              CategoryBloc().getFromServer();

              return Center(child: CircularProgressIndicator());
            }
            /* if (snapshot.data.isEmpty)
              return Center(child: Text("Erro ao carregar categorias")); */

            var categories = new List<CategoryModel>();
            categories.addAll(snapshot.data);
            categories.insert(
              0,
              CategoryModel(
                  id: -1,
                  category: "Todas as categorias",
                  image: "assets/categories/all.png"),
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DrawerHeader(
                  child: Text("Categorias",
                      style: TextStyle(color: Colors.white, fontSize: 23)),
                  decoration: BoxDecoration(
                    color: ColorDarkBlue,
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        var category = categories[index];
                        return ListTile(
                          leading: Image.network(
                            "${Config().baseUrl}/${category.image}",
                            height: 40,
                          ),
                          title: Text(category.category),
                          selected: category.id == selectedCategory,
                          onTap: () {
                            setState(() {
                              selectedCategory = category.id;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: categories.length),
                ),
              ],
            );
          }),
    );
  }
}

class _searchField {}
