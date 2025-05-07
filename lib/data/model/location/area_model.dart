class AreaModel {
  int? id;
  String? name;
  int? cityId;
  int? stateId;
  String? stateCode;
  int? countryId;
  String? createdAt;
  String? updatedAt;
  String? latitude;
  String? longitude;

  AreaModel({
    this.id,
    this.name,
    this.cityId,
    this.stateId,
    this.stateCode,
    this.countryId,
    this.createdAt,
    this.updatedAt,
    this.latitude,
    this.longitude,
  });

  AreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cityId = json['city_id'];
    stateId = json['state_id'];
    stateCode = json['state_code'];
    countryId = json['country_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['city_id'] = this.cityId;
    data['state_id'] = this.stateId;
    data['state_code'] = this.stateCode;
    data['country_id'] = this.countryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
