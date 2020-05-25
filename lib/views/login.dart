import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:marketgo/bloc/UserBloc.dart';
import 'package:marketgo/components/FacebookButton.dart';
import 'package:marketgo/components/GoogleButton.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:marketgo/models/UserDTO.dart';
import 'package:marketgo/services/Auth/Auth.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final logo = Image.asset("assets/logo.png");
  final _formKey = GlobalKey<FormState>();
  final facebookLogin = FacebookLogin();
  String email;
  String password;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  _LoginViewState() {
    _checkLogin();
  }

  _checkLogin() async {
    try {
      UserDTO userData = await Auth.getUser();
      if (userData.user.email != null) {
        UserBloc().setUser(userData);
        _goListView();
      }
    } catch (e) {
      print(e);
      _showSnackBar("Ocorreu um erro ao iniciar sessão!");
    }
  }

  _goListView() {
    Navigator.pushReplacementNamed(context, "/listview");
  }

  _facebookHandler() async {
    facebookLogin.loginBehavior = FacebookLoginBehavior.nativeWithFallback;
    try {
      final result = await facebookLogin.logInWithReadPermissions(['email']);
      await Auth.autenticateSocial(
          SocialProvider.FACEBOOK, result.accessToken.token);
      _goListView();
    } on DioError catch (e) {
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        _showSnackBar("Não foi possivel contactar o servidor!");
      }
    } catch (e) {
      _showSnackBar("Ocorreu um erro ao iniciar sessão!");
      print(e);
    }
  }

  _googleHandler() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    try {
      var result = await googleSignIn.signIn();
      var auth = await result.authentication;
      _showLoadingDialog();
      await Auth.autenticateSocial(SocialProvider.GOOGLE, auth.accessToken);
      Navigator.pop(context); //pode dar shit
      _goListView();
    } on DioError catch (e) {
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        _showSnackBar("Não foi possivel contactar o servidor!");
      }
      Navigator.pop(context);
    } catch (e) {
      _showSnackBar("Ocorreu um erro ao iniciar sessão!");
      print(e);
      Navigator.pop(context);
    }
  }

  void loginHandler() async {
    if (_formKey.currentState.validate()) {
      try {
        _showLoadingDialog();

        await Auth.authenticate(this.email, this.password);
        Navigator.pop(context);
        _goListView();
      } on DioError catch (e) {
        if (e.type == DioErrorType.CONNECT_TIMEOUT) {
          _showSnackBar("Não foi possivel contactar o servidor!");
        }
        Navigator.pop(context);
      } catch (e) {
        _showSnackBar("Ocorreu um erro ao iniciar sessão!");
        print(e);
        Navigator.pop(context);
      }
    }
  }

  void registerHandler() {
    Navigator.pushNamed(context, "/register");
  }

  static const secondary = const Color(0xff0088B4);

  // @Manel what is this?
  static final underlineTextField =
      UnderlineInputBorder(borderSide: BorderSide(color: secondary));

  // Email Field
  Widget emailField() {
    return TextFormField(
      obscureText: false,
      decoration: InputDecoration(labelText: "E-mail", focusColor: secondary),
      onChanged: (value) => this.email = value,
      validator: (value) {
        if (value.isEmpty) return "Deverá inserir um email";
        if (!EmailValidator.validate(value)) return "E-mail com formato errado";
        return null;
      },
    );
  }
  // Password Field

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(labelText: "Password"),
      onChanged: (value) => {this.password = value},
      validator: (value) {
        if (value.isEmpty) return "Deverá inserir uma password";

        return null;
      },
    );
  }

  // Login Button

  Widget loginButton() {
    return FlatButton(
        color: secondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("Login"),
        ),
        onPressed: loginHandler,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)));
  }

  // Register Button

  Widget registerButton() {
    return FlatButton(
      textColor: secondary,
      child: Text("Register"),
      onPressed: registerHandler,
    );
  }

  Widget _divider() {
    final Color color = Colors.grey[400];

    return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Divider(
              color: color,
              thickness: 1.0,
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Ou",
                style: TextStyle(color: color),
              ),
            ),
            Expanded(
                child: Divider(
              color: color,
              thickness: 1.0,
            ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/wave.png"),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(height: 100.0),
                    Hero(tag: "logo", child: Center(child: logo)),
                    SizedBox(height: 50.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          emailField(),
                          SizedBox(height: 20.0),
                          passwordField()
                        ],
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[registerButton(), loginButton()],
                    ),
                    _divider(),
                    Column(
                      children: <Widget>[
                        GoogleButton(
                            onPressed: () async => {await _googleHandler()}),
                        FacebookButton(
                            onPressed: () async => {await _facebookHandler()}),
                      ],
                    )
                  ],
                ),
                Container()
              ],
            ),
          ),
        ));
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        action: new SnackBarAction(
          label: "OK",
          onPressed: () => {},
          textColor: Colors.cyan,
        ),
        content: Text(text)));
  }

  void _showLoadingDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    //needs refactoring i'd like dependency inversion here but idk how to! im a noob :'( pls help lord of programming aka gngz)
  }
}
