class MapData {
  MapData(
      {required this.name, required this.year, this.path, this.local = false});
  String name;
  String year;
  String? path;
  bool local;
  bool get isInstalled => false;
}
