class ImageEntity {
  static const keyObjectId = 'objectId';
  static const keyMap = 'map';
  static const keyPublished = 'published';
  static const keyTitle = 'title';
  static const keyDescription = 'description';
  static const keyLatitude = 'latitude';
  static const keyLongitude = 'longitude';
  static const keyAuthor = 'author';
  static const keyAuthorURL = 'authorURL';
  static const keyLicense = 'license';
  static const keyLicenseURL = 'licenseURL';
  static const keySource = 'source';
  static const keySourceURL = 'sourceURL';
  static const keyImage = 'image';

  ImageEntity({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.imageURL,
    this.published = 1900,
    this.tilte = '',
    this.description = '',
    this.author = '',
    this.authorURL = '',
    this.license = '',
    this.licenseURL = '',
    this.source = '',
    this.sourceURL = '',
  });
  final String id;
  final int published;
  final String tilte;
  final String description;
  final double latitude;
  final double longitude;
  final String author;
  final String authorURL;
  final String license;
  final String licenseURL;
  final String source;
  final String sourceURL;
  final String imageURL;

  factory ImageEntity.fromMap(Map<String, dynamic> map) => ImageEntity(
        id: map[keyObjectId],
        latitude: map[keyLatitude],
        longitude: map[keyLongitude],
        imageURL: 'imageURL',
        published: map[keyPublished],
        tilte: map[keyTitle],
        description: map[keyDescription],
        author: map[keyAuthor],
        authorURL: map[keyAuthorURL],
        license: map[keyLicense],
        licenseURL: map[keyLicenseURL],
        source: map[keySource],
        sourceURL: map[keySourceURL],
      );
}
