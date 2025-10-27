import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';

class IARecomiendaPage extends StatelessWidget {
  const IARecomiendaPage({super.key});

  static const String routeName = '/ia-recomienda';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IA Recomienda'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 72, color: AppColors.primary.withOpacity(0.8)),
            const SizedBox(height: 16),
            Text(
              'Estamos preparando recomendaciones personalizadas para ti.',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
