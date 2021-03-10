import 'package:flutter/material.dart';
import 'package:sala_app/Helpers/LanguageLocalization/app_localizations.dart';

class NoInternetWidget extends StatelessWidget {
  final Function onTap;

  // ignore: avoid_init_to_null
  const NoInternetWidget({Key key, this.onTap = null}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Icon(Icons.replay_outlined),
                Text(AppLocalizations.of(context).translate("no_internet")),
                Text(AppLocalizations.of(context).translate("check_your_internet")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
