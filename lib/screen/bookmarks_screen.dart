import 'package:dictum/component/main_app_bar.dart';
import 'package:dictum/component/quote_card.dart';
import 'package:dictum/model/quote.dart';
import 'package:dictum/view_model/bookmark_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        text: AppLocalizations.of(context)!.bookmarks,
      ),
      body: ChangeNotifierProvider(
          create: (context) => BookmarkViewModel(),
          child: const ListBookmarks()),
    );
  }
}

class ListBookmarks extends StatelessWidget {
  const ListBookmarks({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<BookmarkViewModel>();
    final quotes = model.quotes;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          return QuoteCard(
            quote: Quote.fromString(quotes[index]),
          );
        },
      ),
    );
  }
}
