/*
 * Copyright (c) 2020 .
 */

import 'dart:core';

import 'package:emarates_bd/app/models/award_model.dart';

import 'address_model.dart';
import 'availability_hour_model.dart';
import 'e_provider_type_model.dart';
import 'media_model.dart';
import 'parents/model.dart';
import 'review_model.dart';
import 'tax_model.dart';
import 'user_model.dart';

class EProvider extends Model {
  String? id;
  String? name;
  String? description;
  String? pic;
  String? phoneNumber;
  String? logo;
  String? address;
  String? phone_description;
  String? mobile_description;
  String? mobileNumber;
  String? cover;
  EProviderType? type;
  List<AvailabilityHour>? availabilityHours;
  double? availabilityRange;
  bool? available;
  bool? featured;
  List<Address>? addresses;
  List<Tax>? taxes;
  int? price_level;
  List<User>? employees;
  double? rate;
  List<Review>? reviews;
  List<Award>? award;
  int? totalReviews;
  bool? verified;
  int? bookingsInProgress;
  String? whatsapp;
  String? instagrem;
  String? facebook;
  String? website;
  String? twitter;
  String? lat;
  String? lng;

  EProvider(
      {this.id,
      this.name,
      this.logo,
      this.description,
      this.phone_description,
      this.mobile_description,
      this.lat,
      this.lng,
      this.pic,
      this.address,
      this.cover,
      this.phoneNumber,
      this.mobileNumber,
      this.type,
      this.availabilityHours,
      this.availabilityRange,
      this.available,
      this.featured,
      this.addresses,
      this.price_level,
      this.employees,
      this.rate,
      this.reviews,
      this.award,
      this.totalReviews,
      this.verified,
      this.facebook,
      this.website,
      this.instagrem,
      this.whatsapp,
      this.bookingsInProgress});

  EProvider.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    website = transStringFromJson(json, 'website');
    twitter = transStringFromJson(json, 'twitter');
    logo = transStringFromJson(json, 'logo');
    cover = transStringFromJson(json, 'cover');
    instagrem = transStringFromJson(json, 'instagram');
    whatsapp = transStringFromJson(json, 'whatsapp');
    address = transStringFromJson(json, 'address');
    name = transStringFromJson(json, 'name');
    description = transStringFromJson(json, 'description');
    phone_description = transStringFromJson(json, 'phone_description');
    mobile_description = transStringFromJson(json, 'mobile_description');
    pic = transStringFromJson(json, 'photo_url');
    phoneNumber = stringFromJson(json, 'phone_number');
    mobileNumber = stringFromJson(json, 'mobile_number');
    availabilityHours = listFromJson(
        json, 'availability_hours', (v) => AvailabilityHour.fromJson(v));
    availabilityRange = doubleFromJson(json, 'availability_range');
    available = boolFromJson(json, 'available');
    featured = boolFromJson(json, 'featured');
    addresses = listFromJson(json, 'addresses', (v) => Address.fromJson(v));
    taxes = listFromJson(json, 'taxes', (v) => Tax.fromJson(v));
    employees = listFromJson(json, 'users', (v) => User.fromJson(v));
    rate = doubleFromJson(json, 'rate');
    reviews =
        listFromJson(json, 'e_provider_reviews', (v) => Review.fromJson(v));
    lat = stringFromJson(json, 'lat');
    lng = stringFromJson(json, 'lng');
    award = listFromJson(json, 'awards', (v) => Award.fromJson(v));
    totalReviews =
        reviews!.isEmpty ? intFromJson(json, 'total_reviews') : reviews!.length;
    price_level = intFromJson(json, 'price_level');
    verified = boolFromJson(json, 'verified');
    bookingsInProgress = intFromJson(json, 'bookings_in_progress');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['twitter'] = this.twitter;
    data['cover'] = this.cover;
    data['whatsapp'] = this.whatsapp;
    data['instagram'] = this.instagrem;
    data['website'] = this.website;
    data['photo_url'] = this.pic;
    data['phone_description'] = this.phone_description;
    data['mobile_description'] = this.mobile_description;
    data['description'] = this.description;
    data['available'] = this.available;
    data['phone_number'] = this.phoneNumber;
    data['mobile_number'] = this.mobileNumber;
    data['rate'] = this.rate;
    data['lat'] = this.lat;
    data['total_reviews'] = this.totalReviews;
    data['price_level'] = this.price_level;
    data['verified'] = this.verified;
    data['bookings_in_progress'] = this.bookingsInProgress;
    return data;
  }

  // String get firstImageUrl => this.images?.first?.url ?? '';

  // String get firstGalleryUrl => this.gallery?.first?.url ?? '';

  // String get firstGalleryThumb => this.gallery?.first?.thumb ?? '';

  // String get firstImageThumb => this.images?.first?.thumb ?? '';

  // String get firstImageIcon => this.images?.first?.icon ?? '';

  String? get firstAddress {
    if (this.addresses!.isNotEmpty) {
      return this.addresses!.first.address;
    }
    return '';
  }

  @override
  bool get hasData {
    return id != null &&
        name != null &&
        description != null &&
        pic != null &&
        award != null;
  }

  Map<String, List<String>> groupedAvailabilityHours() {
    Map<String, List<String>> result = {};
    this.availabilityHours!.forEach((element) {
      if (result.containsKey(element.day)) {
        result[element.day]!.add(element.startAt! + ' - ' + element.endAt!);
      } else {
        result[element.day!] = [element.startAt! + ' - ' + element.endAt!];
      }
    });
    return result;
  }

  List<String> getAvailabilityHoursData(String day) {
    List<String> result = [];
    this.availabilityHours!.forEach((element) {
      if (element.day == day) {
        result.add(element.data!);
      }
    });
    return result;
  }

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
      super == other &&
          other is EProvider &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          address == other.address &&
          logo == other.logo &&
          cover == other.cover &&
          twitter == other.twitter &&
          whatsapp == other.whatsapp &&
          facebook == other.facebook &&
          website == other.website &&
          pic == other.pic &&
          description == other.description &&
          phone_description == other.phone_description &&
          mobile_description == other.mobile_description &&
          // images == other.images &&
          // gallery == other.gallery &&
          phoneNumber == other.phoneNumber &&
          mobileNumber == other.mobileNumber &&
          type == other.type &&
          availabilityRange == other.availabilityRange &&
          available == other.available &&
          featured == other.featured &&
          addresses == other.addresses &&
          rate == other.rate &&
          reviews == other.reviews &&
          totalReviews == other.totalReviews &&
          price_level == other.price_level &&
          lat == other.lat &&
          lng == other.lng &&
          verified == other.verified &&
          bookingsInProgress == other.bookingsInProgress;

  @override
  int get hashCode =>
      super.hashCode ^
      id.hashCode ^
      name.hashCode ^
      address.hashCode ^
      logo.hashCode ^
      cover.hashCode ^
      whatsapp.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      instagrem.hashCode ^
      website.hashCode ^
      twitter.hashCode ^
      facebook.hashCode ^
      description.hashCode ^
      // images.hashCode ^
      // gallery.hashCode ^
      phoneNumber.hashCode ^
      mobileNumber.hashCode ^
      type.hashCode ^
      pic.hashCode ^
      availabilityRange.hashCode ^
      available.hashCode ^
      featured.hashCode ^
      addresses.hashCode ^
      rate.hashCode ^
      reviews.hashCode ^
      phone_description.hashCode ^
      mobile_description.hashCode ^
      totalReviews.hashCode ^
      price_level.hashCode ^
      verified.hashCode ^
      award.hashCode ^
      bookingsInProgress.hashCode;
}

