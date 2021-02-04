import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  const Error({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Icon(Icons.phonelink_erase),
          ),
          Text(
            'An occured error...',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
