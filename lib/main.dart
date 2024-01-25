import 'package:dictum/api/local_storage.dart';
import 'package:dictum/screen/author_detail_screen.dart';
import 'package:dictum/screen/authors_screen.dart';
import 'package:dictum/screen/home_screen.dart';
import 'package:dictum/screen/search_quotes_screen.dart';
import 'package:dictum/screen/web_view_screen.dart';
import 'package:dictum/view_model/locale_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'screen/bookmarks_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleViewModel(),
      child: Consumer<LocaleViewModel>(
        builder: (context, model, child) {
          return MaterialApp.router(
            locale: model.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: const [
              Locale('en'),
              Locale('ru'),
            ],
            title: 'Dictum',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            routerConfig: GoRouter(initialLocation: '/', routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
              GoRoute(
                path: '/author/:id',
                builder: (context, state) {
                  return AuthorDetailScreen(
                      id: state.pathParameters["id"]!,
                      name: GoRouterState.of(context).extra! as String);
                },
              ),
              GoRoute(
                path: '/authors',
                builder: (context, state) => const AuthorScreen(),
              ),
              GoRoute(
                path: '/bookmarks',
                builder: (context, state) => const BookmarksScreen(),
              ),
              GoRoute(
                path: '/web_view',
                builder: (context, state) => WebViewScreen(url: GoRouterState.of(context).extra! as String,),
              ),
              GoRoute(
                path: '/search_quotes',
                builder: (context, state) {
                  return SearchQuotesScreen(
                      query: GoRouterState.of(context).extra! as String);
                },
              ),
            ]),
          );
        },
      ),
    );
  }
}
