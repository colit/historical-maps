class MapEntity {
  MapEntity({
    required this.name,
    required this.year,
    this.path,
    this.local = false,
    bool isRemovable = true,
  }) : _isRemovable = isRemovable;

  final String name;
  final int year;
  final String? path;
  final bool local;
  final bool _isRemovable;

  bool get isInstalled => path != null;

  bool get isRemovable => _isRemovable;
}
