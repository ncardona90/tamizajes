import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Red de Salud Oriente'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildActionCard(
            context: context,
            title: 'Nuevo Tamizaje de Riesgo Cardiovascular',
            icon: Icons.edit_note,
            onTap: () => context.push('/form'),
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            context: context,
            title: 'Ver Todos los Registros',
            icon: Icons.list_alt,
            // Usa context.go para que la barra de navegación también se actualice
            onTap: () => context.go('/list'),
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            context: context,
            title: 'Dashboard de Estadísticas',
            icon: Icons.bar_chart,
            onTap: () => context.go('/dashboard'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.interTight(
                    textStyle: theme.textTheme.titleMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}