import 'package:flutter/material.dart';
import 'package:emarates_bd/app/models/e_provider_model.dart';

import 'e_service_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class Category extends Model {
  String? id;
  String? name;
  String? svg;
  // Media cover_img;
  // String background;
  // String cover_back;
  String? description;
  Color? color = Colors.pink;
  // Media image;
  // bool featured;
  List<Category>? subCategories;
  // List<EService> eServices;
  List<EProvider>? eProviders;

  // Category({this.id, this.name, this.description this.image, this.featured, this.subCategories, this.eServices});
  Category(
      {this.id,
      this.name,
      this.description,
      this.color,
      this.subCategories,
      this.eProviders});

  Category.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    svg = transStringFromJson(json, 'svg');
    // cover_img = mediaFromJson(json, 'cover');
    // background = transStringFromJson(json, 'background');
    // cover_back = transStringFromJson(json, 'cover_back');
    color = colorFromJson(json, 'color');
    description = transStringFromJson(json, 'description');
    // image = mediaFromJson(json, 'image');
    // featured = boolFromJson(json, 'featured');
    // eServices = listFromJsonArray(json, ['e_services', 'featured_e_services'], (v) => EService.fromJson(v));
    eProviders =
        listFromJsonArray(json, ['providers'], (v) => EProvider.fromJson(v));
    subCategories =
        listFromJson(json, 'sub_categories', (v) => Category.fromJson(v));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['svg'] = this.svg;
    // data['cover'] = this.cover;
    // data['background'] = this.background;
    // data['cover_back'] = this.cover_back;
    data['description'] = this.description;
    data['color'] = '#${this.color?.value.toRadixString(16)}';
    return data;
  }

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      super == other &&
          other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          // cover_back == other.cover_back &&
          svg == other.svg &&
          // background == other.background &&
          // cover_back == other.cover_back &&
          description == other.description &&
          color == other.color
          // && image == other.image &&
          // cover_img == other.cover_img &&
          // featured == other.featured;
          // &&  subCategories == other.subCategories;
          // && eServices == other.eServices;
          &&
          eProviders == other.eProviders;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode
      // ^ background.hashCode
      // ^ cover_img.hashCode
      ^
      svg.hashCode ^
      description.hashCode ^
      color.hashCode
      // ^ image.hashCode
      // ^ featured.hashCode
      ^
      subCategories.hashCode
      // ^ cover_back.hashCode;
      ^
      eProviders.hashCode;
  // ^ eServices.hashCode;
}
