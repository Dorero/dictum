import 'dart:async';

import 'package:dictum/api/local_storage.dart';
import 'package:dictum/model/quote.dart';
import 'package:dictum/repository/quote/quote_repository_rest.dart';
import 'package:dictum/repository/quote/quote_repository.dart';
import 'package:dictum/repository/stats/stats_repository.dart';
import 'package:dictum/repository/stats/stats_repository_rest.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  final QuoteRepository quotesRepository = QuoteRepositoryRest();
  final StatsRepository statsRepository = StatsRepositoryRest();
  final pageController = PageController();


  List<Quote> quotes = [];
  int offset = LocaleStorage.prefs.getInt("quotesOffset") ?? 0;
  final int limit = 20;
  bool isPageChanged = LocaleStorage.prefs.getBool("isPageChanged") ?? false;

  void pageChanged(int index) {
    if (index == quotes.length - 1) {
      offset += limit;
      LocaleStorage.prefs.setInt("quotesOffset", offset);
      quotesRepository.byLanguage(limit, offset).then((response) {
        quotes.addAll(response);
        notifyListeners();
      });
    }

    if (!isPageChanged) {
      isPageChanged = true;
      LocaleStorage.prefs.setBool("isPageChanged", true);
      notifyListeners();
    }
  }

  Future<(List<Quote>, Quote, Map<String, int>)> initialLoadQuotes() async {
    final (quotes, quote, stats) = await (
      quotesRepository.byLanguage(limit, offset),
      quotesRepository.random(),
      statsRepository.byLanguage()
    ).wait;
    quotes.removeWhere((element) => element.id == quote.id);
    return (quotes, quote, stats);
  }


  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
