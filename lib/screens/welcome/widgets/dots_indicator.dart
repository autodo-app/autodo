import 'dart:math';
import 'package:flutter/material.dart';

class DotsIndicator extends AnimatedWidget {
  static const double _kDotSize = 5.0;
  static const double _kMaxZoom = 1.75;
  static const double _kDotSpacing = 20.0;

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  // The increase in the size of the selected dot
  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  /// A list of keys corresponding to each of the dots in the indicator.
  final List<Key> keys;

  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color = Colors.white,
    this.keys,
  }) : super(listenable: controller);

  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(itemCount, _buildDot),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    final double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    final double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return Container(
      key: (keys != null) ? keys[index] : null,
      width: _kDotSpacing,
      child: Material(
        color: color,
        type: MaterialType.circle,
        child: Container(
          width: _kDotSize * zoom,
          height: _kDotSize * zoom,
          child: InkWell(
            onTap: () => onPageSelected(index),
          ),
        ),
      ),
    );
  }
}
