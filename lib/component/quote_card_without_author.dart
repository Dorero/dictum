import 'package:dictum/model/quote.dart';
import 'package:dictum/view_model/bookmark_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuoteCardWithoutAuthor extends StatelessWidget {
  const QuoteCardWithoutAuthor({super.key, required this.quote});

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
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(quote.text),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
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
