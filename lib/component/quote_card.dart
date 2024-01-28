import 'package:dictum/model/quote.dart';
import 'package:dictum/view_model/bookmark_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(quote.text),
                    TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: Text(
                        quote.author.name,
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      onPressed: () => context.push(
                          '/author/${quote.author.id}',
                          extra: quote.author.name),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => Positioned(
                    bottom: 0,
                    right: 0,
                    child: Consumer<BookmarkViewModel>(
                      builder: (_, model, child) {
                        final quoteString = quote.toString();

                        return IconButton(
                          onPressed: () => model.handleBookmark(quoteString),
                          icon: model.quotes.contains(quoteString)
                              ? const Icon(Icons.bookmark)
                              : const Icon(Icons.bookmark_border),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
