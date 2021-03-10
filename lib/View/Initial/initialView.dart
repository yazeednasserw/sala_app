import 'package:flutter/material.dart';
import 'package:sala_app/Helpers/LanguageLocalization/app_localizations.dart';
import 'package:sala_app/ViewModel/initialViewModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:after_layout/after_layout.dart';

class InitialView extends StatefulWidget {
  final InitialViewModel initialVM;
  const InitialView({Key key, this.initialVM}) : super(key: key);

  @override
  _InitialViewState createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> with AfterLayoutMixin<InitialView> {
  Key key = new UniqueKey();
  double screenWidth;
  double screanHieght;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void performHotRestart() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    widget.initialVM.initSetup(this.context);
    // widget.initialVM.updateMainContext(this.context);

    screenWidth = MediaQuery.of(context).size.width;
    screanHieght = MediaQuery.of(context).size.height;

    return ScopedModel<InitialViewModel>(
      model: widget.initialVM,
      child: ScopedModelDescendant<InitialViewModel>(
        builder: (context, child, model) => Scaffold(
          backgroundColor: Color(0xff0C1638),
          body: body(),
        ),
      ),
    );
  }

  Widget body() {
    return ScopedModelDescendant<InitialViewModel>(
      builder: (context, child, model) => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 200,
                child: Image.asset(
                  "assets/images/Icon2.png",
                  fit: BoxFit.fill,
                )),
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              height: model.loadingAnimatedContainerHeight,
              child: Center(child: Container(height: 50, width: 50, child: CircularProgressIndicator())),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
    widget.initialVM.checkMemoryInfo();
    widget.initialVM.mainVM.performHotRestart = performHotRestart;
  }
}
