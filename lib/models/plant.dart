class Plant {
  final String plantId;
  final String tamilName;
  final String englishName;
  final String scientificName;
  final String localName;
  final String imageUrl;
  final bool isHomeFeatured;
  final Map<String, String> toxicityByPart; // e.g. {'leaf': 'high', 'flower': 'medium', ...}
  final String toxicComponents;
  final bool suitableForFeeding;
  final String similarPlantWarning;
  final List<String> affectedAnimals;
  final String susceptibilityLevel; // "low" | "medium" | "high" | "critical"
  final String symptomOnsetTime;
  final String symptomsText;
  final List<String> symptomImageUrls;
  final String firstAid;
  final String treatment;
  final String warningMessage;

  const Plant({
    required this.plantId,
    required this.tamilName,
    required this.englishName,
    required this.scientificName,
    required this.localName,
    required this.imageUrl,
    required this.isHomeFeatured,
    required this.toxicityByPart,
    required this.toxicComponents,
    required this.suitableForFeeding,
    required this.similarPlantWarning,
    required this.affectedAnimals,
    required this.susceptibilityLevel,
    required this.symptomOnsetTime,
    required this.symptomsText,
    required this.symptomImageUrls,
    required this.firstAid,
    required this.treatment,
    required this.warningMessage,
  });

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      plantId: map['plantId'] as String? ?? '',
      tamilName: map['tamilName'] as String? ?? '',
      englishName: map['englishName'] as String? ?? '',
      scientificName: map['scientificName'] as String? ?? '',
      localName: map['localName'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      isHomeFeatured: map['isHomeFeatured'] as bool? ?? false,
      toxicityByPart: Map<String, String>.from(map['toxicityByPart'] as Map? ?? {}),
      toxicComponents: map['toxicComponents'] as String? ?? '',
      suitableForFeeding: map['suitableForFeeding'] as bool? ?? false,
      similarPlantWarning: map['similarPlantWarning'] as String? ?? '',
      affectedAnimals: List<String>.from(map['affectedAnimals'] as List? ?? []),
      susceptibilityLevel: map['susceptibilityLevel'] as String? ?? 'low',
      symptomOnsetTime: map['symptomOnsetTime'] as String? ?? '',
      symptomsText: map['symptomsText'] as String? ?? '',
      symptomImageUrls: List<String>.from(map['symptomImageUrls'] as List? ?? []),
      firstAid: map['firstAid'] as String? ?? '',
      treatment: map['treatment'] as String? ?? '',
      warningMessage: map['warningMessage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plantId': plantId,
      'tamilName': tamilName,
      'englishName': englishName,
      'scientificName': scientificName,
      'localName': localName,
      'imageUrl': imageUrl,
      'isHomeFeatured': isHomeFeatured,
      'toxicityByPart': toxicityByPart,
      'toxicComponents': toxicComponents,
      'suitableForFeeding': suitableForFeeding,
      'similarPlantWarning': similarPlantWarning,
      'affectedAnimals': affectedAnimals,
      'susceptibilityLevel': susceptibilityLevel,
      'symptomOnsetTime': symptomOnsetTime,
      'symptomsText': symptomsText,
      'symptomImageUrls': symptomImageUrls,
      'firstAid': firstAid,
      'treatment': treatment,
      'warningMessage': warningMessage,
    };
  }
}
