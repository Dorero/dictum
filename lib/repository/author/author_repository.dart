import 'package:dictum/model/author.dart';

abstract interface class AuthorRepository {
  Future<List<Author>> byLanguage(int limit, int offset, {String query = ''});
  Future<Author> find(String language, String id);
}