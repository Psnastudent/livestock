class Hospital {
  final String name;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;

  const Hospital({
    required this.name,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });

  factory Hospital.fromMap(Map<String, dynamic> map) {
    return Hospital(
      name: map['name'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
