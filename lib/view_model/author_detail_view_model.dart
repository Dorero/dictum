import 'dart:async';

import 'package:dictum/model/quote.dart';
import 'package:dictum/repository/quote/quote_repository_rest.dart';
import 'package:dictum/repository/quote/quote_repository.dart';
import 'package:flutter/material.dart';

class AuthorDetailViewModel extends ChangeNotifier {
  final QuoteRepository quotesRepository = QuoteRepositoryRest();
  final scrollController = ScrollController();

  List<Quote> quotes = [];
  int offset = 0;
  final int limit = 20;
  String authorId = "";

  Future<List<Quote>> initialLoadQuotes() {
    setupScrollControllerHandler();
    return quotesRepository.byAuthor(authorId, limit, offset);
  }

  void setupScrollControllerHandler() {
    scrollController.addListener(scrollControllerHandler);
  }

  void scrollControllerHandler() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      offset += limit;

      quotesRepository.byAuthor(authorId, limit, offset).then((response) {
        quotes.addAll(response);
        notifyListeners();
      });
    }
  }


  @override
  void dispose() {
    scrollController.removeListener(scrollControllerHandler);
    scrollController.dispose();
    super.dispose();
  }
}
