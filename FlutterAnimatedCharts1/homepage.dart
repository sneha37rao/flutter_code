import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  final Widget child;

  HomePage({Key key, this.child}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<charts.Series<Pollution, String>> _seriesData;
  List<charts.Series<Electricity, String>> _seriesPieData;
  List<charts.Series<Vehicles, String>> _seriesLineData;

  _generateData() {
    var data1 = [
      new Pollution('June',3),
      new Pollution('July',1),
      new Pollution('August',5),
    ];
    var data2 = [
      new Pollution('June', 1),
      new Pollution('July',2),
      new Pollution('August',4),
    ];

    var data3 = [
      new Pollution('June', 5),
      new Pollution('July',3),
      new Pollution('August',3),
    ];
    var piedata = [
      new Electricity('Renewable Onsite', 8),
      new Electricity('Renewable Wheeled', 10),
      new Electricity('Purchased Grid', 15),
    ];

    var linedata = [
      new Vehicles('June', 56),
      new Vehicles('July', 55),
      new Vehicles('August', 60),
      new Vehicles('September', 61),
      new Vehicles('October', 70),
    ];
    var linedata1 = [
      new Vehicles('June', 46),
      new Vehicles('July', 45),
      new Vehicles('August', 50),
      new Vehicles('September', 51),
      new Vehicles('October', 60),
    ];

    var linedata2 = [
      new Vehicles('June', 24),
      new Vehicles('July', 25),
      new Vehicles('August', 40),
      new Vehicles('September', 45),
      new Vehicles('October', 60),
    ];

    _seriesData.add(
      charts.Series(
        id:'LPG-Cooking',
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        data: data1,
      ),
    );

    _seriesData.add(
      charts.Series(
        id:'Diesel',
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        data: data2,
      ),
    );

    _seriesData.add(
      charts.Series(
        id:'LPG-lab',
        domainFn: (Pollution pollution, _) => pollution.place,
        measureFn: (Pollution pollution, _) => pollution.quantity,
        data: data3,
      ),
    );

    _seriesPieData.add(
      charts.Series(
        id:'Pollution',
      domainFn: (Electricity e, _) => e.emission,
      measureFn: (Electricity e, _) => e.emission_value,
      data: piedata,
      // Set a label accessor to control the text of the arc label.
      labelAccessorFn: (Electricity e, _) => '${e.emission}: ${e.emission_value}',
      ),
    );

    _seriesLineData.add(
      charts.Series(
        id: 'Two wheeler',
        data: linedata,
        domainFn: (Vehicles v, _) => v.month,
        measureFn: (Vehicles v, _) => v.emissions,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff0277BD)),
        id: 'Three wheeler',
        data: linedata1,
        domainFn: (Vehicles v, _) => v.month,
        measureFn: (Vehicles v, _) => v.emissions,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff01579D)),
        id: 'Four wheeler',
        data: linedata2,
        domainFn: (Vehicles v, _) => v.month,
        measureFn: (Vehicles v, _) => v.emissions,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesData = List<charts.Series<Pollution, String>>();
    _seriesPieData = List<charts.Series<Electricity, String>>();
    _seriesLineData = List<charts.Series<Vehicles, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff1976d2),
            //backgroundColor: Color(0xff308e1c),
            bottom: TabBar(
              indicatorColor: Color(0xff9962D0),
              tabs: [
                Tab(
                  icon: Icon(FontAwesomeIcons.solidChartBar),
                ),
                Tab(icon: Icon(FontAwesomeIcons.chartPie)),
                Tab(icon: Icon(FontAwesomeIcons.chartLine)),
              ],
            ),
            title: Text('Flutter Charts'),
          ),
          body: TabBarView(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                            'Direct Emissions by lpg-cooking, lpg-lab  and diesel (in kg)',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                        Expanded(
                          child: charts.BarChart(
                            _seriesData,
                            animate: true,
                            barGroupingType: charts.BarGroupingType.stacked,
                            behaviors: [new charts.SeriesLegend()],
                            animationDuration: Duration(seconds: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                              'CO2 produced by electricity',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                              SizedBox(height: 10.0),
                          Expanded(
                            child: charts.PieChart(_seriesPieData,
                                animate: true,
                              animationDuration: Duration(seconds: 1),
                                defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                      labelPosition: charts.ArcLabelPosition.inside)
                                ],
                                ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child:Column(
                    children: <Widget>[
                      Text(
                        'CO2 in kg produced by vehicles',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                      Expanded(
                        child: charts.LineChart(
                            _seriesLineData,
                            defaultRenderer: new charts.LineRendererConfig(
                                includeArea: true, stacked: true),
                            animate: true,
                            animationDuration: Duration(seconds: 1),
                            behaviors: [
                              new charts.SeriesLegend(),
                              new charts.ChartTitle('Pollution',
                                  behaviorPosition: charts.BehaviorPosition.bottom,
                                  titleOutsideJustification:charts.OutsideJustification.middleDrawArea),
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      ],
    ),
          ),
        ),
    );
  }
}

class Pollution {
  String place;
  int quantity;

  Pollution(this.place, this.quantity);
}

class Vehicles {
  String month;
  double emissions;

  Vehicles(this.month, this.emissions);
}

class Electricity{
    String emission;
    double emission_value;
    Electricity(this.emission,this.emission_value);
}