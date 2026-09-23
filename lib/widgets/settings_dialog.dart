import 'package:flutter/material.dart';
import '../theme/lupin_theme.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool _discordRpc = true;
  final TextEditingController _appIdController =
      TextEditingController(text: '1552301617938825216');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: const Color(0xF2160728),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: LupinTheme.borderGlow),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 30,
              spreadRadius: 5,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.settings, color: LupinTheme.accentPink),
                    SizedBox(width: 10),
                    Text(
                      'Lupin Music Ayarları',
                      style: TextStyle(
                        color: LupinTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: LupinTheme.textSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(color: LupinTheme.borderSubtle, height: 32),

            // Discord RPC
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discord Rich Presence (RPC)',
                      style: TextStyle(color: LupinTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Çalan şarkıyı Discord profilinde ve durumunda göster',
                      style: TextStyle(color: LupinTheme.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
                Switch(
                  value: _discordRpc,
                  activeColor: LupinTheme.accentPink,
                  onChanged: (val) => setState(() => _discordRpc = val),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Discord App ID
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Discord Uygulama ID (Client ID)',
                  style: TextStyle(color: LupinTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Profilinde görünecek uygulama başlığı için ID',
                  style: TextStyle(color: LupinTheme.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: LupinTheme.borderSubtle),
                        ),
                        child: TextField(
                          controller: _appIdController,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Discord App ID kaydedildi!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LupinTheme.accentPink,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Kaydet'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // REST API status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Yerel Bot Sunucusu (Port 9863)',
                      style: TextStyle(color: LupinTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Discord botlarının lupin.music ile durumu okumasını sağlar',
                      style: TextStyle(color: LupinTheme.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: LupinTheme.statusGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: LupinTheme.statusGreen.withOpacity(0.4)),
                  ),
                  child: const Text(
                    '🟢 Aktif (9863)',
                    style: TextStyle(color: LupinTheme.statusGreen, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Copyright
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lupin Music v1.0.0 — Luxury Edition',
                  style: TextStyle(color: LupinTheme.textMuted, fontSize: 12),
                ),
                Text(
                  '© 2026 Miraç Teksaslıoğlu',
                  style: TextStyle(color: LupinTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
