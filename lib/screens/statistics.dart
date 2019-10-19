import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

class FuelMileagePoint {
  final double date, mpg;

  FuelMileagePoint(this.date, this.mpg);
}

class FuelMileageChart extends StatelessWidget {
  final List<Series> seriesList;
  final bool animate;

  FuelMileageChart(this.seriesList, this.animate);

  @override 
  Widget build(BuildContext context) {
    final axisSpec = NumericAxisSpec(
      tickProviderSpec: BasicNumericTickProviderSpec(
        desiredTickCount: 6
      ),
      renderSpec: GridlineRendererSpec(
        lineStyle: LineStyleSpec( 
          color: Color(r: 0x99, g: 0x99, b: 0x99),
        ),
        labelOffsetFromAxisPx: 10,
        labelStyle: TextStyleSpec(
          fontSize: 12, 
          color: MaterialPalette.white,
        ),
      ),
    );

    return ScatterPlotChart(
      seriesList, 
      animate: animate,
      domainAxis: axisSpec,
      primaryMeasureAxis: axisSpec,
      // Custom renderer configuration for the line series.
      customSeriesRenderers: [
        LineRendererConfig(
          // ID used to link series to this renderer.
          customRendererId: 'customLine',
          // Configure the regression line to be painted above the points.
          //
          // By default, series drawn by the point renderer are painted on
          // top of those drawn by a line renderer.
          layoutPaintOrder: LayoutViewPaintOrder.point + 1,
          stacked: true,
        ),
      ],
    );
  }
}

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

class StatisticsScreen extends StatefulWidget {
  @override
  StatisticsScreenState createState() => StatisticsScreenState();
}

class StatisticsScreenState extends State<StatisticsScreen> {
  static List<Series<FuelMileagePoint, double>> _createSampleData() {
    final data = [
      FuelMileagePoint(0, 5),
      FuelMileagePoint(10, 25),
      FuelMileagePoint(12, 75),
      FuelMileagePoint(13, 225),
      FuelMileagePoint(16, 50),
      FuelMileagePoint(24, 75),
      FuelMileagePoint(25, 100),
      FuelMileagePoint(34, 150),
      FuelMileagePoint(37, 10),
      FuelMileagePoint(45, 300),
      FuelMileagePoint(52, 15),
      FuelMileagePoint(56, 200),
    ];

    final maxMeasure = 300;

    return [
      Series<FuelMileagePoint, double>(
        id: 'Fuel Mileage vs Time',
        // Providing a color function is optional.
        colorFn: (FuelMileagePoint point, _) {
          // Bucket the measure column value into 3 distinct colors.
          final bucket = point.mpg / maxMeasure;

          if (bucket < 1 / 3) {
            return MaterialPalette.blue.shadeDefault;
          } else if (bucket < 2 / 3) {
            return MaterialPalette.red.shadeDefault;
          } else {
            return MaterialPalette.green.shadeDefault;
          }
        },
        domainFn: (FuelMileagePoint point, _) => point.date,
        measureFn: (FuelMileagePoint point, _) => point.mpg,
        // Providing a radius function is optional.
        radiusPxFn: (FuelMileagePoint point, _) => 6.0, // all values have the same radius for now
        data: data,
      ),
      // Configure our custom line renderer for this series.
      Series<FuelMileagePoint, double>(
          id: 'Mobile',
          colorFn: (_, __) => MaterialPalette.purple.shadeDefault,
          domainFn: (FuelMileagePoint point, _) => point.date,
          measureFn: (FuelMileagePoint point, _) => point.mpg,
          data: data
      )..setAttribute(rendererIdKey, 'customLine'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding:
          false, // used to avoid overflow when keyboard is viewable
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Statistics'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 300,
            padding: EdgeInsets.all(15),  
            child: FuelMileageChart(_createSampleData(), false),
          ),
          Container(
            height: 400,
            child: SimpleBarChart.withSampleData(),
          )
        ],
      ),
    );
  }
}
