import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';

class IARecomiendaPage extends StatelessWidget {
  const IARecomiendaPage({super.key});

  static const String routeName = '/ia-recomienda';
  final String telegramBotUrl = 'https://t.me/stailence_helper_bot';
  final String telegramWebUrl = 'https://web.telegram.org/k/#@stailence_helper_bot';

  Future<void> _launchTelegram(BuildContext context) async {
    try {
      // First try the direct web URL
      if (await canLaunchUrlString(telegramWebUrl)) {
        await launchUrlString(
          telegramWebUrl,
          mode: LaunchMode.externalApplication,
        );
      } else if (await canLaunchUrlString(telegramBotUrl)) {
        // Fallback to the app URL if web URL fails
        await launchUrlString(
          telegramBotUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // If all else fails, show a dialog with the URL to copy
        if (!context.mounted) return;
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('No se pudo abrir Telegram'),
            content: const Text('Por favor, abre Telegram manualmente y busca @stailence_helper_bot'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir Telegram. Por favor, instala la aplicación.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IA Recomienda'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              '¡Conecta con nuestro asistente de IA!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Escanea el código QR o haz clic en el botón para comenzar a chatear con nuestro asistente en Telegram',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // QR Code Image
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(
                'lib/img/qr.jpg',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 50, color: Colors.red),
                      Text('Error: $error')
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            // Telegram Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _launchTelegram(context),
                icon: const Icon(Icons.telegram, color: Colors.white),
                label: const Text(
                  'Abrir en Telegram',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0088CC), // Telegram blue
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'O copia este enlace: $telegramBotUrl',
              style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ],
        ),
      ),
    );
  }
}
