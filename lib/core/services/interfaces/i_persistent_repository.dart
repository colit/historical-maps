abstract class IPersistentRepository {
  Future<bool?> getBool(String s);
  Future<void> setBool(String s, bool value);

  Future<int?> getInt(String s);
  Future<void> setInt(String s, int value);

  Future<String?> getString(String s);
  Future<void> setString(String s, String value);
}
