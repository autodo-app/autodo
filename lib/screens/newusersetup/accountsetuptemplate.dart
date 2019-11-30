import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:autodo/theme.dart';

class AccountSetupScreen extends StatefulWidget {
  final Widget header, panel;

  AccountSetupScreen({@required this.header, @required this.panel});

  @override
  AccountSetupScreenState createState() => AccountSetupScreenState();
}

class AccountSetupScreenState extends State<AccountSetupScreen> {
  final Widget pullTab = Container(
    width: 50,
    height: 5,
    decoration: BoxDecoration(
        color: Colors.black.withAlpha(140),
        borderRadius: BorderRadius.all(Radius.circular(12.0))),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: SafeArea(
            child: SlidingUpPanel(
              maxHeight: viewportConstraints.maxHeight,
              minHeight: viewportConstraints.maxHeight - 110,
              parallaxEnabled: true,
              parallaxOffset: .5,
              body: widget.header,
              color: cardColor,
              panel: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: pullTab,
                  ),
                  widget.panel
                ],
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              onPanelSlide: (double pos) => setState(() {}),
            ),
          ),
        );
      }),
    );
  }
}
