class PropertiesModel {
  PropertiesModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final Data? data;

  factory PropertiesModel.fromJson(Map<String, dynamic> json) {
    return PropertiesModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
  });

  final num currentPage;
  final List<Datum> data;
  final String firstPageUrl;
  final num from;
  final dynamic nextPageUrl;
  final String path;
  final num perPage;
  final dynamic prevPageUrl;
  final num to;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      currentPage: json["current_page"] ?? 0,
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      firstPageUrl: json["first_page_url"] ?? "",
      from: json["from"] ?? 0,
      nextPageUrl: json["next_page_url"],
      path: json["path"] ?? "",
      perPage: json["per_page"] ?? 0,
      prevPageUrl: json["prev_page_url"],
      to: json["to"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data.map((x) => x.toJson()).toList(),
    "first_page_url": firstPageUrl,
    "from": from,
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
  };
}

class Datum {
  Datum({
    required this.id,
    required this.locationId,
    required this.propertyTypeId,
    required this.ownerId,
    required this.availabilityStatusId,
    required this.coverImage,
    required this.availabilityStatus,
    required this.owner,
    required this.propertyType,
    required this.location,
    required this.rent,
    required this.residential,
    required this.purchase,
    required this.offplan,
    required this.commercial,
  });

  final int id;
  final int locationId;
  final int propertyTypeId;
  final int ownerId;
  final int availabilityStatusId;
  final CoverImage? coverImage;
  final AvailabilityStatus? availabilityStatus;
  final Owner? owner;
  final PropertyType? propertyType;
  final Location? location;
  final Rent? rent;
  final Purchase? purchase;
  final OffPlan? offplan;
  final Residential? residential;
  final Commercial? commercial;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"] ?? 0,
      locationId: json["location_id"] ?? 0,
      propertyTypeId: json["property_type_id"] ?? 0,
      ownerId: json["owner_id"] ?? 0,
      availabilityStatusId: json["availability_status_id"] ?? 0,
      coverImage: json["cover_image"] == null
          ? null
          : CoverImage.fromJson(json["cover_image"]),
      availabilityStatus: json["availability_status"] == null
          ? null
          : AvailabilityStatus.fromJson(json["availability_status"]),
      owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
      propertyType: json["property_type"] == null
          ? null
          : PropertyType.fromJson(json["property_type"]),
      location:
      json["location"] == null ? null : Location.fromJson(json["location"]),
      rent: json["rent"] == null ? null : Rent.fromJson(json["rent"]),
      purchase: json["purchase"] == null ? null : Purchase.fromJson(json["purchase"]),
      offplan: json["off_plan"] == null ? null : OffPlan.fromJson(json["off_plan"]),
      residential: json["residential"] == null
          ? null
          : Residential.fromJson(json["residential"]),
      commercial: json["commercial"] == null
          ? null
          : Commercial.fromJson(json["commercial"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "location_id": locationId,
    "property_type_id": propertyTypeId,
    "owner_id": ownerId,
    "availability_status_id": availabilityStatusId,
    "cover_image": coverImage?.toJson(),
    "availability_status": availabilityStatus?.toJson(),
    "owner": owner?.toJson(),
    "property_type": propertyType?.toJson(),
    "location": location?.toJson(),
    "rent": rent?.toJson(),
    "residential": residential?.toJson(),
    "commercial": commercial?.toJson(),
  };
}

class AvailabilityStatus {
  AvailabilityStatus({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory AvailabilityStatus.fromJson(Map<String, dynamic> json) {
    return AvailabilityStatus(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class CoverImage {
  CoverImage({
    required this.id,
    required this.propertyId,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int propertyId;
  final String imagePath;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory CoverImage.fromJson(Map<String, dynamic> json) {
    return CoverImage(
      id: json["id"] ?? 0,
      propertyId: json["property_id"] ?? 0,
      imagePath: json["image_path"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_id": propertyId,
    "image_path": imagePath,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Location {
  Location({
    required this.id,
    required this.countryId,
    required this.cityId,
    required this.latitude,
    required this.longitude,
    required this.additionalInfo,
    required this.createdAt,
    required this.updatedAt,
    required this.country,
    required this.city,
  });

  final int id;
  final int countryId;
  final int cityId;
  final dynamic latitude;
  final num longitude;
  final String additionalInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Country? country;
  final City? city;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json["id"] ?? 0,
      countryId: json["country_id"] ?? 0,
      cityId: json["city_id"] ?? 0,
      latitude: json["latitude"],
      longitude: json["longitude"] ?? 0,
      additionalInfo: json["additional_info"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      country:
      json["country"] == null ? null : Country.fromJson(json["country"]),
      city: json["city"] == null ? null : City.fromJson(json["city"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_id": countryId,
    "city_id": cityId,
    "latitude": latitude,
    "longitude": longitude,
    "additional_info": additionalInfo,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "country": country?.toJson(),
    "city": city?.toJson(),
  };
}

class Owner {
  Owner({
    required this.id,
    required this.username,
    required this.email,
    required this.emailVerifiedAt,
    required this.profilePicturePath,
    required this.address,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String username;
  final String email;
  final dynamic emailVerifiedAt;
  final dynamic profilePicturePath;
  final dynamic address;
  final dynamic phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json["id"] ?? 0,
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      emailVerifiedAt: json["email_verified_at"],
      profilePicturePath: json["profile_picture_path"],
      address: json["address"],
      phoneNumber: json["phone_number"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "profile_picture_path": profilePicturePath,
    "address": address,
    "phone_number": phoneNumber,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Rent {
  Rent({
    required this.id,
    required this.propertyId,
    required this.price,
    required this.leasePeriod,
    required this.paymentPlan,
    required this.isFurnished,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int propertyId;
  final num price;
  final String leasePeriod;
  final String paymentPlan;
  final num isFurnished;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Rent.fromJson(Map<String, dynamic> json) {
    return Rent(
      id: json["id"] ?? 0,
      propertyId: json["property_id"] ?? 0,
      price: json["price"] ?? 0,
      leasePeriod: json["lease_period"] ?? "",
      paymentPlan: json["payment_plan"] ?? "",
      isFurnished: json["is_furnished"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_id": propertyId,
    "price": price,
    "lease_period": leasePeriod,
    "payment_plan": paymentPlan,
    "is_furnished": isFurnished,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Country {
  Country({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class City {
  City({
    required this.id,
    required this.countryId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int countryId;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json["id"] ?? 0,
      countryId: json["country_id"] ?? 0,
      name: json["name"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_id": countryId,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class PropertyType {
  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PropertyType({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PropertyType.fromJson(Map<String, dynamic> json) {
    return PropertyType(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Residential {
  Residential({
    required this.id,
    required this.propertyId,
    required this.bedrooms,
    required this.residentialPropertyTypeId,
    required this.createdAt,
    required this.updatedAt,
    required this.residentialPropertyType,
  });

  final int id;
  final int propertyId;
  final int bedrooms;
  final int residentialPropertyTypeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ResidentialPropertyType? residentialPropertyType;

  factory Residential.fromJson(Map<String, dynamic> json) {
    return Residential(
      id: json["id"] ?? 0,
      propertyId: json["property_id"] ?? 0,
      bedrooms: json["bedrooms"] ?? 0,
      residentialPropertyTypeId: json["residential_property_type_id"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      residentialPropertyType: json["residential_property_type"] == null
          ? null
          : ResidentialPropertyType.fromJson(json["residential_property_type"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_id": propertyId,
    "bedrooms": bedrooms,
    "residential_property_type_id": residentialPropertyTypeId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "residential_property_type": residentialPropertyType?.toJson(),
  };
}


class ResidentialPropertyType {
  ResidentialPropertyType({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ResidentialPropertyType.fromJson(Map<String, dynamic> json) {
    return ResidentialPropertyType(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
class Commercial {
  final int id;
  final int propertyId;
  final int floor;
  final int buildingNumber;
  final int apartmentNumber;
  final int commercialPropertyTypeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CommercialPropertyType? commercialPropertyType;

  Commercial({
    required this.id,
    required this.propertyId,
    required this.floor,
    required this.buildingNumber,
    required this.apartmentNumber,
    required this.commercialPropertyTypeId,
    this.createdAt,
    this.updatedAt,
    this.commercialPropertyType,
  });

  factory Commercial.fromJson(Map<String, dynamic> json) {
    return Commercial(
      id: json["id"] ?? 0,
      propertyId: json["property_id"] ?? 0,
      floor: json["floor"] ?? 0,
      buildingNumber: json["building_number"] ?? 0,
      apartmentNumber: json["apartment_number"] ?? 0,
      commercialPropertyTypeId: json["commercial_property_type_id"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      commercialPropertyType: json["commercial_property_type"] == null
          ? null
          : CommercialPropertyType.fromJson(json["commercial_property_type"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_id": propertyId,
    "floor": floor,
    "building_number": buildingNumber,
    "apartment_number": apartmentNumber,
    "commercial_property_type_id": commercialPropertyTypeId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "commercial_property_type": commercialPropertyType?.toJson(),
  };
}

class CommercialPropertyType {
  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CommercialPropertyType({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory CommercialPropertyType.fromJson(Map<String, dynamic> json) {
    return CommercialPropertyType(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
class Purchase {
  final int id;
  final int userId;
  final int propertyId;
  final num price;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Datum? property;

  Purchase({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.price,
    this.createdAt,
    this.updatedAt,
    this.property,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      propertyId: json["property_id"] ?? 0,
      price: json["price"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      property: json["property"] == null ? null : Datum.fromJson(json["property"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "property_id": propertyId,
    "price": price,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "property": property?.toJson(),
  };
}
class OffPlan {
  final int id;
  final int propertyId;
  final DateTime? deliveryDate;
  final num firstPay;
  final String payPlan;
  final num overallPayment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OffPlan({
    required this.id,
    required this.propertyId,
    this.deliveryDate,
    required this.firstPay,
    required this.payPlan,
    required this.overallPayment,
    this.createdAt,
    this.updatedAt,
  });

  factory OffPlan.fromJson(Map<String, dynamic> json) {
    return OffPlan(
      id: json["id"] ?? 0,
      propertyId: json["property_id"] ?? 0,
      deliveryDate: DateTime.tryParse(json["delivery_date"] ?? ""),
      firstPay: json["first_pay"] ?? 0,
      payPlan: json["pay_plan"] ?? "",
      overallPayment: json["overall_payment"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_id": propertyId,
    "delivery_date": deliveryDate?.toIso8601String(),
    "first_pay": firstPay,
    "pay_plan": payPlan,
    "overall_payment": overallPayment,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
