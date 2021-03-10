import 'package:flutter/material.dart';
import 'package:sala_app/Helpers/LanguageLocalization/app_localizations.dart';
import 'package:sala_app/Helpers/shared/appColors.dart';
import 'package:sala_app/Helpers/shared/appTextStyles.dart';

import 'package:sala_app/ViewModel/tempViewModel.dart';
import 'package:scoped_model/scoped_model.dart';

class TempView extends StatefulWidget {
  final TempViewModel tempVM;
  const TempView({Key key, this.tempVM}) : super(key: key);

  @override
  _TempViewState createState() => _TempViewState();
}

class _TempViewState extends State<TempView> {
  double screenWidth;
  double screanHieght;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    widget.tempVM.initSetup(this.context);
    // widget.tempVM.updateMainContext(this.context);

    screenWidth = MediaQuery.of(context).size.width;
    screanHieght = MediaQuery.of(context).size.height;

    return ScopedModel<TempViewModel>(
      model: widget.tempVM,
      child: ScopedModelDescendant<TempViewModel>(
        builder: (context, child, model) => Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: model.backButtonTapped,
            ),
            title: Text(
              AppLocalizations.of(context).translate("Temp"),
              style: h2.copyWith(fontWeight: FontWeight.bold, color: white),
              textAlign: TextAlign.center,
            ),
          ),
          body: Center(
            child: Text("temp"),
          ),
        ),
      ),
    );
  }
}
