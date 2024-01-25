import 'package:dictum/api/local_storage.dart';
import 'package:dictum/api/rest.dart';
import 'package:dictum/model/author.dart';
import 'package:dictum/repository/author/author_repository.dart';

class AuthorRepositoryRest implements AuthorRepository {
  final Rest restApi = Rest();
  final languageCode = LocaleStorage.prefs.getString("language") ?? "ru";

  @override
  Future<List<Author>> byLanguage(int limit, int offset, {String query = ''}) async {
    final data = await restApi.get("authors/$languageCode?limit=$limit&offset=$offset&query=$query");

    return data.map<Author>((json) => Author.fromJson(json)).toList();
  }

  @override
  Future<Author> find(String language, String id) {
    // TODO: implement find
    throw UnimplementedError();
  }
  
}
