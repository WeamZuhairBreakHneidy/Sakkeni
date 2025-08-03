class PropertyDetail {
  PropertyDetail({
    required this.status,
    required this.message,
    required this.data,
  });

  final bool status;
  final String message;
  final Data? data;

  factory PropertyDetail.fromJson(Map<String, dynamic> json){
    return PropertyDetail(
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
    required this.id,
    required this.locationId,
    required this.ownerId,
    required this.adminId,
    required this.area,
    required this.bathrooms,
    required this.balconies,
    required this.usersClicks,
    required this.ownershipTypeId,
    required this.propertyTypeId,
    required this.sellTypeId,
    required this.availabilityStatusId,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.amenities,
    required this.directions,
    required this.images,
    required this.propertyType,
    required this.availabilityStatus,
    required this.ownershipType,
    required this.owner,
    required this.location,
    required this.residential,
    required this.purchase,
  });

  final int id;
  final int locationId;
  final int ownerId;
  final dynamic adminId;
  final num area;
  final num bathrooms;
  final num balconies;
  final num usersClicks;
  final int ownershipTypeId;
  final int propertyTypeId;
  final int sellTypeId;
  final int availabilityStatusId;
  final dynamic description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<AvailabilityStatus> amenities;
  final List<AvailabilityStatus> directions;
  final List<Image1> images;
  final AvailabilityStatus? propertyType;
  final AvailabilityStatus? availabilityStatus;
  final AvailabilityStatus? ownershipType;
  final Owner? owner;
  final Location? location;
  final Residential? residential;
  final Purchase? purchase;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"] ?? 0,
      locationId: json["location_id"] ?? 0,
      ownerId: json["owner_id"] ?? 0,
      adminId: json["admin_id"],
      area: json["area"] ?? 0,
      bathrooms: json["bathrooms"] ?? 0,
      balconies: json["balconies"] ?? 0,
      usersClicks: json["users_clicks"] ?? 0,
      ownershipTypeId: json["ownership_type_id"] ?? 0,
      propertyTypeId: json["property_type_id"] ?? 0,
      sellTypeId: json["sell_type_id"] ?? 0,
      availabilityStatusId: json["availability_status_id"] ?? 0,
      description: json["description"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      amenities: json["amenities"] == null ? [] : List<AvailabilityStatus>.from(json["amenities"]!.map((x) => AvailabilityStatus.fromJson(x))),
      directions: json["directions"] == null ? [] : List<AvailabilityStatus>.from(json["directions"]!.map((x) => AvailabilityStatus.fromJson(x))),
      images: json["images"] == null ? [] : List<Image1>.from(json["images"]!.map((x) => Image1.fromJson(x))),
      propertyType: json["property_type"] == null ? null : AvailabilityStatus.fromJson(json["property_type"]),
      availabilityStatus: json["availability_status"] == null ? null : AvailabilityStatus.fromJson(json["availability_status"]),
      ownershipType: json["ownership_type"] == null ? null : AvailabilityStatus.fromJson(json["ownership_type"]),
      owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
      location: json["location"] == null ? null : Location.fromJson(json["location"]),
      residential: json["residential"] == null ? null : Residential.fromJson(json["residential"]),
      purchase: json["purchase"] == null ? null : Purchase.fromJson(json["purchase"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "location_id": locationId,
    "owner_id": ownerId,
    "admin_id": adminId,
    "area": area,
    "bathrooms": bathrooms,
    "balconies": balconies,
    "users_clicks": usersClicks,
    "ownership_type_id": ownershipTypeId,
    "property_type_id": propertyTypeId,
    "sell_type_id": sellTypeId,
    "availability_status_id": availabilityStatusId,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "amenities": amenities.map((x) => x.toJson()).toList(),
    "directions": directions.map((x) => x.toJson()).toList(),
    "images": images.map((x) => x.toJson()).toList(),
    "property_type": propertyType?.toJson(),
    "availability_status": availabilityStatus?.toJson(),
    "ownership_type": ownershipType?.toJson(),
    "owner": owner?.toJson(),
    "location": location?.toJson(),
    "residential": residential?.toJson(),
    "purchase": purchase?.toJson(),
  };

}

class AvailabilityStatus {
  AvailabilityStatus({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
    required this.countryId,
  });

  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Pivot? pivot;
  final int countryId;

  factory AvailabilityStatus.fromJson(Map<String, dynamic> json){
    return AvailabilityStatus(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
      countryId: json["country_id"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "pivot": pivot?.toJson(),
    "country_id": countryId,
  };

}

class Pivot {
  Pivot({
    required this.propertyId,
    required this.amenityId,
    required this.directionId,
  });

  final int propertyId;
  final int amenityId;
  final int directionId;

  factory Pivot.fromJson(Map<String, dynamic> json){
    return Pivot(
      propertyId: json["property_id"] ?? 0,
      amenityId: json["amenity_id"] ?? 0,
      directionId: json["direction_id"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "property_id": propertyId,
    "amenity_id": amenityId,
    "direction_id": directionId,
  };

}

class Image1 {
  Image1({
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

  factory Image1.fromJson(Map<String, dynamic> json){
    return Image1(
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
  final num latitude;
  final num longitude;
  final String additionalInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final AvailabilityStatus? country;
  final AvailabilityStatus? city;

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
      id: json["id"] ?? 0,
      countryId: json["country_id"] ?? 0,
      cityId: json["city_id"] ?? 0,
      latitude: json["latitude"] ?? 0,
      longitude: json["longitude"] ?? 0,
      additionalInfo: json["additional_info"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      country: json["country"] == null ? null : AvailabilityStatus.fromJson(json["country"]),
      city: json["city"] == null ? null : AvailabilityStatus.fromJson(json["city"]),
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
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.emailVerifiedAt,
    required this.profilePicturePath,
    required this.address,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final dynamic emailVerifiedAt;
  final dynamic profilePicturePath;
  final String address;
  final String phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Owner.fromJson(Map<String, dynamic> json){
    return Owner(
      id: json["id"] ?? 0,
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      email: json["email"] ?? "",
      emailVerifiedAt: json["email_verified_at"],
      profilePicturePath: json["profile_picture_path"],
      address: json["address"] ?? "",
      phoneNumber: json["phone_number"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "profile_picture_path": profilePicturePath,
    "address": address,
    "phone_number": phoneNumber,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

}

class Purchase {
  Purchase({
    required this.id,
    required this.propertyId,
    required this.price,
    required this.isFurnished,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int propertyId;
  final num price;
  final num isFurnished;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Purchase.fromJson(Map<String, dynamic> json){
    return Purchase(
      id: json["id"] ?? 0,
      propertyId: json["property_id"] ?? 0,
      price: json["price"] ?? 0,
      isFurnished: json["is_furnished"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "property_id": propertyId,
    "price": price,
    "is_furnished": isFurnished,
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
  final num bedrooms;
  final int residentialPropertyTypeId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final AvailabilityStatus? residentialPropertyType;

  factory Residential.fromJson(Map<String, dynamic> json){
    return Residential(
      id: json["id"] ?? 0,
      propertyId: json["property_id"] ?? 0,
      bedrooms: json["bedrooms"] ?? 0,
      residentialPropertyTypeId: json["residential_property_type_id"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      residentialPropertyType: json["residential_property_type"] == null ? null : AvailabilityStatus.fromJson(json["residential_property_type"]),
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
