import 'package:dictum/api/local_storage.dart';
import 'package:flutter/material.dart';

class BookmarkViewModel extends ChangeNotifier {
  List<String> _quotes = [];

  List<String> get quotes {
    return _quotes.isEmpty ? _loadQuotes() : _quotes;
  }

  void handleBookmark(String quoteString) async {
    if (_quotes.contains(quoteString)) {
      _deleteQuote(quoteString);
    } else {
      _saveQuote(quoteString);
    }

    notifyListeners();
  }

  Future<bool> _saveQuote(String quoteString) async {
    final tempQuotes = _quotes;
    tempQuotes.add(quoteString);
    return _saveQuotes(tempQuotes);
  }

  Future<bool> _saveQuotes(List<String> quotes) async {
    bool result = await LocaleStorage.prefs.setStringList('quotes', quotes);
    if (result) _quotes = quotes;
    return result;
  }

  List<String> _loadQuotes() {
    return LocaleStorage.prefs.getStringList("quotes") ?? [];
  }

  Future<bool> _deleteQuote(String quoteString) async {
    final tempQuotes = _quotes;
    tempQuotes.removeWhere((oldQuote) => oldQuote == quoteString);
    return _saveQuotes(tempQuotes);
  }
}