class ProviderModel {
  int? id;
  String? name;
  String? description;
  String? address;
  Media? media;
  String? cover;
  String? logo;
  String? city;
  String? phoneNumber;
  String? mobileNumber;
  String? email;
  String? website;
  String? facebook;
  String? twitter;
  String? instagram;
  String? whatsapp;
  int? rating;
  String? createdAt;
  String? lat;
  String? lng;

  ProviderModel(
      {this.id,
      this.name,
      this.description,
      this.address,
      this.media,
      this.cover,
      this.logo,
      this.phoneNumber,
      this.mobileNumber,
      this.email,
      this.website,
      this.city,
      this.facebook,
      this.twitter,
      this.instagram,
      this.whatsapp,
      this.rating,
      this.lat,
      this.lng,
      this.createdAt});

  ProviderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? "";
    description = json['description'] ?? "";
    address = json['address'] ?? "";
    media = json['media'] != null ? new Media.fromJson(json['media']) : null;
    cover = json['cover'];
    logo = json['logo'] ?? "";
    phoneNumber = json['phone_number'] ?? "";
    mobileNumber = json['mobile_number'] ?? "";
    email = json['email'] ?? "";
    website = json['website'] ?? "";
    facebook = json['facebook'] ?? "";
    twitter = json['twitter'] ?? "";
    instagram = json['instagram'] ?? "";
    whatsapp = json['whatsapp'] ?? "";
    city = json['city'] ?? "";
    rating = json['rating'] ?? 0;
    createdAt = json['created_at'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['address'] = this.address;
    if (this.media != null) {
      data['media'] = this.media!.toJson();
    }
    data['cover'] = this.cover;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['logo'] = this.logo;
    data['phone_number'] = this.phoneNumber;
    data['mobile_number'] = this.mobileNumber;
    data['email'] = this.email;
    data['website'] = this.website;
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['instagram'] = this.instagram;
    data['whatsapp'] = this.whatsapp;
    data['rating'] = this.rating;
    data['city'] = this.city;
    data['created_at'] = this.createdAt;
    return data;
  }
}
