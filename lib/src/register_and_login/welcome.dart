import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../common/widget_util.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class Welcome extends StatelessWidget {
  static const welcomeRoute = '/welcome';

  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isPlatformIos(context)) {
      return Stack(children: [
        CupertinoPageScaffold(
            child: SafeArea(
                child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    children: [
              CupertinoButton(
                  alignment: Alignment.topRight,
                  child: const Text('App Website'),
                  onPressed: () => _showAppWebsite(context)),
              const SizedBox(height: 84),
              Image(
                image: const AssetImage('assets/images/logo.png'),
                color: CupertinoTheme.of(context).textTheme.textStyle.color,
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 32),
              Text('Welcome!',
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context)
                      .textTheme
                      .navLargeTitleTextStyle),
              const SizedBox(height: 32),
              Text('Overview description here.',
                  textAlign: TextAlign.center,
                  style: CupertinoTheme.of(context).textTheme.textStyle),
              const SizedBox(height: 32),
              CupertinoButton.filled(
                  child: const Text('Get Started'), onPressed: () {})
            ]))),
        Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                decoration: BoxDecoration(
                    color: CupertinoTheme.of(context).barBackgroundColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: CupertinoButton(
                            child: const Text('New user?'),
                            onPressed: () => push(context, const SignUp()))),
                    Expanded(
                        child: CupertinoButton(
                            child: const Text('Sign in'),
                            onPressed: () => push(context, const SignIn())))
                  ],
                )))
      ]);
    }
    return Stack(children: [
      Scaffold(
          body: SafeArea(
              child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                  child: const Text('App Website'),
                  onPressed: () => _showAppWebsite(context))
            ]),
            const SizedBox(height: 84),
            Image(
              image: const AssetImage('assets/images/logo.png'),
              color: Theme.of(context).colorScheme.onSurface,
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 32),
            Text('Welcome!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 32),
            Text('Overview description here.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1),
            const SizedBox(height: 32),
            CupertinoButton.filled(
                child: const Text('Get Started'), onPressed: () {})
          ]))),
      Positioned(
          bottom: 0,
          width: MediaQuery.of(context).size.width,
          child: Container(
              padding: const EdgeInsets.all(8),
              decoration:
                  BoxDecoration(color: Theme.of(context).bottomAppBarColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      child: TextButton(
                          child: const Text('New user?'),
                          onPressed: () => push(context, const SignUp()))),
                  Expanded(
                      child: TextButton(
                          child: const Text('Sign in'),
                          onPressed: () => push(context, const SignIn())))
                ],
              )))
    ]);
  }

  void _showAppWebsite(BuildContext context) {
    showWebviewModalBottomSheet(context, 'https://flutter.dev');
  }
}
