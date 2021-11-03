import 'dart:ffi';

import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ParseImage extends ParseObject implements ParseCloneable {
  ParseImage() : super(_keyTableName);
  ParseImage.clone() : this();

  @override
  clone(Map<String, dynamic> map) => ParseImage.clone()..fromJson(map);

  static const String _keyTableName = 'Image';

  String? get title => get<String>(ImageEntity.keyTitle);
  Map<String, dynamic> get map {
    return {
      'file': get<ParseFile>(ImageEntity.keyImage),
      ImageEntity.keyObjectId: get<String>(ImageEntity.keyObjectId),
      ImageEntity.keyPublished: get<int>(ImageEntity.keyPublished),
      ImageEntity.keyTitle: get<String>(ImageEntity.keyTitle),
      ImageEntity.keyDescription: get<String>(ImageEntity.keyDescription),
      ImageEntity.keyLatitude: get<double>(ImageEntity.keyLatitude),
      ImageEntity.keyLongitude: get<double>(ImageEntity.keyLongitude),
      ImageEntity.keyAuthor: get<String>(ImageEntity.keyAuthor),
      ImageEntity.keyAuthorURL: get<String>(ImageEntity.keyAuthorURL),
      ImageEntity.keyLicense: get<String>(ImageEntity.keyLicense),
      ImageEntity.keyLicenseURL: get<String>(ImageEntity.keyLicenseURL),
      ImageEntity.keySource: get<String>(ImageEntity.keySource),
      ImageEntity.keySourceURL: get<String>(ImageEntity.keySourceURL),
      ImageEntity.keyPointOfInterest:
          get<ParseObject>(ImageEntity.keyPointOfInterest)?.objectId,
    };
  }
}
