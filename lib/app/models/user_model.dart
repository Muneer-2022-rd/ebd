import '../../common/uuid.dart';
import 'media_model.dart';
import 'parents/model.dart';

class User extends Model {
  String? social_id;
  String? id;
  String? name;
  String? lname;
  String? img;
  String? email;
  String? password;
  Media? avatar;
  String? apiToken;
  String? deviceToken;
  String? phoneNumber;
  bool? verifiedPhone;
  String? verificationId;
  String? address;
  String? bio;
  int? userType;
  String? coname;
  String? coaddress;
  String? coemail;
  String? categories;
  String? city_id;
  bool? auth;
  bool? isSocial;
  int? placeId;

  User({
    this.social_id,
    this.id,
    this.name,
    this.lname,
    this.img,
    this.email,
    this.password,
    this.apiToken,
    this.deviceToken,
    this.phoneNumber,
    this.verifiedPhone,
    this.verificationId,
    this.address,
    this.bio,
    this.avatar,
    this.coname,
    this.coaddress,
    this.categories,
    this.coemail,
    this.userType,
    this.city_id,
    this.auth,
    this.placeId,
    this.isSocial,
  });

  User.fromJson(Map<String, dynamic> json) {
    coemail = stringFromJson(json, 'coemail', defaultValue: "");
    coaddress = stringFromJson(json, 'coaddress', defaultValue: "");
    coname = stringFromJson(json, 'coname', defaultValue: "");
    categories = stringFromJson(json, 'categories', defaultValue: "");
    city_id = stringFromJson(json, 'city_id', defaultValue: "");
    userType = intFromJson(json, 'user_type');
    name = stringFromJson(json, 'first_name', defaultValue: "");
    lname = stringFromJson(json, 'last_name', defaultValue: "");
    placeId = intFromJson(json, 'place_id');
    img = stringFromJson(json, 'picture', defaultValue: "");
    email = stringFromJson(json, 'email', defaultValue: "");
    apiToken = stringFromJson(json, 'api_token', defaultValue: "");
    deviceToken = stringFromJson(json, 'device_token', defaultValue: "");
    phoneNumber = stringFromJson(json, 'phone', defaultValue: "");
    verifiedPhone =
        boolFromJson(json, 'phone_verification', defaultValue: false);
    auth = json["auth"] ?? false;
    isSocial = json["isSocial"] ?? false;
    try {
      address = json['custom_fields']['address']['view'];
    } catch (e) {
      address = stringFromJson(json, 'address');
    }
    try {
      bio = json['custom_fields']['bio']['view'];
    } catch (e) {
      bio = stringFromJson(json, 'bio');
    }
    super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['last_name'] = this.lname;
    data['first_name'] = this.name;
    data['place_id'] = this.placeId;
    data['coname'] = this.coname;
    data['user_type'] = this.userType;
    data['city_id'] = this.city_id;
    data['coaddress'] = this.coaddress;
    data['coemail'] = this.coemail;
    data['categories'] = this.categories;
    data['picture'] = this.img;
    data['isSocial'] = this.isSocial;
    data['email'] = this.email;
    data['auth'] = this.auth;
    if (password != null && password != '') {
      data['password'] = this.password;
    }
    data['api_token'] = this.apiToken;
    if (deviceToken != null) {
      data["device_token"] = deviceToken;
    }
    data["phone"] = phoneNumber;
    if (verifiedPhone != null && verifiedPhone!) {
      data["phone_verification"] = DateTime.now().toLocal().toString();
    }
    data["address"] = address;
    data["bio"] = bio;
    if (this.avatar != null && Uuid.isUuid(avatar!.id!)) {
      data['avatar'] = this.avatar?.id;
    }
    if (avatar != null) {
      data["media"] = [avatar?.toJson()];
    }
    return data;
  }

  Map toRestrictMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map['place_id'] = placeId;
    map["isSocial"] = isSocial;
    map["email"] = email;
    map["picture"] = img;
    map["first_name"] = name;
    map["last_name"] = lname;
    map["thumb"] = avatar!.thumb;
    map["user_type"] = userType;
    map["coemail"] = coemail;
    map["coaddress"] = coaddress;
    map["city_id"] = city_id;
    map["coname"] = coname;
    map['auth'] = auth;
    map["categories"] = categories;
    return map;
  }

  @override
  bool operator ==(Object? other) =>
      super == other &&
      other is User &&
      runtimeType == other.runtimeType &&
      userType == other.userType &&
      name == other.name &&
      lname == other.lname &&
      img == other.img &&
      email == other.email &&
      password == other.password &&
      avatar == other.avatar &&
      apiToken == other.apiToken &&
      deviceToken == other.deviceToken &&
      phoneNumber == other.phoneNumber &&
      verifiedPhone == other.verifiedPhone &&
      verificationId == other.verificationId &&
      address == other.address &&
      bio == other.bio &&
      categories == other.categories &&
      coemail == other.coemail &&
      coaddress == other.coaddress &&
      city_id == other.city_id &&
      coname == other.coname &&
      auth == other.auth &&
      placeId == other.placeId &&
      isSocial == other.isSocial;

  @override
  int get hashCode =>
      super.hashCode ^
      name.hashCode ^
      lname.hashCode ^
      categories.hashCode ^
      coaddress.hashCode ^
      coemail.hashCode ^
      city_id.hashCode ^
      coname.hashCode ^
      img.hashCode ^
      email.hashCode ^
      password.hashCode ^
      avatar.hashCode ^
      apiToken.hashCode ^
      deviceToken.hashCode ^
      phoneNumber.hashCode ^
      verifiedPhone.hashCode ^
      verificationId.hashCode ^
      address.hashCode ^
      bio.hashCode ^
      placeId.hashCode ^
      userType.hashCode ^
      auth.hashCode ^
      isSocial.hashCode;
}
