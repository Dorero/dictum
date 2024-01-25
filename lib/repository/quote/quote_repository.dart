import 'package:dictum/model/quote.dart';

abstract interface class QuoteRepository {
  Future<List<Quote>> byLanguage(int limit, int offset, {String query = ''});

  Future<List<Quote>> byAuthor(String authorId, int limit, int offset, {String query = ''});

  Future<Quote> find(String id);
  Future<Quote> random();
}
