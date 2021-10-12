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
}
