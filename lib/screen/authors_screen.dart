import 'package:dictum/component/main_app_bar.dart';
import 'package:dictum/model/author.dart';
import 'package:dictum/view_model/authors_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AuthorScreen extends StatelessWidget {
  const AuthorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: MainAppBar(text: AppLocalizations.of(context)!.authors,),
      body: ChangeNotifierProvider(
        create: (context) => AuthorsViewModel(),
        child: const LoadAuthors(),
      ),
    );
  }
}

class LoadAuthors extends StatefulWidget {
  const LoadAuthors({super.key});

  @override
  State<LoadAuthors> createState() => _LoadAuthorsState();
}

class _LoadAuthorsState extends State<LoadAuthors> {
  @override
  Widget build(BuildContext context) {
    final model = context.read<AuthorsViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.search_authors,
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
                model.reloadAuthors(query);
              }
            },
            onSubmitted: (query) {
              model.reloadAuthors(query);
            },
          ),
          const SizedBox(height: 10.0,),
          FutureBuilder(
            future: model.initialLoadAuthors(),
            builder: (BuildContext context, AsyncSnapshot<List<Author>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
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
                model.authors = snapshot.data!;

                return const Expanded(child: ListAuthors());
              } else {
                return Center(child: Text(AppLocalizations.of(context)!.no_authors));
              }
            },
          ),
        ],
      ),
    );
  }
}

class ListAuthors extends StatelessWidget {
  const ListAuthors({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AuthorsViewModel>();
    final authors = model.authors;

    return GridView.builder(
      itemCount: authors.length,
      controller: model.scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
      ),
      itemBuilder: (context, index) {
        final author = authors[index];

        return InkWell(
          onTap: () => context.push("/author/${author.id}", extra: author.name),
          child: Card(
            child: Center(
              child: Text(
                author.name,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
