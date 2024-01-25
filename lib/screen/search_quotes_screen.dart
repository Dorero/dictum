import 'package:dictum/component/main_app_bar.dart';
import 'package:dictum/component/quote_card.dart';
import 'package:dictum/model/quote.dart';
import 'package:dictum/view_model/bookmark_view_model.dart';
import 'package:dictum/view_model/search_quotes_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SearchQuotesScreen extends StatelessWidget {
  const SearchQuotesScreen({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppBar(text: AppLocalizations.of(context)!.quotes,),
        body: MultiProvider(
        providers: [
        ChangeNotifierProvider<SearchQuotesViewModel>(
        create: (_)
    =>
        SearchQuotesViewModel()
    ,
    ),
    ChangeNotifierProvider<BookmarkViewModel>(
    create: (_) => BookmarkViewModel(),
    ),
    ],
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
    child: Consumer<SearchQuotesViewModel>(
    builder: (context, model, child) {
    return FutureBuilder(
    future: model.loadQuoteByQuery(query),
    builder: (BuildContext context,
    AsyncSnapshot<List<Quote>> snapshot) {
    if (snapshot.hasError) {
    return const Center(
    child: Text("error"),
    );
    } else if (snapshot.hasData) {
    if (snapshot.data!.isEmpty) {
    return Center(
    child: Text(AppLocalizations.of(context)!.something_wrong),
    );
    }
    model.quotes = snapshot.data!;

    return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    TextField(
    decoration: InputDecoration(
    labelText: AppLocalizations.of(context)!.search_quotes,
    suffixIcon: const Icon(Icons.search),
    border: OutlineInputBorder(
    borderSide: const BorderSide(
    width: 2.0,
    style: BorderStyle.solid,
    ),
    borderRadius: BorderRadius.circular(20.0),
    ),
    ),
    controller: model.textEditingController,
    onChanged: (query) {
    if(query.length > 3) {
    model.reloadQuotes(query);
    }
    },
    onSubmitted: (query) {
    model.reloadQuotes(query);
    },
    ),
    const SizedBox(
    height: 10,
    ),
    Expanded(
    child: ListView.builder(
    itemCount: model.quotes.length,
    itemBuilder: (context, index) {
    return QuoteCard(quote: model.quotes[index]);
    },
    ),
    )
    ],
    );
    } else {
    return const Center(child: CircularProgressIndicator());
    }
    },
    );
    },
    ),
    ),
    ),
    );
    }
}
