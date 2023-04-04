import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'common/mock_new_service.dart';
import 'common/test_utils.dart';

void main() {
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
  });

  testWidgets(
    "title is displayed",
    (WidgetTester tester) async {
      arrangeNewsServiceReturns3Articles(mockNewsService);
      await tester.pumpWidget(createWidgetUnderTest(mockNewsService));
      expect(find.text('News'), findsOneWidget);
    },
  );

  testWidgets(
    "loading indicator is displayed while waiting for articles",
    (WidgetTester tester) async {
      arrangeNewsServiceReturns3ArticlesAfter2SecondWait(mockNewsService);

      await tester.pumpWidget(createWidgetUnderTest(mockNewsService));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byKey(const Key('progress-indicator')), findsOneWidget);

      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    "articles are displayed",
    (WidgetTester tester) async {
      arrangeNewsServiceReturns3Articles(mockNewsService);

      await tester.pumpWidget(createWidgetUnderTest(mockNewsService));

      await tester.pump();

      for (final article in articlesFromService) {
        expect(find.text(article.title), findsOneWidget);
        expect(find.text(article.content), findsOneWidget);
      }
    },
  );
}
