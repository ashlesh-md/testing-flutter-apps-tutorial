import 'package:flutter/material.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import 'mock_new_service.dart' as mock;

final articlesFromService = [
  Article(title: 'Test 1', content: 'Test 1 content'),
  Article(title: 'Test 2', content: 'Test 2 content'),
  Article(title: 'Test 3', content: 'Test 3 content'),
];

void arrangeNewsServiceReturns3Articles(mock.MockNewsService mockNewsService) {
  when(() => mockNewsService.getArticles()).thenAnswer(
    (_) async => articlesFromService,
  );
}

void arrangeNewsServiceReturns3ArticlesAfter2SecondWait(
    mock.MockNewsService mockNewsService) {
  when(() => mockNewsService.getArticles()).thenAnswer(
    (_) async {
      await Future.delayed(const Duration(seconds: 2));
      return articlesFromService;
    },
  );
}

Widget createWidgetUnderTest(mock.MockNewsService mockNewsService) {
  return MaterialApp(
    title: 'News App',
    home: ChangeNotifierProvider(
      create: (_) => NewsChangeNotifier(mockNewsService),
      child: const NewsPage(),
    ),
  );
}
