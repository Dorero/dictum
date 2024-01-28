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
  final scrollController = ScrollController();

  List<Quote> quotes = [];
  int offset = LocaleStorage.prefs.getInt("quotesOffset") ?? 0;
  final int limit = 20;


  void setupScrollControllerHandler() {
    scrollController.addListener(_scrollControllerHandler);
  }

  void _scrollControllerHandler() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {

      offset += limit;
      LocaleStorage.prefs.setInt("quotesOffset", offset);
      quotesRepository.byLanguage(limit, offset).then((response) {
        quotes.addAll(response);
        notifyListeners();
      });
    }
  }


  Future<(List<Quote>, Map<String, int>)> initialLoadQuotes() async {
    setupScrollControllerHandler();
    return await (
      quotesRepository.byLanguage(limit, offset),
      statsRepository.byLanguage()
    ).wait;
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollControllerHandler);
    scrollController.dispose();
    super.dispose();
  }
}
