import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:mocktail/mocktail.dart';

import 'common/mock_new_service.dart' as mock;
import 'common/test_utils.dart';

void main() {
  late NewsChangeNotifier sut;
  late mock.MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = mock.MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test(
    "initial values are correct",
    () {
      expect(sut.articles, []);
      expect(sut.isLoading, false);
    },
  );

  group('getArticles', () {
    test(
      "gets articles using the NewsService",
      () async {
        arrangeNewsServiceReturns3Articles(mockNewsService);
        await sut.getArticles();
        verify(() => mockNewsService.getArticles()).called(1);
      },
    );

    test(
      """indicates loading of data,
      sets articles to the ones from the service,
      indicates that data is not being loaded anymore""",
      () async {
        arrangeNewsServiceReturns3Articles(mockNewsService);
        final future = sut.getArticles();
        expect(sut.isLoading, true);
        await future;
        expect(sut.articles, articlesFromService);
        expect(sut.isLoading, false);
      },
    );
  });
}
