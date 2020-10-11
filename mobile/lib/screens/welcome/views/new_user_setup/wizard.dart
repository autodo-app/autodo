import 'dart:async';

import 'package:flutter/material.dart';

class WizardInfo {
  WizardInfo(this._wizard);

  final WizardState _wizard;

  void next() {
    _wizard._setPage(_wizard._page + 1);
  }

  void previous() {
    _wizard._setPage(_wizard._page - 1);
  }

  FutureOr<void> onStart(BuildContext context) {}

  FutureOr<int> willChangePage(
          BuildContext context, int oldPage, int newPage) =>
      newPage;

  FutureOr<void> didFinish(BuildContext context) {}

  FutureOr<void> didCancel(BuildContext context) {}

  void cancel() {
    _wizard._setPage(-1);
  }

  void finish() {
    _wizard._setPage(_wizard.widget.children.length);
  }
}

class Wizard<T extends WizardInfo> extends StatefulWidget {
  const Wizard({
    Key key,
    @required this.children,
    @required this.builder,
    this.loading,
  })  : assert(children != null),
        assert(builder != null),
        super(key: key);

  final List<Widget> children;

  final T Function(BuildContext context, WizardState state) builder;

  final Widget loading;

  static T of<T extends WizardInfo>(BuildContext context) {
    final widget = context.findAncestorWidgetOfExactType<_WizardInherited<T>>();
    assert(widget != null);
    assert(widget.state is T);
    return widget.state;
  }

  @override
  WizardState createState() => WizardState<T>();
}

class WizardState<T extends WizardInfo> extends State<Wizard<T>> {
  /// The current page
  var _page = 0;

  /// The global wizard state
  T _state;

  var _ready = false;

  @override
  void reassemble() {
    if (_page < 0) _page = 0;
    if (_page >= widget.children.length) _page = widget.children.length - 1;

    super.reassemble();
  }

  Future<void> _setPage(int value) async {
    while (true) {
      if (value < 0) {
        await _state.didCancel(context);
        return;
      }
      if (value >= widget.children.length) {
        await _state.didFinish(context);
        return;
      }
      if (value == _page) return;
      final changed = await _state.willChangePage(context, _page, value);
      if (changed == value) break;
      value = changed;
    }

    setState(() {
      _page = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_state == null) {
      _state = widget.builder(context, this);
      final start = _state.onStart(context);
      if (start is Future) {
        start.then((_) {
          setState(() {
            _ready = true;
          });
        });
      } else {
        _ready = true;
      }
    }

    if (!_ready) {
      return widget.loading ?? SizedBox();
    }

    return _WizardInherited<T>(widget.children[_page], _state);
  }
}

class _WizardInherited<T extends WizardInfo> extends InheritedWidget {
  const _WizardInherited(
    Widget child,
    this.state,
  ) : super(child: child);

  final T state;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
