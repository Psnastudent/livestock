const Map<String, Map<String, String>> localizedStrings = {
  'en': {
    'app_title': 'Toxic Plant Detector',
    'search_placeholder': 'Search toxic plants...',
    'scan_button': 'Scan Plant',
    'section_header': 'Common Toxic Plants',
    'coming_soon': 'Coming Soon',
    'low': 'Low',
    'medium': 'Medium',
    'high': 'High',
    'critical': 'Critical',
    'language': 'Language',
    'english': 'English',
    'tamil': 'Tamil',
    'search_page_title': 'Search Page',
    'plant_details_title': 'Plant Details',
    'scan_flow_title': 'Scan Flow',
    'show_vet_button': 'Show Vet Button',
  },
  'ta': {
    'app_title': 'நச்சுத் தாவர கண்டறிதல்',
    'search_placeholder': 'நச்சுத் தாவரங்களைத் தேடு...',
    'scan_button': 'தாவரத்தை ஸ்கேன் செய்',
    'section_header': 'பொதுவான நச்சுத் தாவரங்கள்',
    'coming_soon': 'விரைவில் வரும்',
    'low': 'குறைந்த',
    'medium': 'நடுத்தர',
    'high': 'அதிக',
    'critical': 'மிகவும் ஆபத்தான',
    'language': 'மொழி',
    'english': 'ஆங்கிலம்',
    'tamil': 'தமிழ்',
    'search_page_title': 'தேடல் பக்கம்',
    'plant_details_title': 'தாவர விவரங்கள்',
    'scan_flow_title': 'ஸ்கேன் பக்கம்',
    'show_vet_button': 'மருத்துவரைத் தொடர்பு கொள்ளும் பொத்தான்',
  }
};

class AppLocalizations {
  final String languageCode;

  const AppLocalizations(this.languageCode);

  String translate(String key) {
    return localizedStrings[languageCode]?[key] ?? key;
  }
}
