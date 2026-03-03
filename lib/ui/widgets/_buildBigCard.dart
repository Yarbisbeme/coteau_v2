import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  // 1. Declaramos las variables que necesita el card
  final IconData icon;
  final String title;
  final String subtitle;
  final ThemeData theme;

  // 2. Las pedimos en el constructor
  const BigCard({
    super.key, 
    required this.icon, 
    required this.title, 
    required this.subtitle, 
    required this.theme
  });

  @override
  // 3. El método DEBE llamarse 'build' y recibir solo 'context'
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 220,
        width: double.infinity,
        padding: const EdgeInsets.all(16), // Aumenté un poco el padding
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Icon(icon, color: theme.primaryColor),
            Text(title, style: theme.textTheme.titleMedium),
            Text(subtitle, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}