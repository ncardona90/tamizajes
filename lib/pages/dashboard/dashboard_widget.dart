import 'package:flutter/material.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_outlined,
              size: 80,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(height: 20),
            Text(
              'Página de Estadísticas',
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'En construcción',
              style: textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}