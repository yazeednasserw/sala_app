import 'package:flutter/material.dart';
import 'package:sala_app/Helpers/LanguageLocalization/app_localizations.dart';

Future<dynamic> showConfirmDialog(BuildContext context, title, content) async {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(AppLocalizations.of(context).translate("no")),
    onPressed: () => Navigator.maybePop(context, false),
  );
  Widget continueButton = FlatButton(
    child: Text(AppLocalizations.of(context).translate("yes")),
    onPressed: () => Navigator.maybePop(context, true),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(title: title, content: content, actions: [cancelButton, continueButton]);

  // show the dialog
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<dynamic> showActionDialog(BuildContext context, title, content, {Function action, String actionText}) async {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(AppLocalizations.of(context).translate("close")),
    onPressed: () => Navigator.pop(context, false),
  );
  Widget continueButton = FlatButton(
      child: Text(AppLocalizations.of(context).translate(actionText)),
      onPressed: () {
        Navigator.pop(context, true);
        action();
      });

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(title: title, content: content, actions: [cancelButton, continueButton]);

  // show the dialog
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
