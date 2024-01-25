abstract interface class StatsRepository {
  Future<Map<String, int>> byLanguage();
}
