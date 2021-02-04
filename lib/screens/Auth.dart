import 'package:flutter/material.dart';
import 'package:flutter_auth_form/flutter_auth_form.dart';
import 'package:provider/provider.dart';
import 'package:xapp/main.dart';
import 'package:xapp/providers/AuthProvider.dart';

class Auth extends StatefulWidget {
  const Auth({Key key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final dynamic listMessages = {
    'user-not-found': 'Bad credentials.',
    'invalid-password': 'Invalid password (min: 6 chars)',
    'too-many-requests':
        'Too many connection attempts. Try again in a few minutes.',
    'unexpected-error': 'Unexpected error'
  };

  AuthProvider _authProvider;

  void snackbar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            _scaffoldKey.currentState.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          AuthForm(
            title: 'Connexion',
            buttonLabel: 'Connexion',
            emailLabel: 'Enter your email',
            passwordLabel: 'Enter your password',
            onPressed: (userModel) async {
              try {
                await _authProvider.login(userModel.email, userModel.password);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => App(),
                  ),
                  (Route<dynamic> route) => false,
                );
              } catch (e) {
                try {
                  snackbar(listMessages[e.message]);
                } catch (e) {
                  snackbar(listMessages['unexpected-error']);
                }
              }
            },
          )
        ],
      ),
    );
  }
}
