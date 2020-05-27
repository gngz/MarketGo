import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:marketgo/bloc/PaymentsBloc.dart';
import 'package:marketgo/components/MenuDrawer.dart';
import 'package:marketgo/models/Transaction.dart';

class Payments extends StatefulWidget {
  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  static const ColorDarkBlue = Color(0xFF0083B0);

  bool loadingMore = false;

  _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    PaymentsBloc().reset();
    PaymentsBloc().getMore();
  }

  void loadMore() {
    loadingMore = true;
    PaymentsBloc().getMore();
    var subscription;

    subscription = PaymentsBloc().stream.listen((event) {
      setState(() {
        loadingMore = false;
      });
      subscription.cancel();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Image _getImageByCardBrand(String brand) {
    switch (brand.toLowerCase()) {
      case "visa":
        return Image.asset("assets/cards/visa.png");
      case "mastercard":
        return Image.asset("assets/cards/mastercard.png");
      case "american express":
        return Image.asset("assets/cards/amex.png");
      case "diners club":
        return Image.asset("assets/cards/diners.png");
      case "discover":
        return Image.asset("assets/cards/discovery.png");
      case "jcb":
        return Image.asset("assets/cards/jcb.png");
      case "unionpay":
        return Image.asset("assets/cards/union.png");
      default:
        return Image.asset("assets/cards/visa.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuDrawer(
        selected: SELECTED_MENU.PAYMENTS,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Histórico de Pagamentos"),
        backgroundColor: ColorDarkBlue,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: ColorDarkBlue,
        child: Row(
          children: <Widget>[
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.menu),
              tooltip: "Menu",
              onPressed: () => {_openDrawer()},
            )
          ],
        ),
      ),
      body: StreamBuilder<List<Transaction>>(
          stream: PaymentsBloc().stream,
          initialData: PaymentsBloc().transactions,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            var transactions = snapshot.data;

            if (transactions.isEmpty) {
              return Center(
                child: Text("Não possui nenhum pagamento"),
              );
            }

            return ListView.separated(
              itemBuilder: (context, index) {
                print("Building index $index");
                if (index < transactions.length) {
                  var transaction = transactions[index];
                  return ListTile(
                    leading: SizedBox(
                      child: _getImageByCardBrand(transaction.cardBrand),
                      width: 50,
                    ),
                    title: Text(transaction.list.toUpperCase()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(DateFormat('dd-MM-yyyy kk:mm')
                            .format(transaction.date)),
                        Text("*${transaction.cardLastFour}"),
                      ],
                    ),
                    trailing: Text("${transaction.total}€"),
                  );
                } else {
                  if (!loadingMore) {
                    loadMore();
                  }

                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: PaymentsBloc().hasMore
                  ? transactions.length + 1
                  : transactions.length,
            );
          }),
    );
  }
}
