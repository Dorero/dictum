import 'package:dictum/api/local_storage.dart';
import 'package:dictum/api/rest.dart';
import 'package:dictum/model/quote.dart';
import 'package:dictum/repository/quote/quote_repository.dart';

class QuoteRepositoryRest implements QuoteRepository {
  final Rest restApi = Rest();
  final languageCode = LocaleStorage.prefs.getString("language") ?? "ru";

  @override
  Future<List<Quote>> byAuthor(String authorId, int limit, int offset, {String query = ''}) async {
    final data = await restApi.get("authors/$languageCode/$authorId/quotes?limit=$limit&offset=$offset&query=$query");

    return data.map<Quote>((json) => Quote.fromJson(json)).toList();
  }

  @override
  Future<List<Quote>> byLanguage(int limit, int offset, {String query = ''}) async {
    final data = await restApi.get("quotes/$languageCode?limit=$limit&offset=$offset&query=$query");

    return data.map<Quote>((json) => Quote.fromJson(json)).toList();
  }

  @override
  Future<Quote> find(String id) async {
    // TODO: implement find
    throw UnimplementedError();
  }

  @override
  Future<Quote> random() async{
    return Quote.fromJson(await restApi.get("quotes/$languageCode/random"));
  }
}
