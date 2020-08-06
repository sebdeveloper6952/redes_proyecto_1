import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String title;
  const LoadingDialog({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SimpleDialog(
        titlePadding: const EdgeInsets.all(0),
        // contentPadding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        children: <Widget>[
          Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
