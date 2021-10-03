class MapEntity {
  MapEntity({
    required this.id,
    required this.name,
    required this.year,
    required this.file,
    this.localPath,
    this.local = false,
    bool isRemovable = true,
  }) : _isRemovable = isRemovable;

  final String id;
  final String name;
  final int year;
  final bool local;
  final String file;
  final bool _isRemovable;

  String? localPath;

  bool get isInstalled => localPath != null;

  bool get isRemovable => _isRemovable;

  factory MapEntity.fromGraphQL(node) {
    return MapEntity(
      id: node['objectId'],
      name: node['name'],
      year: node['year'],
      file: node['file'],
    );
  }
}
