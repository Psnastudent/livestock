import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_profile.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../localization/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _pinController = TextEditingController();
  bool _obscurePin = true;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color, String lang) {
    if (lang == 'ta') {
      return GoogleFonts.notoSansTamil(fontSize: fontSize, fontWeight: fontWeight, color: color);
    }
    return GoogleFonts.inter(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }

  // ── User login ────────────────────────────────────────────────────────────
  void _loginAsUser(BuildContext ctx, String lang) {
    final mockProfile = UserProfile(
      uid: 'user_001',
      name: 'Farmer User',
      email: 'user@toxicplant.app',
      photoUrl: 'https://picsum.photos/id/433/200/200',
      loginMethod: 'Mock',
      role: 'user',
      createdAt: DateTime.now(),
    );
    ref.read(authProvider.notifier).state = mockProfile;
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(lang == 'ta' ? 'வெற்றிகரமாக உள்நுழைந்தீர்கள்!' : 'Signed in as User!'),
      backgroundColor: const Color(0xFF2E7D32),
    ));
    Navigator.pop(ctx);
  }

  // ── Admin login (PIN dialog) ───────────────────────────────────────────────
  void _showAdminPinSheet(BuildContext ctx, String lang) {
    _pinController.clear();
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (sheetCtx, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B5E20).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.admin_panel_settings, color: Color(0xFF1B5E20), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        lang == 'ta' ? 'நிர்வாக அணுகல்' : 'Admin Access',
                        style: _getTextStyle(20, FontWeight.bold, const Color(0xFF1B5E20), lang),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lang == 'ta'
                        ? 'நிர்வாக PIN ஐ உள்ளிடவும்'
                        : 'Enter the admin PIN to continue',
                    style: _getTextStyle(13, FontWeight.normal, Colors.grey[600]!, lang),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    obscureText: _obscurePin,
                    style: GoogleFonts.inter(fontSize: 20, letterSpacing: 8, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '• • • •',
                      hintStyle: GoogleFonts.inter(fontSize: 18, color: Colors.grey[400]),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePin ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                        onPressed: () => setSheetState(() => _obscurePin = !_obscurePin),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        // Admin PIN is "1234" – change here for production
                        if (_pinController.text.trim() == '1234') {
                          final adminProfile = UserProfile(
                            uid: 'admin_001',
                            name: 'Admin',
                            email: 'admin@toxicplant.app',
                            photoUrl: 'https://picsum.photos/id/177/200/200',
                            loginMethod: 'PIN',
                            role: 'admin',
                            createdAt: DateTime.now(),
                          );
                          ref.read(authProvider.notifier).state = adminProfile;
                          Navigator.pop(sheetCtx); // close sheet
                          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                            content: Text(lang == 'ta' ? 'நிர்வாகியாக உள்நுழைந்தீர்கள்!' : 'Signed in as Admin!'),
                            backgroundColor: const Color(0xFF1B5E20),
                          ));
                          Navigator.pop(ctx); // back to home
                        } else {
                          ScaffoldMessenger.of(sheetCtx).showSnackBar(SnackBar(
                            content: Text(lang == 'ta' ? 'தவறான PIN' : 'Incorrect PIN. Try again.'),
                            backgroundColor: const Color(0xFFC62828),
                          ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(
                        lang == 'ta' ? 'உள்நுழைக' : 'Login as Admin',
                        style: _getTextStyle(16, FontWeight.bold, Colors.white, lang),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(localeProvider);
    final localizations = AppLocalizations(lang);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF2E7D32),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // ── Branding ──────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.grass_sharp, color: Color(0xFF2E7D32), size: 72),
              ),
              const SizedBox(height: 24),
              Text(
                localizations.translate('app_title'),
                textAlign: TextAlign.center,
                style: _getTextStyle(24, FontWeight.bold, const Color(0xFF1B5E20), lang),
              ),
              const SizedBox(height: 8),
              Text(
                lang == 'ta'
                    ? 'கால்நடைகளைப் பாதுகாப்போம், நச்சுத் தாவரங்களைக் கண்டறிவோம்.'
                    : 'Protect livestock · Identify toxic pastures',
                textAlign: TextAlign.center,
                style: _getTextStyle(13, FontWeight.normal, Colors.grey[500]!, lang),
              ),
              const Spacer(),

              // ── Login options label ───────────────────────────────────────
              Text(
                lang == 'ta' ? 'உள்நுழைவு வகையைத் தேர்வு செய்யவும்' : 'Choose how to sign in',
                style: _getTextStyle(13, FontWeight.w500, Colors.grey[600]!, lang),
              ),
              const SizedBox(height: 16),

              // ── User Login Button ─────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _loginAsUser(context, lang),
                  icon: const Icon(Icons.person_outline, color: Colors.white, size: 22),
                  label: Text(
                    lang == 'ta' ? 'பயனராக உள்நுழையவும்' : 'Continue as User',
                    style: _getTextStyle(16, FontWeight.bold, Colors.white, lang),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    elevation: 2,
                    shadowColor: const Color(0x3D2E7D32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // ── Admin Login Button ────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () => _showAdminPinSheet(context, lang),
                  icon: const Icon(Icons.admin_panel_settings_outlined, color: Color(0xFF1B5E20), size: 22),
                  label: Text(
                    lang == 'ta' ? 'நிர்வாகியாக உள்நுழையவும்' : 'Admin Login',
                    style: _getTextStyle(16, FontWeight.bold, const Color(0xFF1B5E20), lang),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2E7D32), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
