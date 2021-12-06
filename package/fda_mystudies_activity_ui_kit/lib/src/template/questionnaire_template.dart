import 'dart:io';

import 'package:fda_mystudies_spec/study_datastore_service/activity_step.pb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../activity_builder_impl.dart';
import 'unimplemented_template.dart';

class QuestionnaireTemplate extends StatelessWidget {
  final ActivityStep step;
  final bool allowExit;
  final String title;
  final Map<String, Widget> widgetMap;
  final List<Widget> children;
  final dynamic selectedValue;

  const QuestionnaireTemplate(
      this.step, this.allowExit, this.title, this.widgetMap, this.children,
      {this.selectedValue, Key? key})
      : super(key: key);

  Widget _findNextScreen() {
    if (step.destinations.isEmpty) {
      return widgetMap[''] ??
          UnimplementedTemplate(step.destinations.first.destination);
    } else if (step.destinations.length == 1) {
      return widgetMap[step.destinations.first.destination] ??
          UnimplementedTemplate(step.destinations.first.destination);
    }
    // TODO(cg2092): Implement branching
    return widgetMap[step.destinations.first.destination] ??
        UnimplementedTemplate(step.destinations.first.destination);
  }

  void _navigateToNextScreen(BuildContext context) {
    if (Platform.isIOS) {
      Navigator.of(context).push(CupertinoPageRoute<void>(
          builder: (BuildContext context) => _findNextScreen()));
    } else if (Platform.isAndroid) {
      Navigator.of(context).push<void>(MaterialPageRoute<void>(
          builder: (BuildContext context) => _findNextScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var stepTitle = step.title;
    var subTitle = step.text;
    if (Platform.isIOS) {
      var titleStyle =
          CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle;
      var subTitleStyle = CupertinoTheme.of(context).textTheme.textStyle;
      return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(children: [
            CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                    middle: Text(title,
                        style:
                            const TextStyle(color: CupertinoColors.systemGrey)),
                    trailing: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (ActivityBuilderImpl.exitRoute.isNotEmpty) {
                            Navigator.of(context).popUntil(ModalRoute.withName(
                                ActivityBuilderImpl.exitRoute));
                          }
                        },
                        child: allowExit
                            ? const Icon(Icons.exit_to_app,
                                color: CupertinoColors.destructiveRed)
                            : const SizedBox(width: 0))),
                child: SafeArea(
                  bottom: false,
                  maintainBottomViewPadding: true,
                  child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                            Text(stepTitle, style: titleStyle),
                            SizedBox(height: subTitle.isEmpty ? 0 : 12),
                            Text(subTitle, style: subTitleStyle),
                            SizedBox(height: subTitle.isEmpty ? 12 : 36)
                          ] +
                          children +
                          [
                            // This sized box is to add padding to the bottom of
                            // the scaffold view to allow it to scroll over the
                            // view that holds the NEXT and SKIP buttons i.e. BOTTOM_VIEW.
                            // We are using bottom viewInset to detect if keyboard is
                            // showing. If keyboard is showing remove the extra padding
                            // meant for scrolling over the BOTTOM_VIEW.
                            //
                            // 20 - Default padding so that widgets from this component
                            //      doesn't stick to the BOTTOM_VIEW.
                            // 142 + 40 x textScaleFactor - This Padding is to match the
                            //      height of the BOTTOM_VIEW. Hacky solution, but it works
                            //      at all textScaleFactors.
                            SizedBox(
                                height: 20 +
                                    (MediaQuery.of(context).viewInsets.bottom ==
                                            0
                                        ? 142 +
                                            40 *
                                                MediaQuery.of(context)
                                                    .textScaleFactor
                                        : 0))
                          ]),
                )),
            Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                    decoration: BoxDecoration(
                        color: CupertinoTheme.of(context).barBackgroundColor),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CupertinoButton.filled(
                                  child: const Text('NEXT',
                                      style: TextStyle(
                                          color: CupertinoColors.white)),
                                  onPressed: selectedValue == null
                                      ? null
                                      : () => _navigateToNextScreen(context)),
                              const SizedBox(height: 20),
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: CupertinoColors.activeBlue),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0))),
                                  child: CupertinoButton(
                                      child: const Text('SKIP',
                                          style: TextStyle(
                                              color:
                                                  CupertinoColors.activeBlue)),
                                      onPressed: () =>
                                          _navigateToNextScreen(context)))
                            ]))))
          ]));
    }
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
                title: Text(title),
                actions: allowExit
                    ? [
                        TextButton(
                            onPressed: () {
                              if (ActivityBuilderImpl.exitRoute.isNotEmpty) {
                                Navigator.of(context).popUntil(
                                    ModalRoute.withName(
                                        ActivityBuilderImpl.exitRoute));
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              primary: Colors.red,
                            ),
                            child: const Icon(Icons.exit_to_app))
                      ]
                    : [],
                backgroundColor: Theme.of(context).colorScheme.surface),
            body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                      Text(stepTitle,
                          style: Theme.of(context).textTheme.headline4),
                      SizedBox(height: subTitle.isEmpty ? 0 : 12),
                      Text(subTitle,
                          style: Theme.of(context).textTheme.headline6),
                      const SizedBox(height: 24)
                    ] +
                    children),
            bottomNavigationBar: BottomAppBar(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                              onPressed: () => _navigateToNextScreen(context),
                              child: const Text('SKIP'),
                              style: Theme.of(context).textButtonTheme.style),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: selectedValue == null
                                ? null
                                : () => _navigateToNextScreen(context),
                            child: const Text('NEXT'),
                          )
                        ])))));
  }
}
