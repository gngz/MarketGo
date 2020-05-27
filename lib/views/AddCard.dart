import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketgo/bloc/CardsBloc.dart';
import 'package:marketgo/models/CardModel.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddCardView extends StatefulWidget {
  @override
  _AddCardViewState createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  CardModel card = new CardModel();

  final cvcFormatter =
      new MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')});

  final expFormatter = new MaskTextInputFormatter(
      mask: '##/##', filter: {"#": RegExp(r'[0-9]')});

  final ccFormatter = new MaskTextInputFormatter(
      mask: "#### #### #### ####", filter: {"#": RegExp(r'[0-9]')});

  static const ColorDarkBlue = Color(0xFF0083B0);

  Widget _getImageByCardBrand(String brand) {
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
      default:
        return const SizedBox();
    }
  }

  bool creditCardValid(String cardNumber) {
    final visa = RegExp(r"^4[0-9]{12}(?:[0-9]{3})?$");
    final mastercard = RegExp(
        r"^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$");

    final amex = RegExp(r"^3[47][0-9]{13}$");
    final diners = RegExp(r"^3(?:0[0-5]|[68][0-9])[0-9]{11}$");
    final discover = RegExp(r"^6(?:011|5[0-9]{2})[0-9]{12}$");
    final jcb = RegExp(r"^(?:2131|1800|35\d{3})\d{11}$");

    return visa.hasMatch(cardNumber) ||
        mastercard.hasMatch(cardNumber) ||
        amex.hasMatch(cardNumber) ||
        diners.hasMatch(cardNumber) ||
        discover.hasMatch(cardNumber) ||
        jcb.hasMatch(cardNumber);
  }

  String getCardType(String cardNumber) {
    final amexCard = {"regex": RegExp(r"^3[47]"), "brand": "american express"};
    final dinersCard = {
      "regex": RegExp(r"^3(?:0[0-5]|[68])"),
      "brand": "diners club"
    };
    final discoverCard = {"regex": RegExp(r"^6(?:011|5)"), "brand": "discover"};
    final jcbCard = {
      "regex": RegExp(r":^(?:2131|1800|35\d{3})"),
      "brand": "jcb"
    };
    final masterCard = {
      "regex": RegExp(
          r"^(?:5[1-5]|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)"),
      "brand": "mastercard"
    };
    final visaCard = {"regex": RegExp(r"^4"), "brand": "visa"};

    var validators = [
      amexCard,
      dinersCard,
      discoverCard,
      jcbCard,
      masterCard,
      visaCard
    ];

    for (int i = 0; i < validators.length; i++) {
      RegExp reg = validators[i]["regex"];
      String brand = validators[i]["brand"];

      if (reg.hasMatch(cardNumber)) {
        return brand;
      }
    }

    return null;
  }

  String leadingZeros(String string) {
    if (string == null) return null;
    return string.padLeft(2, "0");
  }

  Widget drawCard(CardModel card) {
    return Container(
        height: 200,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: Offset(5, 5)),
            ],
            gradient:
                LinearGradient(colors: [Color(0xFF00508D), Color(0xFF0092DD)])),
        child: Stack(
          children: <Widget>[
            Positioned(
                bottom: 20,
                left: 20,
                child: Row(
                  children: <Widget>[
                    Text(
                      card.cardHolder ?? "Card Holder",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "  ${leadingZeros(card.expMonth?.toString()) ?? leadingZeros(DateTime.now().month.toString())}/${card.expYear ?? DateTime.now().year.toString().substring(2)}",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
            Positioned(
              bottom: 60,
              left: 20,
              child: Text(
                card.lastFour ?? "1234 5678 8765 4321",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              height: 50,
              child: _getImageByCardBrand(card.brand ?? ""),
            ),
          ],
        ));
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Cartão"),
        backgroundColor: ColorDarkBlue,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            drawCard(card),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty)
                    return "Tem de introduzir o nome do titular do cartão.";
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    card.cardHolder = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Titular do Cartão",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                inputFormatters: [ccFormatter],
                validator: (value) {
                  if (value.isEmpty)
                    return "Tem de introduzir um número de cartão de crédito.";

                  if (!creditCardValid(ccFormatter.getUnmaskedText()))
                    return "Tem de introduzir um número de cartão de crédito válido";

                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Número do Cartão",
                ),
                onChanged: (value) {
                  setState(() {
                    card.lastFour = value;
                    card.brand = getCardType(value);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                  inputFormatters: [expFormatter],
                  validator: (value) {
                    if (value.isEmpty)
                      return "Tem de introduzir uma data de expiração.";

                    var date = DateTime.now();
                    var expDate =
                        DateTime(card.expYear + 2000, card.expMonth + 1)
                            .subtract(Duration(days: 1));

                    if (expDate.isBefore(date))
                      return "Tem de introduzir uma data de expiração posterior ao dia de hoje.";

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Data de Vencimento",
                  ),
                  onChanged: (value) {
                    print(value);

                    var splited = value.split("/");

                    if (splited.length > 1) {
                      print("contains!! ${splited[0]}");
                      print(splited);
                      var month = splited[0];
                      var year = splited[1];
                      setState(() {
                        card.expMonth = int.parse(month);
                        card.expYear = int.parse(year);
                      });
                    } else {
                      setState(() {
                        var month = splited[0];
                        card.expMonth = int.parse(month);
                        card.expYear = null;
                      });
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                inputFormatters: [cvcFormatter],
                validator: (value) {
                  var val = cvcFormatter.getUnmaskedText();
                  if (val.isEmpty) return "Tem de introduzir um CVC.";
                  if (val.length < 3)
                    return "Tem de introduzir um CVC com 3 dígitos.";
                  return null;
                },
                onChanged: (value) {
                  print(value);
                  setState(() {
                    card.cvc = value as int;
                  });
                },
                decoration: InputDecoration(
                  labelText: "CVC",
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: ColorDarkBlue,
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              if (await CardsBloc().addCard(card)) {
                _formKey.currentState.reset();
                Navigator.pop(context);
              }
            }
          },
          child: Icon(Icons.done)),
    );
  }
}
