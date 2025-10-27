import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, this.icon, this.title, this.message});

  final IconData? icon;
  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.16),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.primary),
            ),
          if (title != null) ...[
            const SizedBox(height: 20),
            Text(title!, style: AppTextStyles.subtitle, textAlign: TextAlign.center),
          ],
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(message!, style: AppTextStyles.body, textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}
