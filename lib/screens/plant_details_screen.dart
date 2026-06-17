import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/plant.dart';
import '../providers/locale_provider.dart';
import '../localization/app_localizations.dart';

class PlantDetailsScreen extends ConsumerWidget {
  final Plant plant;
  final bool showVetButton;

  const PlantDetailsScreen({
    super.key,
    required this.plant,
    required this.showVetButton,
  });

  Color _getBadgeColor(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.amber[700]!;
      case 'high':
        return Colors.orange[850]!;
      case 'critical':
        return Colors.red[800]!;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(localeProvider);
    final localizations = AppLocalizations(lang);
    final isTamil = lang == 'ta';
    final plantName = isTamil ? plant.tamilName : plant.englishName;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('plant_details_title')),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                plant.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: Colors.green[50],
                  child: Icon(Icons.broken_image, size: 64, color: Colors.green[300]),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Plant Name
            Text(
              plantName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green[900],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Scientific Name: ${plant.englishName}',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),

            // Toxicity Level Badge
            Row(
              children: [
                Text(
                  '${localizations.translate('section_header')}: ',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getBadgeColor(plant.susceptibilityLevel),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    localizations.translate(plant.susceptibilityLevel),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Show Vet Button Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.green[800]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${localizations.translate('show_vet_button')}: ${showVetButton.toString()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Back Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
