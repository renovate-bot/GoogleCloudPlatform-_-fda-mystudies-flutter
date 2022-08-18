import 'package:fda_mystudies_activity_ui_kit/fda_mystudies_activity_ui_kit.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart'
    as http_client;
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:fda_mystudies_http_client/mock_scenario_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../common/future_loading_page.dart';
import '../../common/widget_util.dart';

class DemoConfigScenariosView extends StatefulWidget {
  final String serviceName;
  final String methodName;
  final String? selectedScenario;
  const DemoConfigScenariosView(this.serviceName, this.methodName,
      {this.selectedScenario, Key? key})
      : super(key: key);

  @override
  _DemoConfigScenariosViewState createState() =>
      _DemoConfigScenariosViewState();
}

class _DemoConfigScenariosViewState extends State<DemoConfigScenariosView> {
  String? selectedScenario;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedScenario = widget.selectedScenario ?? 'default';
    });
  }

  @override
  Widget build(BuildContext context) {
    final MockScenarioService mockScenarioService =
        http_client.getIt<MockScenarioService>();
    return FutureLoadingPage.build(context,
        scaffoldTitle: widget.methodName,
        future: mockScenarioService.listScenarios(
            widget.serviceName, widget.methodName),
        builder: (context, snapshot) {
      var scenarios = (snapshot.data ?? []) as List<Scenario>;
      if (isPlatformIos(context)) {
        return CupertinoScrollbar(
            child: ListView.builder(
                itemCount: scenarios.length,
                itemBuilder: (context, index) {
                  var curScenario = scenarios[index];
                  return CupertinoRadioListTile(
                      curScenario.title,
                      '(${curScenario.response.statusCode}) ${curScenario.description}',
                      curScenario.scenarioCode,
                      curScenario.scenarioCode == selectedScenario,
                      true,
                      onChanged: (value) =>
                          _selectScenario(curScenario.scenarioCode));
                }));
      }
      return Scrollbar(
          child: ListView.builder(
              itemCount: scenarios.length,
              itemBuilder: (context, index) {
                var curScenario = scenarios[index];
                return RadioListTile(
                  title: Text(curScenario.title),
                  subtitle: Text(
                      '(${curScenario.response.statusCode}) ${curScenario.description}'),
                  value: curScenario.scenarioCode,
                  selected: curScenario.scenarioCode == selectedScenario,
                  onChanged: (value) =>
                      _selectScenario(curScenario.scenarioCode),
                  groupValue: selectedScenario,
                );
              }));
    });
  }

  void _selectScenario(String scenario) {
    demoConfig.serviceMethodScenarioMap[
        '${widget.serviceName}.${widget.methodName}'] = scenario;
    setState(() {
      selectedScenario = scenario;
    });
  }
}