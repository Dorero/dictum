import 'dart:async';

import 'package:dictum/model/author.dart';
import 'package:dictum/repository/author/author_repository.dart';
import 'package:dictum/repository/author/author_repository_rest.dart';
import 'package:flutter/material.dart';

class AuthorsViewModel extends ChangeNotifier {
  final AuthorRepository authorRepository = AuthorRepositoryRest();
  final scrollController = ScrollController();
  final textEditingController = TextEditingController();

  List<Author> authors = [];
  int offset = 0;
  final int limit = 50;

  Future<List<Author>> initialLoadAuthors() {
    setupScrollControllerHandler();
    return authorRepository.byLanguage(limit, offset);
  }

  void setupScrollControllerHandler() {
    scrollController.addListener(scrollControllerHandler);
  }

  Future<void> reloadAuthors(String query) async {
    authors = await authorRepository.byLanguage(limit, offset, query: query);
    notifyListeners();
  }

  void scrollControllerHandler() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      offset += limit;

      authorRepository.byLanguage(limit, offset).then((response) {
        authors.addAll(response);
        notifyListeners();
      });
    }
  }


  @override
  void dispose() {
    scrollController.removeListener(scrollControllerHandler);
    scrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }
}
