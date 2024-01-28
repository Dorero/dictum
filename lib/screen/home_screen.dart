import 'package:dictum/component/main_app_bar.dart';
import 'package:dictum/component/quote_card.dart';
import 'package:dictum/model/quote.dart';
import 'package:dictum/view_model/bookmark_view_model.dart';
import 'package:dictum/view_model/home_view_model.dart';
import 'package:dictum/view_model/locale_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MainAppBar(text: AppLocalizations.of(context)!.dictum,),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 150,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  AppLocalizations.of(context)!.menu,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: Text(AppLocalizations.of(context)!.authors),
              onTap: () => context.push("/authors"),
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: Text(AppLocalizations.of(context)!.bookmarks),
              onTap: () => context.push("/bookmarks"),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(AppLocalizations.of(context)!.languages),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    final model = context.read<LocaleViewModel>();

                    return AlertDialog(
                      title:
                          Text(AppLocalizations.of(context)!.change_language),
                      content: SizedBox(
                        height: 120,
                        child: Column(
                          children: [
                            RadioListTile<Locale>(
                              title:
                                  Text(AppLocalizations.of(context)!.russian),
                              value: const Locale("ru"),
                              groupValue: model.locale,
                              onChanged: (Locale? value) {
                                model.set(value!);
                              },
                            ),
                            RadioListTile<Locale>(
                              title:
                                  Text(AppLocalizations.of(context)!.english),
                              value: const Locale("en"),
                              groupValue: model.locale,
                              onChanged: (Locale? value) {
                                model.set(value!);
                              },
                            )
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(AppLocalizations.of(context)!.cancel),
                        )
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: Text(AppLocalizations.of(context)!.reference),
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text: AppLocalizations.of(context)!
                                    .client_creator,
                                style: const TextStyle(
                                    color: Colors.black87, height: 1.5),
                                children: <TextSpan>[
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context.push("/web_view",
                                            extra: "https://github.com/Dorero");
                                      },
                                    text: AppLocalizations.of(context)!
                                        .ilya_dyudyaev,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .rest_creator,
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context.push("/web_view",
                                            extra:
                                                "https://github.com/fisenkodv");
                                      },
                                    text: AppLocalizations.of(context)!
                                        .dmitry_fisenko,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                  text:
                                      AppLocalizations.of(context)!.this_client,
                                  style: const TextStyle(
                                      color: Colors.black87, height: 1.5),
                                  children: <TextSpan>[
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => context.push(
                                            "/web_view",
                                            extra:
                                                "https://github.com/Dorero/dictum"),
                                      text: AppLocalizations.of(context)!
                                          .opensource_project,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    ),
                                    TextSpan(
                                        text: AppLocalizations.of(context)!
                                            .you_might_take_part),
                                  ]),
                            ),
                            TextButton(
                              onPressed: () => context.pop(),
                              child: Text(AppLocalizations.of(context)!.cancel),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeViewModel()),
          ChangeNotifierProvider(create: (_) => BookmarkViewModel()),
        ],
        child: const LoadQuotes(),
      ),
    );
  }
}

class LoadQuotes extends StatefulWidget {
  const LoadQuotes({
    super.key,
  });

  @override
  State<LoadQuotes> createState() => _LoadQuotesState();
}

class _LoadQuotesState extends State<LoadQuotes> {
  @override
  Widget build(BuildContext context) {
    final model = context.read<HomeViewModel>();

    return FutureBuilder(
      future: model.initialLoadQuotes(),
      builder: (BuildContext context,
          AsyncSnapshot<(List<Quote>, Quote, Map<String, int>)> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.something_wrong),
                const SizedBox(height: 10),
                IconButton(
                  onPressed: () => setState(() {}),
                  icon: const Icon(Icons.lock_reset),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          final record = snapshot.data!;
          final Map<String, int> stats = record.$3;
          model.quotes = record.$1;

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
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
                  onSubmitted: (query) =>
                      context.push("/search_quotes", extra: query),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.people),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(stats["authors"].toString()),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.library_books),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(stats["quotes"].toString()),
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.get_inspired,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<HomeViewModel>(
                      builder: (_, model, child) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.8,
                          child: ListView.builder(
                            controller: model.scrollController,
                            itemCount: model.quotes.length,
                            itemBuilder: (BuildContext context, int index) {
                              return QuoteCard(quote: model.quotes[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text(AppLocalizations.of(context)!.no_quotes));
        }
      },
    );
  }
}