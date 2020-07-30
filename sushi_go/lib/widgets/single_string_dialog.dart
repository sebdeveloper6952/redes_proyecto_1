import 'package:flutter/material.dart';

class SingleStringDialog extends StatefulWidget {
  final String title;
  final String content;

  SingleStringDialog({
    this.title,
    this.content,
  });

  @override
  _SingleStringDialogState createState() => _SingleStringDialogState();
}

class _SingleStringDialogState extends State<SingleStringDialog> {
  final _formKey = GlobalKey<FormState>();
  String _value;

  void _validateForm(BuildContext context) {
    if (!_formKey.currentState.validate()) return;
    Navigator.pop(context, _value);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SimpleDialog(
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(0),
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
            widget.title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8.0,
            ),
            child: Text(
              widget.content,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8.0,
            ),
            child: Form(
              key: _formKey,
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) {
                  _value = val;
                },
                validator: (value) {
                  return null;
                },
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'CANCELAR',
                  ),
                ),
                FlatButton(
                  onPressed: () => _validateForm(context),
                  child: Text(
                    'UNIRSE',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
