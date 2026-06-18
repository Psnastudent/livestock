enum SusceptibilityLevel { low, medium, high, critical }

class Plant {
  final String plantId;
  final String tamilName;
  final String englishName;
  final String scientificName;
  final String description;
  final String tamilDescription;
  final String imageUrl;
  final SusceptibilityLevel susceptibilityLevel;
  final bool isEatable;
  final bool isHarmful;
  final String region;
  final String symptoms;
  final String tamilSymptoms;
  final String firstAid;
  final String tamilFirstAid;

  Plant({
    required this.plantId,
    required this.tamilName,
    required this.englishName,
    required this.scientificName,
    required this.description,
    this.tamilDescription = '',
    required this.imageUrl,
    required this.susceptibilityLevel,
    required this.isEatable,
    required this.isHarmful,
    this.region = 'India, South Asia',
    this.symptoms = 'No specific symptoms recorded.',
    this.tamilSymptoms = 'குறிப்பிட்ட அறிகுறிகள் எதுவும் இல்லை.',
    this.firstAid = 'Remove animal from source immediately. Contact vet.',
    this.tamilFirstAid = 'இந்த செடியிலிருந்து விலங்கை அப்புறப்படுத்தவும். மருத்துவரை அணுகவும்.',
  });

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      plantId: map['plantId'] ?? '',
      tamilName: map['tamilName'] ?? '',
      englishName: map['englishName'] ?? '',
      scientificName: map['scientificName'] ?? '',
      description: map['description'] ?? '',
      tamilDescription: map['tamilDescription'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      susceptibilityLevel: SusceptibilityLevel.values.firstWhere(
        (e) => e.name == (map['susceptibilityLevel'] ?? 'low'),
        orElse: () => SusceptibilityLevel.low,
      ),
      isEatable: map['isEatable'] ?? false,
      isHarmful: map['isHarmful'] ?? false,
      region: map['region'] ?? 'India, South Asia',
      symptoms: map['symptoms'] ?? 'No specific symptoms recorded.',
      tamilSymptoms: map['tamilSymptoms'] ?? 'குறிப்பிட்ட அறிகுறிகள் எதுவும் இல்லை.',
      firstAid: map['firstAid'] ?? 'Remove animal from source immediately. Contact vet.',
      tamilFirstAid: map['tamilFirstAid'] ?? 'இந்த செடியிலிருந்து விலங்கை அப்புறப்படுத்தவும். மருத்துவரை அணுகவும்.',
    );
  }
}
