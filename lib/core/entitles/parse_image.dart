import 'package:historical_maps/core/entitles/image_entity.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class ParseImage extends ParseObject implements ParseCloneable {
  ParseImage() : super(_keyTableName);
  ParseImage.clone() : this();

  @override
  clone(Map<String, dynamic> map) => ParseImage.clone()..fromJson(map);

  static const String _keyTableName = 'Image';

  String? get title => get<String>(ImageEntity.keyTitle);
}
