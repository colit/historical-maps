class MapReference {
  static const keyObjectId = 'objectId';
  static const keyName = 'name';
  static const keyYear = 'year';
  static const keyKey = 'key';

  MapReference({
    required this.id,
    required this.name,
    required this.year,
    required this.key,
  });

  final String id;
  final String name;
  final int year;
  final String key;

  String get reference => 'histo:$key';

  factory MapReference.fromGraphQL(node) => MapReference(
        id: node[keyObjectId],
        name: node[keyName],
        year: node[keyYear],
        key: node[keyKey],
      );
}
