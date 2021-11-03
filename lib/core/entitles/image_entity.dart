import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

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
  static const keyPointOfInterest = 'pointOfInterest';

  ImageEntity({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.file,
    this.yearPublished = 1900,
    this.title,
    this.description,
    this.author,
    this.authorURL,
    this.license,
    this.licenseURL,
    this.source,
    this.sourceURL,
    this.pointOfInterestId,
  });
  final String id;
  final ParseFile file;
  final int? yearPublished;
  final String? title;
  final String? description;
  final double latitude;
  final double longitude;
  final String? author;
  final String? authorURL;
  final String? license;
  final String? licenseURL;
  final String? source;
  final String? sourceURL;
  final String? pointOfInterestId;

  factory ImageEntity.fromMap(Map<String, dynamic> map) => ImageEntity(
        id: map[keyObjectId],
        latitude: map[keyLatitude],
        longitude: map[keyLongitude],
        file: map['file'],
        yearPublished: map[keyPublished],
        title: map[keyTitle],
        description: map[keyDescription],
        author: map[keyAuthor] ?? 'Author unbekannt',
        authorURL: map[keyAuthorURL],
        license: map[keyLicense],
        licenseURL: map[keyLicenseURL],
        source: map[keySource],
        sourceURL: map[keySourceURL],
        pointOfInterestId: map[keyPointOfInterest],
      );
}
