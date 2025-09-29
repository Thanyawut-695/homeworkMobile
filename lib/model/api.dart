class API {
  int? aqi;
  String? city;
  num? temp;

  API({this.aqi, this.city, this.temp});

  API.fromJson(Map<String, dynamic> json)
    :aqi = json['data']['aqi'],
      city = json['data']['city']['name'] ?? 'Unknown',
      temp = json['data']['iaqi']['t']['v'] ?? 0;


  Map<String, dynamic> toJson() {
    return {
      'aqi': aqi,
      'city': city,
      'temp': temp,
    };
  }
}