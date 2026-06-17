import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/plant.dart';
import '../providers/locale_provider.dart';
import '../providers/database_provider.dart';
import '../providers/auth_provider.dart';
import 'admin_dashboard_screen.dart';
import '../localization/app_localizations.dart';
import 'plant_details_screen.dart';
import 'search_screen.dart';
import 'scan_screen.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Color _getBadgeColor(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return const Color(0xFF2E7D32); // Deep green
      case 'medium':
        return const Color(0xFFEF6C00); // Dark orange/amber
      case 'high':
        return const Color(0xFFD84315); // Deep orange
      case 'critical':
        return const Color(0xFFC62828); // Crimson red
      default:
        return Colors.grey;
    }
  }

  TextStyle _getTextStyle(BuildContext context, {required double fontSize, required FontWeight fontWeight, required Color color, required String lang}) {
    if (lang == 'ta') {
      return GoogleFonts.notoSansTamil(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    }
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(localeProvider);
    final localizations = AppLocalizations(lang);
    final plantsAsync = ref.watch(plantsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            // App Logo
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.grass_sharp,
                color: Color(0xFF2E7D32),
                size: 28,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              localizations.translate('app_title'),
              style: _getTextStyle(
                context,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1B5E20),
                lang: lang,
              ),
            ),
          ],
        ),
        actions: [
          // Language toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  'EN',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: lang == 'en' ? const Color(0xFF2E7D32) : Colors.grey,
                  ),
                ),
                Switch(
                  value: lang == 'ta',
                  onChanged: (val) {
                    ref.read(localeProvider.notifier).state = val ? 'ta' : 'en';
                  },
                  activeColor: const Color(0xFF2E7D32),
                  activeTrackColor: const Color(0xFFC8E6C9),
                  inactiveThumbColor: const Color(0xFF757575),
                  inactiveTrackColor: const Color(0xFFE0E0E0),
                ),
                Text(
                  'தமிழ்',
                  style: GoogleFonts.notoSansTamil(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: lang == 'ta' ? const Color(0xFF2E7D32) : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Profile / Login Button
          Consumer(
            builder: (context, ref, child) {
              final user = ref.watch(authProvider);
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  iconSize: 32,
                  icon: user == null
                      ? const Icon(
                          Icons.account_circle_outlined,
                          color: Color(0xFF2E7D32),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF2E7D32), width: 1.5),
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: user.photoUrl,
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => const Icon(
                                Icons.account_circle,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ),
                        ),
                  onPressed: () {
                    if (user == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    } else if (user.role == 'admin') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DashboardScreen()),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Content (Non-scrollable)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar Button (full width, below app bar)
                  Material(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SearchScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        width: double.infinity,
                        height: 52, // Large touch target (min 48dp)
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Color(0xFF2E7D32)),
                            const SizedBox(width: 12),
                            Text(
                              localizations.translate('search_placeholder'),
                              style: _getTextStyle(
                                context,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600]!,
                                lang: lang,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // "Scan Plant" prominent button (high contrast)
                  SizedBox(
                    width: double.infinity,
                    height: 56, // Large touch target
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ScanScreen()),
                        );
                      },
                      icon: const Icon(Icons.camera_alt, size: 24, color: Colors.white),
                      label: Text(
                        localizations.translate('scan_button'),
                        style: _getTextStyle(
                          context,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          lang: lang,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        elevation: 3,
                        shadowColor: const Color(0x3D2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section Header
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      localizations.translate('section_header'),
                      style: _getTextStyle(
                        context,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B5E20),
                        lang: lang,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Grid of 30 plants (loaded asynchronously)
            Expanded(
              child: plantsAsync.when(
                data: (plants) {
                  // Filter down to isHomeFeatured plants
                  final featuredPlants = plants.where((p) => p.isHomeFeatured).toList();

                  if (featuredPlants.isEmpty) {
                    return Center(
                      child: Text(
                        lang == 'ta' ? 'தாவரங்கள் எதுவும் இல்லை' : 'No featured plants found',
                        style: _getTextStyle(
                          context,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700]!,
                          lang: lang,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.76, // Elegant card proportions
                    ),
                    itemCount: featuredPlants.length,
                    itemBuilder: (context, index) {
                      final plant = featuredPlants[index];
                      final name = lang == 'ta' ? plant.tamilName : plant.englishName;

                      return Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlantDetailsScreen(
                                  plant: plant,
                                  showVetButton: false,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Fixed Aspect Ratio Image with cached_network_image
                                  AspectRatio(
                                    aspectRatio: 1.3,
                                    child: CachedNetworkImage(
                                      imageUrl: plant.imageUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: const Color(0xFFE8F5E9),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: Color(0xFF2E7D32),
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        color: const Color(0xFFF5F5F5),
                                        child: const Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Plant Name in selected language
                                        SizedBox(
                                          height: 40, // Max 2 lines of text height
                                          child: Text(
                                            name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: _getTextStyle(
                                              context,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF1B5E20),
                                              lang: lang,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),

                                        // Toxicity level badge (accessible: text + color)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _getBadgeColor(plant.susceptibilityLevel),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            localizations.translate(plant.susceptibilityLevel),
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF2E7D32),
                  ),
                ),
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Failed to load plants: $error',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
