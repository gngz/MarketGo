import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketgo/bloc/CardsBloc.dart';
import 'package:marketgo/models/CardModel.dart';
import 'package:marketgo/models/ListModel.dart';
import 'package:marketgo/models/Product.dart';
import 'package:marketgo/services/PaymentsService.dart';
import 'package:marketgo/views/AddCard.dart';
import 'package:marketgo/views/MyLists.dart';

class PaymentList extends StatefulWidget {
  final ListModel list;
  final List<Product> products;
  PaymentList({this.list, this.products});
  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  static const ColorDarkBlue = Color(0xFF0083B0);

  void _addCard() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddCardView()));
  }

  @override
  void initState() {
    super.initState();
    CardsBloc().getFromServer();
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

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Widget _checkDialog() {
    return AlertDialog(
      title: const Text("Pagamento"),
      content:
          const Text("Tem a certeza que deseja usar este cartão de pagamento?"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Usar este cartão")),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text("Cancelar"),
        )
      ],
    );
  }

  Future<bool> _showCheckDialog() async {
    var result = await showDialog(
        context: context, builder: (context) => _checkDialog());

    return result != null ? result : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: ColorDarkBlue,
        title: Text("Escolha o cartão de pagamento"),
      ),
      body: StreamBuilder<List<CardModel>>(
        stream: CardsBloc().stream,
        initialData: CardsBloc().cards,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          if (snapshot.data.length == 0)
            return Center(
              child: Text(
                "Não possui nenhum cartão de pagamentos.",
                style: TextStyle(color: Colors.grey),
              ),
            );

          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var card = snapshot.data[index];

                return Card(
                    child: ListTile(
                  leading: SizedBox(
                    child: _getImageByCardBrand(card.brand),
                    width: 80,
                  ),
                  title: Text(card.cardHolder),
                  subtitle: Text("*${card.lastFour}"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () async {
                    if (await _showCheckDialog()) {
                      _doPayment(card);
                    }
                  },
                ));
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorDarkBlue,
        onPressed: _addCard,
        tooltip: "Adicionar Cartão",
        child: Icon(Icons.add),
      ),
    );
  }

  List<String> getScannedProductsEan() {
    List<String> list = new List();

    for (var product in this.widget.products) {
      if (product.readed) list.add(product.ean);
    }
    return list;
  }

  Future<void> _doPayment(CardModel cardId) async {
    var listId = this.widget.list.id;
    var eanList = getScannedProductsEan();

    _showLoadingDialog();
    if (await PaymentsService().pay(eanList, cardId.id, listId)) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MyListsView(
            snackbar: SnackBar(
              content: Text("Pagamento efetuado com sucesso. Obrigado!"),
              action: SnackBarAction(
                label: "Ok",
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
    } else {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Pagamento não sucedido"),
          content: Text(
            "Ocorreu um erro a processar o pagamento com este cartão.\nTente com outro cartão.",
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            )
          ],
        ),
      );
    }
  }

  void _showLoadingDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
