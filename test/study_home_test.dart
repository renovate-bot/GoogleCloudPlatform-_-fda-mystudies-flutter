import 'package:fda_mystudies/src/study_home.dart';
import 'package:fda_mystudies_http_client/fda_mystudies_http_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_util.dart';

void main() {
  setUpAll(() {
    configureDependencies(DemoConfig());
  });

  testWidgets('Show study-home page', (WidgetTester tester) async {
    await tester.pumpWidget(TestUtil.wrapInMaterialApp(const StudyHome()));
    var tabs = [activitiesTitle, dashboardTitle, resourcesTitle];
    expect(
        TestUtil.findBottomBarItemWithLabel(activitiesTitle), findsOneWidget);
    expect(TestUtil.findBottomBarItemWithLabel(dashboardTitle), findsOneWidget);
    expect(TestUtil.findBottomBarItemWithLabel(resourcesTitle), findsOneWidget);
    await TestUtil.testSelectedTabViaScaffoldTitle(
        tester, tabs, activitiesTitle);
    await TestUtil.testSelectedTabViaScaffoldTitle(
        tester, tabs, dashboardTitle);
    await TestUtil.testSelectedTabViaScaffoldTitle(
        tester, tabs, resourcesTitle);
  },
      variant: const TargetPlatformVariant(
          <TargetPlatform>{TargetPlatform.android}));
}
