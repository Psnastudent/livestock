import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../providers/database_provider.dart';
import '../services/seeding_service.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  bool _seeding = false;
  bool _wiping = false;
  String _lastLog = '';

  // ── helpers ────────────────────────────────────────────────────────────────
  TextStyle _ts(double size, FontWeight w, Color c) =>
      GoogleFonts.inter(fontSize: size, fontWeight: w, color: c);

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(top: 28, bottom: 10),
        child: Text(text,
            style: _ts(13, FontWeight.w700, const Color(0xFF78909C))
                .copyWith(letterSpacing: 1.2)),
      );

  Widget _infoCard({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String value,
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ],
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration:
                BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title,
                style: _ts(14, FontWeight.w500, const Color(0xFF37474F))),
          ),
          Text(value,
              style: _ts(16, FontWeight.bold, const Color(0xFF1B5E20))),
        ]),
      );

  // ── Seed button action ─────────────────────────────────────────────────────
  Future<void> _handleSeed() async {
    setState(() {
      _seeding = true;
      _lastLog = '';
    });
    try {
      await SeedingService.seedDatabase();
      ref.invalidate(plantsProvider);
      if (mounted) {
        setState(() => _lastLog = '✅ Seeded successfully!');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Database seeded successfully!'),
          backgroundColor: Color(0xFF2E7D32),
        ));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _lastLog = '❌ Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Seeding failed: $e'),
          backgroundColor: const Color(0xFFC62828),
        ));
      }
    } finally {
      if (mounted) setState(() => _seeding = false);
    }
  }

  // ── Wipe confirmation ──────────────────────────────────────────────────────
  void _confirmWipe() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFC62828)),
          const SizedBox(width: 8),
          Text('Wipe Database?', style: _ts(18, FontWeight.bold, const Color(0xFFC62828))),
        ]),
        content: Text(
          'This will delete all plant and hospital records from Firestore. '
          'This action cannot be undone.',
          style: _ts(14, FontWeight.normal, Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: _ts(14, FontWeight.w600, Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() {
                _wiping = true;
                _lastLog = '';
              });
              try {
                await SeedingService.wipeDatabase();
                ref.invalidate(plantsProvider);
                if (mounted) setState(() => _lastLog = '🗑️ Database wiped.');
              } catch (e) {
                if (mounted) setState(() => _lastLog = '❌ Wipe error: $e');
              } finally {
                if (mounted) setState(() => _wiping = false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC62828),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Wipe', style: _ts(14, FontWeight.bold, Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final plantsAsync = ref.watch(plantsProvider);

    final plantCount =
        plantsAsync.when(data: (p) => '${p.length}', loading: () => '…', error: (_, __) => '—');

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(children: [
          const Icon(Icons.admin_panel_settings, size: 22),
          const SizedBox(width: 10),
          Text('Admin Panel', style: _ts(18, FontWeight.bold, Colors.white)),
        ]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () {
                ref.read(authProvider.notifier).state = null;
                Navigator.pop(context);
              },
              icon: const Icon(Icons.logout, color: Colors.white70, size: 18),
              label: Text('Logout',
                  style: _ts(13, FontWeight.w600, Colors.white70)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Admin identity card ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF1B5E20).withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6))
                ],
              ),
              child: Row(children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white.withOpacity(0.15),
                  child: const Icon(Icons.manage_accounts, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(user?.name ?? 'Admin',
                      style: _ts(18, FontWeight.bold, Colors.white)),
                  const SizedBox(height: 2),
                  Text(user?.email ?? '',
                      style: _ts(12, FontWeight.normal, Colors.white70)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text('ADMIN',
                        style: _ts(10, FontWeight.w800, Colors.white)
                            .copyWith(letterSpacing: 1.5)),
                  ),
                ]),
              ]),
            ),

            // ── Stats ────────────────────────────────────────────────────────
            _sectionTitle('DATABASE OVERVIEW'),
            _infoCard(
              icon: Icons.eco_rounded,
              iconBg: const Color(0xFF2E7D32),
              title: 'Plant Records',
              value: plantCount,
            ),
            _infoCard(
              icon: Icons.local_hospital_rounded,
              iconBg: const Color(0xFF0277BD),
              title: 'Hospital Records',
              value: '5',
            ),

            // ── Seeding controls ─────────────────────────────────────────────
            _sectionTitle('DATABASE CONTROLS'),

            // Seed button
            _actionButton(
              icon: Icons.cloud_upload_rounded,
              label: 'Seed Database',
              subtitle: 'Push all plant & hospital data to Firestore',
              color: const Color(0xFF2E7D32),
              loading: _seeding,
              onTap: _handleSeed,
            ),
            const SizedBox(height: 10),

            // Re-seed (force overwrite) button
            _actionButton(
              icon: Icons.refresh_rounded,
              label: 'Re-seed (Force Overwrite)',
              subtitle: 'Overwrite existing Firestore records',
              color: const Color(0xFF00695C),
              loading: _seeding,
              onTap: _handleSeed,
            ),
            const SizedBox(height: 10),

            // Invalidate cache button
            _actionButton(
              icon: Icons.sync_rounded,
              label: 'Refresh App Cache',
              subtitle: 'Force re-fetch all plant data in the UI',
              color: const Color(0xFF1565C0),
              loading: false,
              onTap: () {
                ref.invalidate(plantsProvider);
                setState(() => _lastLog = '🔄 Cache refreshed.');
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('App cache refreshed!'),
                  backgroundColor: Color(0xFF1565C0),
                ));
              },
            ),

            // ── Danger zone ───────────────────────────────────────────────────
            _sectionTitle('DANGER ZONE'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFCDD2), width: 1.5),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                leading: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                      color: const Color(0xFFC62828).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: _wiping
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Color(0xFFC62828), strokeWidth: 2))
                      : const Icon(Icons.delete_forever_rounded,
                          color: Color(0xFFC62828), size: 22),
                ),
                title: Text('Wipe Entire Database',
                    style: _ts(14, FontWeight.w700, const Color(0xFFC62828))),
                subtitle: Text('Permanently delete all Firestore records',
                    style: _ts(12, FontWeight.normal, Colors.grey[600]!)),
                trailing: const Icon(Icons.chevron_right, color: Color(0xFFC62828)),
                onTap: _wiping ? null : _confirmWipe,
              ),
            ),

            // ── Log output ────────────────────────────────────────────────────
            if (_lastLog.isNotEmpty) ...[
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1B2F),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  _lastLog,
                  style: GoogleFonts.sourceCodePro(
                      fontSize: 13, color: const Color(0xFF69FF47)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── action button tile helper ──────────────────────────────────────────────
  Widget _actionButton({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required bool loading,
    required VoidCallback onTap,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          leading: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10)),
            child: loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: color, strokeWidth: 2))
                : Icon(icon, color: color, size: 22),
          ),
          title: Text(label, style: _ts(14, FontWeight.w700, const Color(0xFF263238))),
          subtitle: Text(subtitle,
              style: _ts(12, FontWeight.normal, Colors.grey[500]!)),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          onTap: loading ? null : onTap,
        ),
      );
}
