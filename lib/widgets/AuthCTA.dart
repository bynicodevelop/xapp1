import 'package:flutter/material.dart';

class AuthCTA extends StatelessWidget {
  final Function onPressed;

  const AuthCTA({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 5.0,
          ),
          child: Text(
            'Pouvoir voir toutes les publications',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 5.0,
          ),
          child: Text(
            'Connectez-vous',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 30.0,
          ),
          child: RaisedButton(
            onPressed: onPressed,
            child: Text('Me connecter'.toUpperCase()),
          ),
        )
      ],
    );
  }
}
