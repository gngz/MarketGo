import 'package:flutter/material.dart';
import 'package:marketgo/bloc/CategoryBloc.dart';
import 'package:marketgo/models/CategoryModel.dart';

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  void initState() {
    super.initState();
    CategoryBloc().getFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Categorias"),
        ),
        body: StreamBuilder<List<CategoryModel>>(
            stream: CategoryBloc().stream,
            initialData: CategoryBloc().categories,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var category = snapshot.data[index];

                    return ListTile(
                      title: Text(category.category),
                      trailing: Text("20 items"),
                    );
                  });
            }));
  }
}
