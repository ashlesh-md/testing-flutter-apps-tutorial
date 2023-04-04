import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article_page.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_page.dart';
import 'package:provider/provider.dart';

import '../test/common/mock_new_service.dart' as mock;
import '../test/common/test_utils.dart';

void main() {
  late mock.MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = mock.MockNewsService();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets(
    """Tapping on the first article excerpt opens the article page
    where the full article content is displayed""",
    (WidgetTester tester) async {
      arrangeNewsServiceReturns3Articles(mockNewsService);

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump();

      await tester.tap(find.text('Test 1 content'));

      await tester.pumpAndSettle();

      expect(find.byType(NewsPage), findsNothing);
      expect(find.byType(ArticlePage), findsOneWidget);

      expect(find.text('Test 1'), findsOneWidget);
      expect(find.text('Test 1 content'), findsOneWidget);
    },
  );
}
