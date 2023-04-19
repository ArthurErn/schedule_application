import 'package:Equilibre/domain/chart.dart';
import 'package:Equilibre/infra/chart_service_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartsView extends StatefulWidget {
  const ChartsView({super.key});

  @override
  State<ChartsView> createState() => _ChartsViewState();
}

class _ChartsViewState extends State<ChartsView> {
  List<ChartEntity> _chartData = [];

  @override
  void initState() {
    getChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 330,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SfCircularChart(
                title: ChartTitle(
                    text: "Serviços realizados",
                    textStyle: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap,
                    textStyle: const TextStyle(fontSize: 16, color: Colors.white)),
                series: <CircularSeries>[
                  PieSeries<ChartEntity, String>(
                      dataSource: _chartData,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                      xValueMapper: (ChartEntity data, _) => data.mes,
                      yValueMapper: (ChartEntity data, _) => data.totalAgendamentos)
                ],
              ),
            )),
        SizedBox(
            height: 330,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SfCartesianChart(
                title: ChartTitle(
                    text: "Valores recebidos",
                    textStyle: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: Colors.white)),
                legend: Legend(
                    isVisible: false,
                    textStyle: const TextStyle(fontSize: 16, color: Colors.white)),
                series: <ChartSeries>[
                  BarSeries<ChartEntity, String>(
                    color: const Color.fromARGB(255, 255, 184, 125),
                      dataSource: _chartData,
                      dataLabelSettings: const DataLabelSettings(isVisible: true, textStyle: TextStyle(fontSize: 14, color: Colors.white)),
                      xValueMapper: (ChartEntity data, _) => data.mes,
                      yValueMapper: (ChartEntity data, _) => data.valorTotal),
                ],
                primaryXAxis: CategoryAxis(labelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),),
                primaryYAxis: NumericAxis(
                  isVisible: false,
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    numberFormat:
                        NumberFormat.simpleCurrency(decimalDigits: 0, locale: 'pt-br'),
                    labelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),),
              ),
            ))
      ],
    );
  }

  translateMonth(String text){
    switch (text) {
      case '01':
        return 'Janeiro';
      case '02':
        return 'Fevereiro';
      case '03':
        return 'Março';
      case '04':
        return 'Abril';
      case '05':
        return 'Maio';
      case '06':
        return 'Junho';
      case '07':
        return 'Julho';
      case '08':
        return 'Agosto';
      case '09':
        return 'Setembro';
      case '10':
        return 'Outubro';
      case '11':
        return 'Novembro';
      case '12':
        return 'Dezembro';
      default:
        return '';
    }
  }

  Future<List<ChartEntity>> getChartData() async{
    await ChartServiceResponse().ping().then((value){
      _chartData = value.reversed.toList();
      for(int i =0; i < _chartData.length;i++){
        String month = translateMonth(_chartData[i].mes.substring(5,7));
        setState(() {
          _chartData[i].mes = "$month/${_chartData[i].mes.substring(0,4)}";
          
        });
      }
    });
    return _chartData;
  }
}
