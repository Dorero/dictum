import 'package:dictum/api/local_storage.dart';
import 'package:dictum/api/rest.dart';
import 'package:dictum/repository/stats/stats_repository.dart';

class StatsRepositoryRest implements StatsRepository {
  final Rest restApi = Rest();
  final languageCode = LocaleStorage.prefs.getString("language") ?? "ru";

  @override
  Future<Map<String, int>> byLanguage() async {
    final result = await restApi.get("statistics/$languageCode");
    return {"authors": result["authors"], "quotes": result["quotes"]};
  }
}
