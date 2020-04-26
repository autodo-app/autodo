import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/models.dart';
import '../../../units/units.dart';
import '../../../widgets/widgets.dart';
import 'delete_button.dart';
import 'refueling_edit_button.dart';

class TimelinePainter extends CustomPainter {
  const TimelinePainter({this.context, this.firstElement = false, this.lastElement = false});

  final bool firstElement;
  final bool lastElement;
  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    final lineStroke = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    if (firstElement) {
      final offsetCenter = size.center(Offset(0.0, -4.0));
      final offsetBottom = size.bottomCenter(Offset(0.0, 0.0));
      final renderOffset = Offset(offsetBottom.dx, offsetBottom.dy);
      canvas.drawLine(
          offsetCenter,
          renderOffset,
          lineStroke);
    } else if (lastElement) {
      final offsetTopCenter = size.topCenter(Offset(0.0, 0.0));
      final offsetCenter = size.center(Offset(0.0, -4.0));
      final renderOffset = Offset(offsetCenter.dx, offsetCenter.dy);
      canvas.drawLine(
          offsetTopCenter,
          renderOffset,
          lineStroke);
    } else {
      final offsetTopCenter = size.topCenter(Offset(0.0, 0.0));
      final offsetBottom = size.bottomCenter(Offset(0.0, 0.0));
      canvas.drawLine(
          offsetTopCenter,
          offsetBottom,
          lineStroke);
    }

    if (firstElement) {
      final circleFill = Paint()
          ..color = Theme.of(context).primaryColor
          ..style = PaintingStyle.fill;

      canvas.drawCircle(size.center(Offset(0.0, -8.0)), 6.0, circleFill);

      final circleOutline = Paint()
          ..color = Theme.of(context).primaryColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

      canvas.drawCircle(size.center(Offset(0.0, -8.0)), 10.0, circleOutline);
    } else {
      final circleFill = Paint()
          ..color = Colors.grey
          ..style = PaintingStyle.fill;

      canvas.drawCircle(size.center(Offset(0.0, -8.0)), 6.0, circleFill);
    }
  }

  @override
  bool shouldRepaint(TimelinePainter oldPainter) => false;
}

class _Content extends StatelessWidget {
  const _Content(this.refueling, this.car, this.onDelete);

  final Refueling refueling;
  final Car car;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat.yMd().format(refueling.date),
                style: Theme.of(context).primaryTextTheme.headline5),
              Text(
                '${Distance.of(context).format(refueling.mileage)} ${Distance.of(context).unitString(context, short: true)}',
                style: Theme.of(context).primaryTextTheme.subtitle2.copyWith(color: Colors.grey))
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  Currency.of(context).format(refueling.cost),
                  style: Theme.of(context).primaryTextTheme.subtitle2,),
                Text('  |  ', style: Theme.of(context).primaryTextTheme.bodyText2,),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: Volume.of(context).format(refueling.amount),
                        style: Theme.of(context).primaryTextTheme.subtitle2,
                        children: [TextSpan(text: ' ')],
                      ),
                      TextSpan(
                        text: Volume.of(context).unitString(context, short: true),
                        style: Theme.of(context).primaryTextTheme.bodyText2,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CarTag(car: car),
              Row(
                children: [
                  RefuelingEditButton(refueling: refueling),
                  DeleteButton(onDelete: onDelete),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class RefuelingElement extends StatelessWidget {
  const RefuelingElement({
      Key key,
      this.first,
      this.last,
      @required this.refueling,
      @required this.car}) : super(key: key);

  final bool first;
  final bool last;
  final Refueling refueling;
  final Car car;

  @override
  Widget build(BuildContext context) => Container(
    height: 110,
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 40,
          child: CustomPaint(
            painter: TimelinePainter(firstElement: first, lastElement: last, context: context),
          ),
        ),
        _Content(refueling, car, () {}),
      ],
    ),
  );
}