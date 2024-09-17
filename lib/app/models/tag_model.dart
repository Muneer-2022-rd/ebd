import 'package:flutter/material.dart';

import 'e_service_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class Tag extends Model {
  String? id;
  String? tag;



  Tag({this.id, this.tag});

  Tag.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    tag = transStringFromJson(json, 'tag');

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['tag'] = this.tag;

    return data;
  }

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      super == other &&
          other is Tag &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          tag == other.tag;


  @override
  int get hashCode =>
      super.hashCode ^ tag.hashCode ;
}
