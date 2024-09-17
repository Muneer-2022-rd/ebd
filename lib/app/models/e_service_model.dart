import 'package:get/get.dart';
import 'address_model.dart';
import 'category_model.dart';
import 'tag_model.dart';
import 'e_provider_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class EService extends Model {
  String? id;
  String? name;

  String? 	phone;
  String? 	phone2;
  String? description;
  String? phone_description2;
  String? phone_description;
  List<Media>? images;
  List<Media>? gallery;
  List<Media>? pic2;
  String? pic;
  double? price;
  double? discountPrice;
  String? priceUnit;
  String? quantityUnit;
  double? rate;
  int? totalReviews;
  List<Address>? addresses;
  String? duration;
  bool? featured;
  bool? isFavorite;
  List<Category>? categories;
  List<Tag>? tags;
  List<Category>? subCategories;

  EProvider? eProvider;

  EService(
      {this.id,
        this.name,
        this.phone,
        this.phone2,
        this.description,
        this.phone_description,
        this.phone_description2,
        this.images,
        this.pic2,
        this.pic,
        this.price,
        this.discountPrice,
        this.priceUnit,
        this.quantityUnit,
        this.rate,
        this.totalReviews,
        this.addresses,
        this.duration,
        this.featured,
        this.isFavorite,
        this.categories,
        this.tags,
        this.subCategories,
        this.eProvider});

  EService.fromJson(Map<String, dynamic> json) {
    name = transStringFromJson(json, 'name');

    phone = transStringFromJson(json, 'phone');
    phone2 = transStringFromJson(json, 'phone2');
    description = transStringFromJson(json, 'description');
    phone_description = transStringFromJson(json, 'phone_description');
    phone_description2 = transStringFromJson(json, 'phone2_description');
    images = mediaListFromJson(json, 'images');
    gallery = galleryListFromJson(json, 'gallery');
    pic2 = mediaListFromJson(json, 'picture');
    pic = transStringFromJson(json, 'picture');
    price = doubleFromJson(json, 'price');
    discountPrice = doubleFromJson(json, 'discount_price');
    priceUnit = stringFromJson(json, 'price_unit');
    quantityUnit = transStringFromJson(json, 'quantity_unit');
    rate = doubleFromJson(json, 'rate');
    totalReviews = intFromJson(json, 'total_reviews');
    addresses = listFromJson(json, 'addresses', (v) => Address.fromJson(v));
    duration = stringFromJson(json, 'duration');
    featured = boolFromJson(json, 'featured');
    isFavorite = boolFromJson(json, 'is_favorite');
    categories = listFromJson<Category>(json, 'categories', (value) => Category.fromJson(value));
    tags = listFromJson<Tag>(json, 'tags', (value) => Tag.fromJson(value));
    subCategories = listFromJson<Category>(json, 'sub_categories', (value) => Category.fromJson(value));
    eProvider = objectFromJson(json, 'e_provider', (value) => EProvider.fromJson(value));
    super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) data['id'] = this.id;
    if (name != null) data['name'] = this.name;
    if (pic != null) data['picture'] = this.pic;
    if (phone != null) data['phone'] = this.phone;
    if (phone2 != null) data['phone2'] = this.phone2;
    if (this.description != null) data['description'] = this.description;
    if (this.phone_description2 != null) data['phone_description2'] = this.phone_description2;
    if (this.phone_description != null) data['phone2_description'] = this.phone_description;
    if (this.price != null) data['price'] = this.price;
    if (discountPrice != null) data['discount_price'] = this.discountPrice;
    if (priceUnit != null) data['price_unit'] = this.priceUnit;
    if (quantityUnit != null && quantityUnit != 'null') data['quantity_unit'] = this.quantityUnit;
    if (rate != null) data['rate'] = this.rate;
    if (totalReviews != null) data['total_reviews'] = this.totalReviews;
    if (duration != null) data['duration'] = this.duration;
    if (featured != null) data['featured'] = this.featured;
    if (isFavorite != null) data['is_favorite'] = this.isFavorite;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v?.id).toList();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v?.id).toList();
    }
    if (this.images != null) {
      data['image'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.gallery != null) {
      data['gallery'] = this.gallery!.map((v) => v.toJson()).toList();
    }
  if (this.pic2 != null) {
      data['picture'] = this.pic2!.map((v) => v.toJson()).toList();
    }

    if (this.subCategories != null) {
      data['sub_categories'] = this.subCategories!.map((v) => v.toJson()).toList();
    }
    if (this.eProvider != null && this.eProvider!.hasData) {
      data['e_provider_id'] = this.eProvider?.id;
    }

    return data;
  }

  String get firstImageUrl => this.images?.first.url ?? '';

  String get firstImageGallryUrl => this.gallery?.first.url ?? '';

  String get firstpicUrl => this.pic2?.first.url ?? '';

  String get firstImageThumb => this.images?.first.thumb ?? '';

  String get firstGalleryThumb => this.images?.first.thumb ?? '';

  String get firstImageIcon => this.images?.first.icon ?? '';

  String? get firstAddress {
    if (this.addresses!.isNotEmpty) {
      return this.addresses?.first.address;
    }
    return '';
  }


  @override
  bool get hasData {
    return id != null && name != null && phone != null && phone2 != null && description != null && phone_description != null && phone_description2 != null  && pic!= null  ;
  }

  /*
  * Get the real price of the service
  * when the discount not set, then it return the price
  * otherwise it return the discount price instead
  * */
  double? get getPrice {
    return (discountPrice ?? 0) > 0 ? discountPrice : price;
  }

  String get getUnit {
    if (priceUnit == 'fixed') {
      if (quantityUnit!.isNotEmpty) {
        return "/" + quantityUnit!.tr;
      } else {
        return "";
      }
    } else {
      return "/h".tr;
    }
  }

  @override
  bool operator ==(Object? other) =>
      identical(this, other) ||
          super == other &&
              other is EService &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              pic == other.pic &&
              // price_level == other.price_level&&
              description == other.description &&
              phone_description == other.phone_description &&
              phone_description2 == other.phone_description2 &&
              rate == other.rate &&
              isFavorite == other.isFavorite &&
              categories == other.categories &&
              tags == other.tags &&
              subCategories == other.subCategories &&
              addresses == other.addresses &&
              eProvider == other.eProvider;


  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ name.hashCode  ^ phone.hashCode ^ phone2.hashCode ^ description.hashCode ^ phone_description.hashCode ^ phone_description2.hashCode ^ rate.hashCode ^ eProvider.hashCode ^ categories.hashCode ^ subCategories.hashCode ^ isFavorite.hashCode ^ tags.hashCode ^ addresses.hashCode ^ pic.hashCode;
}
