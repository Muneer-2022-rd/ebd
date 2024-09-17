import 'dart:convert';

SingleProviderModel singleProviderModelFromJson(String str) => SingleProviderModel.fromJson(json.decode(str));

String singleProviderModelToJson(SingleProviderModel data) => json.encode(data.toJson());

class SingleProviderModel {
  SingleProviderModel({
    this.id,
    this.name,
    this.office,
    this.description,
    this.phoneNumber,
    this.mobileNumber,
    this.email,
    this.website,
    this.twitter,
    this.instagram,
    this.whatsapp,
    this.employeesNumber,
    this.emp,
    this.workingHours,
    this.addresses,
    this.media,
    this.cover,
    this.logo,
    this.rating,
    this.reviews,
    this.gallery,
    this.lat ,
    this.long,
  });

  int? id;
  String? name;
  String? office;
  String? description;
  String? phoneNumber;
  String? mobileNumber;
  String? email;
  String? website;
  String? twitter;
  String? instagram;
  String? whatsapp;
  int? employeesNumber;
  List<dynamic>? emp;
  WorkingHours? workingHours;
  Addresses? addresses;
  String? lat ;
  String ? long ;
  Media2? media;
  String? cover;
  String? logo;
  dynamic rating;
  List<Reviews>? reviews;
  List<Gallery>? gallery;

  factory SingleProviderModel.fromJson(Map<String, dynamic> json) => SingleProviderModel(
    id: json["id"],
    name: json["name"],
    office: json["office"],
    description: json["description"],
    phoneNumber: json["phone_number"],
    mobileNumber: json["mobile_number"],
    email: json["email"],
    website: json["website"],
    twitter: json["twitter"],
    instagram: json["instagram"],
    whatsapp: json["whatsapp"],
    lat:  json['lat'] ?? '0',
    long: json['lng']?? '0',
    employeesNumber: json["employees_number"],
    emp: List<dynamic>.from(json["emp"].map((x) => x)),
    workingHours: json["working_hours"]!=null ? WorkingHours.fromJson(json["working_hours"]) : null,
    addresses: Addresses.fromJson(json["addresses"]),
    media: Media2.fromJson(json["media"]),
    cover: json["cover"],
    logo: json["logo"],
    rating: json["rating"],
    reviews: List<Reviews>.from(json["reviews"].map((x) => Reviews.fromJson(x))),
    gallery: List<Gallery>.from(json["gallery"].map((x) => Gallery.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "office": office,
    "description": description,
    "phone_number": phoneNumber,
    "mobile_number": mobileNumber,
    "email": email,
    "website": website,
    "twitter": twitter,
    "instagram": instagram,
    "whatsapp": whatsapp,
    "employees_number": employeesNumber,
    "emp": List<dynamic>.from(emp!.map((x) => x)),
    "working_hours": workingHours!.toJson(),
    "addresses": addresses!.toJson(),
    "media": media!.toJson(),
    "cover": cover,
    "logo": logo,
    "rating": rating,
    "reviews": List<dynamic>.from(reviews!.map((x) => x)),
    "gallery": List<dynamic>.from(gallery!.map((x) => x.toJson())),
  };
}

class Reviews {
  int? reviewId;
  int? userId;
  String? userDisplayName;
  String? profilePicUrl;
  String? rating;
  String? text;
  int? pubdate;
  String? profileLink;

  Reviews(
      {this.reviewId,
        this.userId,
        this.userDisplayName,
        this.profilePicUrl,
        this.rating,
        this.text,
        this.pubdate,
        this.profileLink});

  Reviews.fromJson(Map<String, dynamic> json) {
    reviewId = json['review_id'];
    userId = json['user_id'];
    userDisplayName = json['user_display_name'];
    profilePicUrl = json['profile_pic_url'];
    rating = json['rating'];
    text = json['text'];
    pubdate = json['pubdate'];
    profileLink = json['profile_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['review_id'] = this.reviewId;
    data['user_id'] = this.userId;
    data['user_display_name'] = this.userDisplayName;
    data['profile_pic_url'] = this.profilePicUrl;
    data['rating'] = this.rating;
    data['text'] = this.text;
    data['pubdate'] = this.pubdate;
    data['profile_link'] = this.profileLink;
    return data;
  }
}

class Addresses {
  Addresses({
    this.id,
    this.description,
    this.address,
  });

  int? id;
  String? description;
  String? address;

  factory Addresses.fromJson(Map<String, dynamic> json) => Addresses(
    id: json["id"],
    description: json["description"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "address": address,
  };
}

class Gallery {
  Gallery({
    this.imgId,
    this.imgUrl,
    this.imgUrlThumb,
    this.dataTitle,
    this.source,
  });

  int? imgId;
  String? imgUrl;
  String? imgUrlThumb;
  String? dataTitle;
  String? source;

  factory Gallery.fromJson(Map<String, dynamic> json) => Gallery(
    imgId: json["img_id"],
    imgUrl: json["img_url"],
    imgUrlThumb: json["img_url_thumb"],
    dataTitle: json["data_title"],
    source: json["source"],
  );

  Map<String, dynamic> toJson() => {
    "img_id": imgId,
    "img_url": imgUrl,
    "img_url_thumb": imgUrlThumb,
    "data_title": dataTitle,
    "source": source,
  };
}

class Media2 {
  Media2({
    this.url,
    this.thumb,
  });

  String? url;
  String? thumb;

  factory Media2.fromJson(Map<String, dynamic> json) => Media2(
    url: json["url"],
    thumb: json["thumb"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "thumb": thumb,
  };
}

class WorkingHours {
  WorkingHours({
    this.mon,
    this.tue,
    this.wed,
    this.thu,
    this.sat,
    this.sun,
  });

  List<String>? mon;
  List<String>? tue;
  List<String>? wed;
  List<String>? thu;
  List<String>? sat;
  List<String>? sun;


  factory WorkingHours.fromJson(Map<String, dynamic> json) => WorkingHours(
    mon: List<String>.from(json["Mon"]??["Off"].map((x) => x)),
    tue: List<String>.from(json["Tue"]??["Off"].map((x) => x)),
    wed: List<String>.from(json["Wed"]??["Off"].map((x) => x)),
    thu: List<String>.from(json["Thu"]??["Off"].map((x) => x)),
    sat: List<String>.from(json["Sat"]??["Off"].map((x) => x)),
    sun: List<String>.from(json["Sun"]??["Off"].map((x) => x)),
  );




  Map<String, dynamic> toJson() => {
    "Mon": List<dynamic>.from(mon!.map((x) => x)),
    "Tue": List<dynamic>.from(tue!.map((x) => x)),
    "Wed": List<dynamic>.from(wed!.map((x) => x)),
    "Thu": List<dynamic>.from(thu!.map((x) => x)),
    "Sat": List<dynamic>.from(sat!.map((x) => x)),
    "Sun": List<dynamic>.from(sun!.map((x) => x)),
  };


}



