import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class AutoScrollField extends StatefulWidget {
  const AutoScrollField({
    Key key,
    @required this.child,
    @required this.focusNode,
    @required this.controller,
    this.position,
    this.curve = Curves.ease,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  /// The node we will monitor to determine if the child is focused
  final FocusNode focusNode;

  /// The child widget that we are wrapping
  final Widget child;

  /// The scroll controller to manipulate
  final ScrollController controller;

  final double position;

  /// The curve we will use to scroll ourselves into view.
  ///
  /// Defaults to Curves.ease.
  final Curve curve;

  /// The duration we will use to scroll ourselves into view
  ///
  /// Defaults to 200 milliseconds.
  final Duration duration;

  @override
  AutoScrollFieldState createState() => AutoScrollFieldState();
}

class AutoScrollFieldState extends State<AutoScrollField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_scroll);

    /// WidgetsBinding is used to get a function invoked when the
    /// window size changes (rotation, keyboard, etc.)
    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    widget.focusNode.removeListener(_scroll);
    super.dispose();
  }

  double _getScrollPosition() {
    final RenderObject object = context.findRenderObject();
    final RenderAbstractViewport viewport = RenderAbstractViewport.of(object);
    if (viewport == null) return null;

    return viewport.getOffsetToReveal(object, 0.0).offset;
  }

  Future<Null> _scroll() async {
    if (!widget.focusNode.hasFocus) return;

    final double scrollTo = widget.position ?? _getScrollPosition();
    if (scrollTo == null) return; // can't scroll
    await widget.controller
        .animateTo(scrollTo, duration: widget.duration, curve: widget.curve);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
