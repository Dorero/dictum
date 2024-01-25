import 'package:dictum/component/main_app_bar.dart';
import 'package:dictum/component/quote_card_without_author.dart';
import 'package:dictum/model/quote.dart';
import 'package:dictum/view_model/author_detail_view_model.dart';
import 'package:dictum/view_model/bookmark_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthorDetailScreen extends StatelessWidget {
  const AuthorDetailScreen({super.key, required this.id, required this.name});

  final String id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(text:name,),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthorDetailViewModel(),
          ),
          ChangeNotifierProvider(
            create: (_) => BookmarkViewModel(),
          ),
        ],
        child: LoadQuotes(
          authorId: id,
        ),
      ),
    );
  }
}

class LoadQuotes extends StatefulWidget {
  const LoadQuotes({super.key, required this.authorId});

  final String authorId;

  @override
  State<LoadQuotes> createState() => _LoadQuotesState();
}

class _LoadQuotesState extends State<LoadQuotes> {
  @override
  Widget build(BuildContext context) {
    final model = context.read<AuthorDetailViewModel>();
    model.authorId = widget.authorId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Center(
        child: FutureBuilder(
          future: model.initialLoadQuotes(),
          builder: (BuildContext context, AsyncSnapshot<List<Quote>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.something_wrong),
                  const SizedBox(height: 10),
                  IconButton(
                    onPressed: () => setState(() {}),
                    icon: const Icon(Icons.lock_reset),
                  ),
                ],
              );
            } else if (snapshot.hasData) {
              model.quotes = snapshot.data!;

              return const ListQuotes();
            } else {
              return Text(AppLocalizations.of(context)!.no_quotes);
            }
          },
        ),
      ),
    );
  }
}

class ListQuotes extends StatelessWidget {
  const ListQuotes({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AuthorDetailViewModel>();
    final quotes = model.quotes;

    return ListView.builder(
      controller: model.scrollController,
      itemCount: quotes.length,
      itemBuilder: (context, index) {
        return QuoteCardWithoutAuthor(quote: quotes[index]);
      },
    );
  }
}
