import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:autodo/util.dart';

class FuelMileagePoint {
  double date, mpg;

  FuelMileagePoint({this.date, this.mpg});
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
      FuelMileagePoint(date: 0, mpg: 5),
      FuelMileagePoint(date: 10, mpg: 25),
      FuelMileagePoint(date: 12, mpg: 75),
      FuelMileagePoint(date: 13, mpg: 225),
      FuelMileagePoint(date: 16, mpg: 50),
      FuelMileagePoint(date: 24, mpg: 75),
      FuelMileagePoint(date: 25, mpg: 100),
      FuelMileagePoint(date: 34, mpg: 150),
      FuelMileagePoint(date: 37, mpg: 10),
      FuelMileagePoint(date: 45, mpg: 300),
      FuelMileagePoint(date: 52, mpg: 15),
      FuelMileagePoint(date: 56, mpg: 200),
    ];

    final List<FuelMileagePoint> emaData = [];
    for (var point in data) {
      if (emaData.length == 0) {
        emaData.add(point);
        continue;
      }
      FuelMileagePoint newPoint = FuelMileagePoint();
      FuelMileagePoint interpolate = FuelMileagePoint();
      FuelMileagePoint last = emaData[emaData.length - 1];
      newPoint.date = point.date;
      newPoint.mpg = last.mpg * 0.8 + point.mpg * 0.2;
      interpolate.date = (point.date + last.date) / 2;
      interpolate.mpg = last.mpg * 0.8 + newPoint.mpg * 0.2;
      emaData.add(interpolate);
      emaData.add(newPoint);
    }

    final double maxMeasure = 300, minMeasure = 5;
    print(rgb2Hsl(255, 0, 0));
    print(hslToRgb(0.3333, 1.0, 0.5));

    return [
      Series<FuelMileagePoint, double>(
        id: 'Fuel Mileage vs Time',
        // Providing a color function is optional.
        colorFn: (FuelMileagePoint point, _) {
          // Shade the point from red to green depending on its position relative to min/max
          final scale = scaleToUnit(point.mpg, minMeasure, maxMeasure);
          final hue = scale * 0.3333;
          final rgb = hslToRgb(hue, 1.0, 0.5);
          return Color(r: rgb['r'], g: rgb['g'], b: rgb['b']);
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
          colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
          domainFn: (FuelMileagePoint point, _) => point.date,
          measureFn: (FuelMileagePoint point, _) => point.mpg,
          data: emaData
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
