import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

class SimpleBarChart extends StatelessWidget {
  final List<Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new BarChart(
      seriesList,
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class DrivingDistanceHistory extends StatelessWidget {
  final data;
  DrivingDistanceHistory(this.data);

  @override 
  Widget build(BuildContext context) => Column( 
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Padding( 
        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      ),
      Text(
        'Driving Distance History',
        style: Theme.of(context).primaryTextTheme.subtitle
      ),
      Container(
        height: 300,
        padding: EdgeInsets.all(15), 
        child: SimpleBarChart.withSampleData(),
      )
    ]
  );
}