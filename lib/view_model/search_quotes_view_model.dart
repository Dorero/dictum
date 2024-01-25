import 'package:dictum/model/quote.dart';
import 'package:dictum/repository/quote/quote_repository.dart';
import 'package:dictum/repository/quote/quote_repository_rest.dart';
import 'package:flutter/cupertino.dart';

class SearchQuotesViewModel extends ChangeNotifier {
  final textEditingController = TextEditingController();
  final QuoteRepository quotesRepository = QuoteRepositoryRest();

  List<Quote> quotes = [];
  int offset =  0;
  final int limit = 50;

  Future<List<Quote>> loadQuoteByQuery(String query) async {
    return await quotesRepository.byLanguage(limit, offset, query: query);
  }

  Future<void> reloadQuotes(String query) async {
    quotes = await quotesRepository.byLanguage(limit, offset, query: query);
    notifyListeners();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}